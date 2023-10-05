function Tariff=f_ProposedTariff(C,BranchData,History,mpc)
MaxNetworkUsage=max(abs(History.Network'));
ResidualCosts=zeros(19,1);
IncrementalPayment=zeros(20,24,19);
GenDispatch=zeros(20,1);
IncrThreshold=0.6;
for branch=1:19
    if MaxNetworkUsage(branch)<IncrThreshold*BranchData(branch,5)
        ResidualCosts(branch)=ResidualCosts(branch)+BranchData(branch,7);
    else
        [NumHours,a]=find(abs(History.Network(branch,:))>=IncrThreshold*BranchData(branch,5));%¿Cuantas horas hay por encima del límite?
        IncrementalCost=BranchData(branch,8)/sum(NumHours); %el coste de inversión se divide entre el número de horas que están por encima del límite,
        for i=1:length(a) %cada consumidor paga según su contribución a cada hora
            h=a(i);
            mpc.bus(:,3)=[0;0;C.Cons(1,h);C.Cons(2,h);0;0;0;C.Cons(3,h);C.Cons(4,h);0;0;C.Cons(5,h);C.Cons(6,h);0;C.Cons(7,h);0;C.Cons(8,h);C.Cons(9,h);0;0];
            mpc.gen(4,2)=History.Generation(4,h);
            results=runpf_no_print(mpc);
            PTDF=round(makePTDF(mpc,1),1);%PTDF calculation to allocate costs among beneficiaries according to their contribution to network element congestion
            GenDispatch(results.gen(:,1),1)=results.gen(:,2);
            Dispatch=GenDispatch-results.bus(:,3);
            NetworkVarCosts=(PTDF.*Dispatch')./(PTDF*Dispatch);
            for c=1:length(Dispatch)
                IncrementalPayment(c,h,branch)=IncrementalCost*NetworkVarCosts(branch,c);
            end
        end
        ResidualCosts(branch)=BranchData(branch,7)-sum(IncrementalPayment(:,:,branch),[1 2]);
    end
end
clear branch i h c NumHours a Dispatch GenDispatch IncrementalCost MaxNetworkUsage NetworkVarCosts PTDF
%% Allocate residual costs among consumers
option=1;
ResidualCostAllocation=[0.0001;0.8;0.1999];%From Anexo 2 de la circular 3/2020 CNMC
if option==1 %Contracted capacity at periods 1 and 2 
    for c=1:size(C.Cons,1)
            C.ResidualPayment(c)=sum(ResidualCosts)*ResidualCostAllocation(C.ConsumerClass(c))*sum(C.ContractedCapacity(c,1:2))/sum(sum(C.ContractedCapacity(C.ConsumerClass==C.ConsumerClass(c),1:2)));
    end
elseif option==2 %historical consumption
     %For this case study: historical consumption is equal to actual consumption of each consumer
    for c=1:size(C.Cons,1)
            C.ResidualPayment(c)=sum(ResidualCosts)*ResidualCostAllocation(C.ConsumerClass(c))*sum(C.Cons(c))/sum(sum(C.Cons(ConsumerClass==ConsumerClass(c))));
    end     
end
clear c option 
%% Proposed tariff: incremental charges + residual charges
MatrixCons_Bus=[3 4 8 9 12 13 15 17 18];
MatrixGen_Bus=[1 6 11 20];
for c=1:size(C.Cons,1)
    Tariff.ConsCapacity(c,:)=sum(IncrementalPayment(MatrixCons_Bus(c),:,:),3)./C.Cons(c,:);
    Tariff.ConsCapacity(c,isnan(Tariff.ConsCapacity(c,:)))=0;
    Tariff.ConsFix(c,:)=C.ResidualPayment(c)';
    Tariff.AnnualPayment(c,1)=(sum(Tariff.ConsCapacity(c,:).*C.Cons(c,:))+Tariff.ConsFix(c,:));
    Tariff.AnnualPayment(c,2)=sum(Tariff.ConsCapacity(c,:).*C.Cons(c,:));
    Tariff.AnnualPayment(c,3)=Tariff.ConsFix(c,:);
end
for g=1:size(History.Generation,1)
    Tariff.GenEnergy(g,:)=sum(IncrementalPayment(MatrixGen_Bus(g),:,:),3)./History.Generation(g,:);
end