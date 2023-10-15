tic
clear;clc;close all
PV=0;
[C,G]=f_ConsumerInputData(PV,0);
startup %Add MatPower paths
[BranchData,mpc]=f_NetworkData;%Initialize grid
History.Network=zeros(19,24);
for h=1:24
    mpc.bus(:,3)=[0;0;C.Cons(1,h);C.Cons(2,h);0;0;0;C.Cons(3,h);C.Cons(4,h);0;0;C.Cons(5,h);C.Cons(6,h);0;C.Cons(7,h);0;C.Cons(8,h);C.Cons(9,h);0;0];
    mpc.gen(4,2)=0;%G(h)
    results=runpf_no_print(mpc);
    History.Generation(:,h)=results.gen(:,2);
    History.Network(:,h)=round(results.branch(:,14),6);
end
clear h
%% Proposed tariff
ProposedTariff=f_ProposedTariff(C,BranchData,History,mpc);
%% CNMC Tariff
TariffCNMC=f_TarifasCNMC(BranchData,C,History);
%% Volumetric tariff
VolumetricTariff=f_VolumetricTariff(C,BranchData,History);
%% Test Cost Recovery
[TestResult,RecovPerZone]=f_TestRecoveredCosts(C,BranchData,History,TariffCNMC,ProposedTariff,VolumetricTariff);
%% Show graph of one consumer's payments
Consumer=6;
f_ShowBarGraph_V3(Consumer,ProposedTariff,TariffCNMC,VolumetricTariff,PV)
%% PV panel case
PV=1;
[CPV,G]=f_ConsumerInputData(PV,Consumer);
mpcPV=mpc;
HistoryPV.Network=zeros(19,24);
for h=1:24
    mpcPV.bus(:,3)=[0;0;CPV.Cons(1,h);CPV.Cons(2,h);0;0;0;CPV.Cons(3,h);CPV.Cons(4,h);0;0;CPV.Cons(5,h);CPV.Cons(6,h);0;CPV.Cons(7,h);0;CPV.Cons(8,h);CPV.Cons(9,h);0;0];
    mpcPV.gen(4,2)=G(h);
    results=runpf_no_print(mpcPV);
    HistoryPV.Generation(:,h)=results.gen(:,2);
    HistoryPV.Network(:,h)=round(results.branch(:,14),2);
end
clear h
ProposedTariffPV=f_ProposedTariff(CPV,BranchData,HistoryPV,mpcPV);
TariffCNMCPV=f_TarifasCNMC(BranchData,CPV,HistoryPV);
VolumetricTariffPV=f_VolumetricTariff(CPV,BranchData,HistoryPV);
[TestResult,RecovPerZone]=f_TestRecoveredCosts(CPV,BranchData,HistoryPV,TariffCNMCPV,ProposedTariffPV,VolumetricTariffPV);
f_ShowBarGraph_V3(Consumer,ProposedTariffPV,TariffCNMCPV,VolumetricTariffPV,PV)
toc
