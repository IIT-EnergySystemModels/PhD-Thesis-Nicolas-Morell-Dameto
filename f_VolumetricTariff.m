function Tariff=f_VolumetricTariff(C,BranchData,History)
CostPerZone=zeros(max(BranchData(:,6)),1);
for z=1:max(BranchData(:,6))
    CostPerZone(z,1)=sum(BranchData(BranchData(:,6)==z,7));
end
ConsumptionPerZone=zeros(max(C.ConsumerClass),24);
for z=1:max(C.ConsumerClass)
    ConsumptionPerZone(z,:)=sum(C.Cons(C.ConsumerClass==z,:));
end
% [~,I]=sort(ConsumptionPerZone,2,'descend');
% NumPeakHours=5;
% I=sort(I(:,1:NumPeakHours),2);
% I=C.TimePeriods(I);
% I2=zeros(max(C.ConsumerClass),max(C.TimePeriods));
% for t=1:max(C.TimePeriods)
%     for z=1:max(C.ConsumerClass)
%         I2(z,t)=sum(I(z,:)==t);
%     end
% end
% I2=I2/5;
%I2=[sum(C.TimePeriods==1),sum(C.TimePeriods==2),sum(C.TimePeriods==3)]/24;
EnergyCharge=CostPerZone(:,1);
%% MODELO EN CASCADA
CoefE=zeros((max(C.ConsumerClass)^2+max(C.ConsumerClass))/2,1);
EnergiaConsumida=zeros(max(C.ConsumerClass),1);
    EnergiaConsumida(1)=sum(C.Cons(1,:))+sum(C.Cons(2,:));
    EnergiaConsumida(2)=sum(C.Cons(3,:))+sum(C.Cons(4,:));
    EnergiaConsumida(3)=sum(C.Cons(5,:))+sum(C.Cons(6,:))+sum(C.Cons(7,:))+sum(C.Cons(8,:))+sum(C.Cons(9,:));
    TablaCNMC=zeros(max(C.ConsumerClass),max(C.ConsumerClass)+1);
    TablaCNMC(1,1)=sum(History.Generation(1,:));
    TablaCNMC(1,2)=sum(History.Network(4,:));
    TablaCNMC(1,4)=EnergiaConsumida(1);
    TablaCNMC(2,1)=sum(History.Generation(2,:));
    TablaCNMC(2,3)=sum(History.Network(9,:));
    TablaCNMC(2,4)=EnergiaConsumida(2);
    TablaCNMC(3,1)=sum(History.Generation(3,:))+sum(History.Generation(4,:));
    TablaCNMC(3,4)=EnergiaConsumida(3);
    CoefE(1)=1;
    CoefE(2)=TablaCNMC(2,4)/sum(TablaCNMC(2,3:4));
    CoefE(3)=TablaCNMC(2,3)/sum(TablaCNMC(2,3:4));
    CoefE(4)=TablaCNMC(1,4)/sum(TablaCNMC(1,2:4));
    CoefE(5)=TablaCNMC(1,2)/sum(TablaCNMC(1,2:4))*CoefE(2);
    CoefE(6)=TablaCNMC(1,3)/sum(TablaCNMC(1,2:4))+TablaCNMC(1,2)/sum(TablaCNMC(1,2:4))*CoefE(3);
    
%Asignamos costes con coeficientes
    AllocatedCosts.Energy(3)=EnergyCharge(3)*CoefE(1)+EnergyCharge(2)*CoefE(3)+EnergyCharge(1)*CoefE(6);
    AllocatedCosts.Energy(2)=EnergyCharge(2)*CoefE(2)+EnergyCharge(1)*CoefE(5);
    AllocatedCosts.Energy(1)=EnergyCharge(1)*CoefE(4);
   
%Calculamos la tarifa
    for z=1:3
        Tariff.Energy(z)=AllocatedCosts.Energy(z)/EnergiaConsumida(z);
    end

for c=1:size(C.Cons,1)
    for h=1:24
        Tariff.ConsEnergy(c,h)=Tariff.Energy(C.ConsumerClass(c));
    end
    Tariff.AnnualPayment(c)=sum(Tariff.ConsEnergy(c,:).*C.Cons(c,:));
end
