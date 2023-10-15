function f_ShowBarGraph_V3(Consumer,ProposedTariff,TariffCNMC,VolumetricTariff,PV)

colours=[0.00,0.45,0.74;0.85,0.33,0.10;0.93,0.69,0.13];
DiffColor=0.15;
Day2year=200;
MW2kW=1/1000;
Euro2cEuro=100;
if PV==0
    %set(gcf,'Position',[0, 0, 960, 960])
    WithoutPV=figure;
    set(gcf,'Position',[0, 0, 700, 960])
else
    WithPV=figure;
    set(gcf,'Position',[700, 0, 700, 960])
end
%% Volumetric tariff
subplot(4,2,[1 2])
b=bar([VolumetricTariff.ConsEnergy(Consumer,:)'].*MW2kW/Day2year*Euro2cEuro,'BarWidth',0.4,'FaceColor','flat');
title('Volumetric Charges')
ylabel('c€/kWh')
xlabel('Hour')
ylim([0 2])
b(1).CData = repmat(colours(3,:),24,1);
%% Volumetric CNMC
subplot(4,2,3)
b=bar([TariffCNMC.ConsEnergy(Consumer,:)'].*MW2kW/Day2year*Euro2cEuro,'FaceColor','flat');
title('Volumetric Charges')
ylabel('c€/kWh')
xlabel('Hour')
ylim([0 0.8])
b(1).CData = repmat(colours(2,:),24,1);
%% Capacity CNMC
subplot(4,2,4)
b=bar(TariffCNMC.ConsCapacity(Consumer,:)'.*MW2kW,'FaceColor','flat');
title('Contracted capacity charges')
ylabel('€/kW & year')
xlabel('Period')
ylim([0 20])
%legend({'1.H9-H13 & H18-H21','2.H8 & H14-H17 & H22-H24','3.H1-H7'});
b(1).CData = repmat(colours(2,:)+DiffColor,3,1);
%% Efficient Capacity
subplot(4,2,5)
bar(ProposedTariff.ConsCapacity(Consumer,:)'.*MW2kW)
title('      Peak-coincident capacity charges')
ylabel('€/kW & year')
xlabel('Hour')
ylim([0 30])
%% Efficient Fixed
subplot(4,2,6)
b=bar(ProposedTariff.ConsFix(Consumer),'FaceColor','flat');
title('Fixed Charges')
ylabel('€/year')
ylim([0 250])
b(1).CData = colours(1,:)+DiffColor;
%% Annual payments
subplot(4,2,[7 8])
varnames=categorical({'1.Forward-looking tariff','2.Accounting approach tariff','3.Volumetric Tariff'});
b=bar(varnames,[ProposedTariff.AnnualPayment(Consumer,2:3); TariffCNMC.AnnualPayment(Consumer,2:3); [VolumetricTariff.AnnualPayment(Consumer),0]],'stacked','BarWidth',0.4,'FaceColor','flat');
title('Annual Payments')
ylabel('€')
ylim([0 1300])
for k = 1:3
    b(1).CData(k,:) = colours(k,:);
    b(2).CData(k,:) = colours(k,:)+DiffColor;
end
% 
%  plot([C.Cons(5:9,:)*1000]')
% xlabel('Hour')
% ylabel('Energy consumption, in kW')
% legend
% legend({'C5','C6','C7','C8','C9'})
