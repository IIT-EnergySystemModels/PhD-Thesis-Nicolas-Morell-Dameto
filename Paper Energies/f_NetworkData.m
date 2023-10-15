function [BranchData,mpc]=f_NetworkData
%-----  Power Flow Data  -----%%
mpc.version = '2';
mpc.baseMVA = 1;
% bus data
%bus_i type Pd	Qd Gs Bs area Vm Va baseKV zone	Vmax Vmin
mpc.bus = [
1	2	0   0	0	0	1	1	0	120	1	1.1	0.9
2	1	0   0	0	0	1	1	0	120	1	1.1	0.9
3	1	0   0	0	0	1	1	0	120	1	1.1	0.9
4	1	0   0	0	0	1	1	0	120	1	1.1	0.9
5	1	0   0	0	0	1	1	0	20	2	1.1	0.9
6	1	0   0	0	0	1	1	0	20	2	1.1	0.9
7	1	0   0	0	0	1	1	0	20	2	1.1	0.9
8	1	0   0	0	0	1	1	0	20	2	1.1	0.9
9	1	0   0	0	0	1	1	0	20	2	1.1	0.9
10	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
11	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
12	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
13	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
14	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
15	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
16	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
17	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
18	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
19	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
20	1	0   0	0	0	1	1	0	0.4	3	1.1	0.9
];
%% generator data
% bus Pg Qg Qmax Qmin Vg mBase status Pmax Pmin Pc1 Pc2 Qc1min Qc1max Qc2min Qc2max ramp_agc ramp_10 ramp_30 ramp_q apf
mpc.gen = [
1   50      0 1000 -1000 1.0 1 1 50    0 0 0 0 0 0 0 0 0 0 0 0
6   5       0 1000 -1000 1.0 1 1 5     0 0 0 0 0 0 0 0 0 0 0 0
11  0.00    0 1000 -1000 1.0 1 1 0.05  0 0 0 0 0 0 0 0 0 0 0 0
20  0.00    0 1000 -1000 1.0 1 1 0.01  0 0 0 0 0 0 0 0 0 0 0 0
];
%% branch data
%fbus tbus	r x b rA rB rC rat ang status angmin angmax
mpc.branch = [
1	2	7.93E-05	4.15E-05	0	50   50   50    0	0	1	-360	360
2	3	7.93E-05	4.15E-05	0	50   50   50	0	0	1	-360	360
3	4	7.93E-05	4.15E-05	0	50   50   50	0	0	1	-360	360
2	5	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
5	6	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
5	7	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
7	8	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
8	9	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
7	10	7.93E-05	4.15E-05	0	10   10   10	0	0	1	-360	360
10	11	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
10	12	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
12	13	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
13	14	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
14	19	7.93E-05	4.15E-05	0    1    1    1	0	0	1	-360	360
14	16	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
15	16	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
16	17	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
18	19	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
19	20	7.93E-05	4.15E-05	0	 1    1    1	0	0	1	-360	360
];
Costs=[
  %InvestLine   MaintLine   InvestSubEst     MaintSubEst  InvestTransf     MaintTransf 
    900            30         17500          5000          12000            500
    ];
   % SubEstación: extrapolada de SEI3, Centro de transformación CT_I_02, Línea BT_F_01 
   % todo esté en Valor Presente (incluso los costes de mantenimiento)
AmortizationYears=40;
PresentValue=12000;
RatePerPeriod=0.05;
Payment=RatePerPeriod*PresentValue/(1-(1+RatePerPeriod)^(-AmortizationYears));
% km of ech line: proportional to miles of km of each level voltage
% according to eurelectric
BranchData= [
 % nºbranch km  SEst Trafo MaxCapacity Zone
     1      2     0    0 20         1
     2      1     0    0 20         1
     3      1     0    0 10         1
     4      12    1    0 10         2
     5      6     0    0 10         2
     6      6     0    0 5          2
     7      6     0    0 5          2
     8      6     0    0 5          2
     9      7     0    1 0.04       3
     10     3     0    0 0.08       3
     11     10    0    0 0.08       3
     12     4     0    0 0.08       3
     13     4     0    0 0.08       3
     14     15    0    0 0.012      3
     15     1     0    0 0.022      3
     16     1     0    0 0.08       3
     17     1     0    0 0.08       3
     18     1     0    0 0.08       3
     19     1     0    0 0.08       3
];
BranchData(:,7)=BranchData(:,2).*Costs(2)+BranchData(:,3).*Costs(4)+BranchData(:,4).*Costs(6);%Maintenance Costs per branch
BranchData(:,8)=RatePerPeriod*(BranchData(:,2).*Costs(1)+BranchData(:,3).*Costs(3)+BranchData(:,4).*Costs(5))./(1-(1+RatePerPeriod)^(-AmortizationYears));%Investment costs per branch
