function [TestResult,RecovPerZone]=f_TestRecoveredCosts(C,BranchData,History,TariffCNMC,ProposedTariff,VolumetricTariff)
for p=1:3
    EnergiaConsumida(1,p)=sum(C.Cons(1,C.TimePeriods==p))+sum(C.Cons(2,C.TimePeriods==p));
    EnergiaConsumida(2,p)=sum(C.Cons(3,C.TimePeriods==p))+sum(C.Cons(4,C.TimePeriods==p));
    EnergiaConsumida(3,p)=sum(C.Cons(5,C.TimePeriods==p))+sum(C.Cons(6,C.TimePeriods==p))+sum(C.Cons(7,C.TimePeriods==p))+sum(C.Cons(8,C.TimePeriods==p))+sum(C.Cons(9,C.TimePeriods==p));
end
RecoveredCosts=0;
RecovPerZone=zeros(3,3);
for z=1:3
    RecoveredCosts=RecoveredCosts+sum(TariffCNMC.Capacity(z,:).*sum(C.ContractedCapacity(C.ConsumerClass==z,:)));
    RecoveredCosts=RecoveredCosts+sum(TariffCNMC.Energy(z,:).*EnergiaConsumida(z,:));
    RecovPerZone(z,2)=RecovPerZone(z,2)+sum(TariffCNMC.Capacity(z,:).*sum(C.ContractedCapacity(C.ConsumerClass==z,:)));
    RecovPerZone(z,2)=RecovPerZone(z,2)+sum(TariffCNMC.Energy(z,:).*EnergiaConsumida(z,:));

end
if sum(BranchData(:,7))-RecoveredCosts>0.1
    errordlg('Regulated income is not equal to regulated cost applying CNMC Tariff');
    error(' ');
end
RecoveredCosts=sum(ProposedTariff.ConsCapacity.*C.Cons,'all')+sum(ProposedTariff.ConsFix)+sum(sum(ProposedTariff.GenEnergy.*History.Generation,'omitnan'));
RecovPerZone(1,1)=sum(ProposedTariff.ConsCapacity(1:2,:).*C.Cons(1:2,:),'all')+sum(ProposedTariff.ConsFix(1:2))+sum(ProposedTariff.GenEnergy(1,:).*History.Generation(1,:),'all');
RecovPerZone(2,1)=sum(ProposedTariff.ConsCapacity(3:4,:).*C.Cons(3:4,:),'all')+sum(ProposedTariff.ConsFix(3:4))+sum(ProposedTariff.GenEnergy(2,:).*History.Generation(2,:),'all');
RecovPerZone(3,1)=sum(ProposedTariff.ConsCapacity(5:9,:).*C.Cons(5:9,:),'all')+sum(ProposedTariff.ConsFix(5:9))+sum(sum(ProposedTariff.GenEnergy(3:4,:).*History.Generation(3:4,:),'omitnan'));

if sum(BranchData(:,7))-RecoveredCosts>0.1
    errordlg('Regulated income is not equal to regulated cost applying Proposed Tariff');
    error(' ');
end
RecoveredCosts=sum(VolumetricTariff.ConsEnergy.*C.Cons,'all');
RecovPerZone(1,3)=sum(VolumetricTariff.ConsEnergy(1:2,:).*C.Cons(1:2,:),'all');
RecovPerZone(2,3)=sum(VolumetricTariff.ConsEnergy(3:4,:).*C.Cons(3:4,:),'all');
RecovPerZone(3,3)=sum(VolumetricTariff.ConsEnergy(5:9,:).*C.Cons(5:9,:),'all');
if sum(BranchData(:,7))-RecoveredCosts>0.1
    errordlg('Regulated income is not equal to regulated cost applying Volumetric Tariff');
    error(' ');
end
TestResult=true;
