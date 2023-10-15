function Tariff=f_TarifasCNMC(BranchData,C,History)
% La CNMC tiene en cuenta los costes de mantenimiento y el rédito de los activos
% los cuales se dividen por nivel de tensión, según dónde están situados (NT0-NT4)
CostPerZone=zeros(max(BranchData(:,6)),1);
for z=1:max(BranchData(:,6))
    CostPerZone(z,1)=sum(BranchData(BranchData(:,6)==z,7));
end
% Después se dividen estos costes entre potencia y energía según los
% inductores de coste (principalmente a traves de término de potencia).
EnergyCapacityAllocation=[1 0;0.75 0.25; 0.75 0.25];
CostPerZone(:,2:3)=CostPerZone(:,1).*EnergyCapacityAllocation;
% Se agregan los consumidores por nivel de tensión
% Después se calculan las horas pico de cada nivel de tensión (2000 horas),
% Para nuestro caso que tiene 24 horas, el número de horas pico es 5.
% Aquí surge un problema de la simplificación: con estos datos, si el pico
% de demanda se representa con menos de 14 horas, el periodo 3 no está
% representado en algunos niveles de tensión (CNMC tiene el mismo problema)
ConsumptionPerZone=zeros(max(C.ConsumerClass),24);
for z=1:max(C.ConsumerClass)
    ConsumptionPerZone(z,:)=sum(C.Cons(C.ConsumerClass==z,:));
end
[~,I]=sort(ConsumptionPerZone,2,'descend');
NumPeakHours=8;
I=sort(I(:,1:NumPeakHours),2);
I=C.TimePeriods(I);
I2=zeros(max(C.ConsumerClass),max(C.TimePeriods));
for t=1:max(C.TimePeriods)
    for z=1:max(C.ConsumerClass)
        I2(z,t)=sum(I(z,:)==t);
    end
end
I2=I2/NumPeakHours;
% La primera simplificación que se hace es que no se tienen en cuenta
% estacionalidades propuestas por la CNMC debido a la dificultad de
% comparar tarifas con tantas variables
% Se asigna a cada periodo horario el coste proporcional a la cantidad de horas que
% que se encuentran dentro de la punta del nivel de tensión. 
% Se hace esto tanto para el término de potencia como el de energía
% Entonces ya se tiene lo que tiene que pagar cada nivel de tensión en cada
% periodo horario tanto en potencia como en energía.
CapacityCharge=CostPerZone(:,2).*I2;
EnergyCharge=CostPerZone(:,3).*I2;
%% MODELO EN CASCADA
% Ahora se aplica el modelo en cascada ya que los responsables de los
% costes de un nivel de tensión son los ususarios conectados a ese nivel
% de tensión y los usuarios conectados a niveles de tensión inferiores.
% Para calcular cómo se divide el coste (de un nivel de tensión y periodo)
% entre los niveles de tensión responsables se utiliza el balance de 
% potencia/energía en la hora de máxima demanda de cada uno de los 6
% periodos
% Para determinar la hora de máxima demanda de cada periodo sumamos todos 
% los consumos para cada hora y buscamos el máximo de cada periodo
TotalConsumption=sum(C.Cons);
CoefE=zeros((max(C.ConsumerClass)^2+max(C.ConsumerClass))/2,max(C.TimePeriods));
CoefP=zeros((max(C.ConsumerClass)^2+max(C.ConsumerClass))/2,max(C.TimePeriods));
EnergiaConsumida=zeros(max(C.ConsumerClass),max(C.TimePeriods));
HourMaxConsumption=zeros(1,max(C.TimePeriods));
for p=1:max(C.TimePeriods)
    EnergiaConsumida(1,p)=sum(C.Cons(1,C.TimePeriods==p))+sum(C.Cons(2,C.TimePeriods==p));
    EnergiaConsumida(2,p)=sum(C.Cons(3,C.TimePeriods==p))+sum(C.Cons(4,C.TimePeriods==p));
    EnergiaConsumida(3,p)=sum(C.Cons(5,C.TimePeriods==p))+sum(C.Cons(6,C.TimePeriods==p))+sum(C.Cons(7,C.TimePeriods==p))+sum(C.Cons(8,C.TimePeriods==p))+sum(C.Cons(9,C.TimePeriods==p));
    TablaCNMC_E=zeros(max(C.ConsumerClass),max(C.ConsumerClass)+1);
    TablaCNMC_E(1,1)=sum(History.Generation(1,C.TimePeriods==p));
    TablaCNMC_E(1,2)=sum(History.Network(4,C.TimePeriods==p));
    TablaCNMC_E(1,4)=EnergiaConsumida(1,p);
    TablaCNMC_E(2,1)=sum(History.Generation(2,C.TimePeriods==p));
    TablaCNMC_E(2,3)=sum(History.Network(9,C.TimePeriods==p));
    TablaCNMC_E(2,4)=EnergiaConsumida(2,p);
    TablaCNMC_E(3,1)=sum(History.Generation(3,C.TimePeriods==p))+sum(History.Generation(4,C.TimePeriods==p));
    TablaCNMC_E(3,4)=EnergiaConsumida(3,p);
    CoefE(1,p)=1;
    CoefE(2,p)=TablaCNMC_E(2,4)/sum(TablaCNMC_E(2,3:4));
    CoefE(3,p)=TablaCNMC_E(2,3)/sum(TablaCNMC_E(2,3:4));
    CoefE(4,p)=TablaCNMC_E(1,4)/sum(TablaCNMC_E(1,2:4));
    CoefE(5,p)=TablaCNMC_E(1,2)/sum(TablaCNMC_E(1,2:4))*CoefE(2,p);
    CoefE(6,p)=TablaCNMC_E(1,3)/sum(TablaCNMC_E(1,2:4))+TablaCNMC_E(1,2)/sum(TablaCNMC_E(1,2:4))*CoefE(3,p);
    
%Cuando ya tenemos la hora máxima, vemos cuanto pasa a traves de cada
%transformador en esa hora, con lo que tenemos los flujos entre niveles de
%tensión
    [~,HourMaxConsumption(p)]=find(TotalConsumption==max(TotalConsumption(C.TimePeriods==p)));
    h=HourMaxConsumption(p);
    TablaCNMC_P=zeros(max(C.ConsumerClass),max(C.ConsumerClass)+1);
    TablaCNMC_P(1,1)=History.Generation(1,h);
    TablaCNMC_P(1,2)=History.Network(4,h);
    TablaCNMC_P(1,4)=C.Cons(1,h)+C.Cons(2,h);
    TablaCNMC_P(2,1)=History.Generation(2,h);
    TablaCNMC_P(2,3)=History.Network(9,h);
    TablaCNMC_P(2,4)=C.Cons(3,h)+C.Cons(4,h);
    TablaCNMC_P(3,1)=History.Generation(3,h)+History.Generation(4,h);
    TablaCNMC_P(3,4)=C.Cons(5,h)+C.Cons(6,h)+C.Cons(7,h)+C.Cons(8,h)+C.Cons(9,h);
    CoefP(1,p)=1;
    CoefP(2,p)=TablaCNMC_P(2,4)/sum(TablaCNMC_P(2,3:4));
    CoefP(3,p)=TablaCNMC_P(2,3)/sum(TablaCNMC_P(2,3:4));
    CoefP(4,p)=TablaCNMC_P(1,4)/sum(TablaCNMC_P(1,2:4));
    CoefP(5,p)=TablaCNMC_P(1,2)/sum(TablaCNMC_P(1,2:4))*CoefP(2,p);
    CoefP(6,p)=TablaCNMC_P(1,3)/sum(TablaCNMC_P(1,2:4))+TablaCNMC_P(1,2)/sum(TablaCNMC_P(1,2:4))*CoefP(3,p);
%Asignamos costes con coeficientes
    AllocatedCosts.Capacity(3,p)=CapacityCharge(3,p)*CoefP(1,p)+CapacityCharge(2,p)*CoefP(3,p)+CapacityCharge(1,p)*CoefP(6,p);
    AllocatedCosts.Capacity(2,p)=CapacityCharge(2,p)*CoefP(2,p)+CapacityCharge(1,p)*CoefP(5,p);
    AllocatedCosts.Capacity(1,p)=CapacityCharge(1,p)*CoefP(4,p);
    AllocatedCosts.Energy(3,p)=EnergyCharge(3,p)*CoefE(1,p)+EnergyCharge(2,p)*CoefE(3,p)+EnergyCharge(1,p)*CoefE(6,p);
    AllocatedCosts.Energy(2,p)=EnergyCharge(2,p)*CoefE(2,p)+EnergyCharge(1,p)*CoefE(5,p);
    AllocatedCosts.Energy(1,p)=EnergyCharge(1,p)*CoefE(4,p);

%Calculamos la tarifa
    for z=1:3
        Tariff.Energy(z,p)=AllocatedCosts.Energy(z,p)/EnergiaConsumida(z,p);
        Tariff.Capacity(z,p)=AllocatedCosts.Capacity(z,p)/sum(C.ContractedCapacity(C.ConsumerClass==z,p));
    end
end
for c=1:size(C.Cons,1)
    for h=1:24
        Tariff.ConsEnergy(c,h)=Tariff.Energy(C.ConsumerClass(c),C.TimePeriods(h));
    end
    for p=1:3
        Tariff.ConsCapacity(c,p)=Tariff.Capacity(C.ConsumerClass(c),p);
    end
    Tariff.AnnualPayment(c,1)=sum(Tariff.ConsEnergy(c,:).*C.Cons(c,:))+sum(Tariff.ConsCapacity(c,:).*C.ContractedCapacity(c,:));
    Tariff.AnnualPayment(c,2)=sum(Tariff.ConsEnergy(c,:).*C.Cons(c,:));
    Tariff.AnnualPayment(c,3)=sum(Tariff.ConsCapacity(c,:).*C.ContractedCapacity(c,:));
end
