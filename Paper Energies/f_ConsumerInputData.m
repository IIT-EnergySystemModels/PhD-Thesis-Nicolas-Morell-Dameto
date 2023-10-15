function [Consumers,Generator]=f_ConsumerInputData(PV,PVConsumer)

% pathcluster2='D:\OneDrive - Universidad Pontificia Comillas\Nicolas\Tesis\DatosIBERDROLA\Clustering\Resultados\Clust_V_centroide_1\Category_2_09012020112725';
% addpath(pathcluster2);
% pathcluster3='D:\OneDrive - Universidad Pontificia Comillas\Nicolas\Tesis\DatosIBERDROLA\Clustering\Resultados\Clust_V_centroide_1\Category_3_09012020112725';
% addpath(pathcluster3);
% pathcluster5='D:\OneDrive - Universidad Pontificia Comillas\Nicolas\Tesis\DatosIBERDROLA\Clustering\Resultados\Clust_V_centroide_1\Category_5_09012020112725';
% addpath(pathcluster5);
addpath('InputData')
load('History_Norm_C_T2_1_cat_5_09012020112725.mat');
ConsumerInputData=HistoryTDs{3,1}{6,3}(1:2,:);
load('History_Norm_C_T2_1_cat_3_09012020112725.mat');
ConsumerInputData=[ConsumerInputData;HistoryTDs{3,1}{4,3}];
load('History_Norm_C_T2_1_cat_2_09012020112725.mat');
ConsumerInputData=[ConsumerInputData;HistoryTDs{3,1}{1,3}];

%%Hasta aquí se tienen los valores de los cluster más poblados de las categorías 2, 3 y 5
%% Ahora se aplican los valores deseados para el test (en MW)
Consumers.ConsumerClass=[1,1,2,2,3,3,3,3,3];%Three voltage levels: HV, MV y LV for consumers 
AverageConsumption=[10,5,2,1,0.005,0.005,0.005,0.005,0.005];

DailyConsumption=AverageConsumption*24;
Consumers.Cons=ConsumerInputData.*DailyConsumption'./sum(ConsumerInputData,2);
%% PV Generation is taken from Spanish PV generation for March 14th 2019
Generator=[7.1;7.1;7.1;7.1;7.1;7.1;46.6;171.4;959.1;2018.0;2760.5;3232.9;3477.6;3530.4;3402.5;3094.0;2537.3;1677.0;669.8;122.2;62.0;47.7;14.3;14.3];
InstalledCapacityPVGen=0.01;
Generator=Generator/max(Generator)*InstalledCapacityPVGen;
%We introduce PV panel
if PV==1
    InstalledCapacityPVGen=Consumers.Cons(PVConsumer,14)*0.95;% Hour 14 is the one of highest generation
    Generator=Generator/max(Generator)*InstalledCapacityPVGen;
    Consumers.Cons(PVConsumer,:)=Consumers.Cons(PVConsumer,:)-Generator';
end
%% Contracted capacity calculation
ContractedCapSteps=[0.001:.0001:0.01499,0.015:0.01:1,1:0.1:15];
Consumers.TimePeriods=[3;3;3;3;3;3;3;3;2;1;1;1;1;1;2;2;2;2;1;1;1;1;2;2];
Consumers.ContractedCapacity=zeros(size(Consumers.Cons,1),3);
for i=1:size(Consumers.Cons,1)
    for t=1:max(Consumers.TimePeriods)
        Consumers.ContractedCapacity(i,t)=ContractedCapSteps(find(ContractedCapSteps>max(Consumers.Cons(i,Consumers.TimePeriods==t)),1));
    end
end
