% This file provides the codes as well as settings for the facility location
% problem. The facility location problem is a practical test problem 
% provided by the Simulation Optimization Library at 
% https://github.com/simopt-admin/simopt/tree/matlab/Problems/FACLOC
% where can download the 'FACLOC.m' file
%
% notations:
% k: the number of designs
% n0: initial sample size for each design
% T: simulation budget (total number of simulation replications)
% T0: macro-replications for estimating the empirical PCS
% best: index of the best design. it is set to be 1 
% ndays: it is set to be 30
% x: locations (designs)

% Initialization 
n0 = 3;
T = 800;
T0 = 10;
k = 10;
nDays = 30;
x = zeros(k,4);
for i = 1:k
    x(i,:) = [0.49+0.01*i,0.59+0.01*i,0.59+0.01*i,0.79+0.01*i];
end
best = 1;

% for all procedures, can use 'parfor' instead of 'for' to speed up experiments.

CS_EA = zeros(T0,T);
for i = 1:T0
    CS_EA(i,:) = EA_FACLOC(x,nDays,k,best,n0,T);
end
PCS_EA = mean(CS_EA);

CS_OCBA = zeros(T0,T);
for i = 1:T0
    CS_OCBA(i,:) = OCBA_FACLOC(x,nDays,k,best,n0,T);
end
PCS_OCBA = mean(CS_OCBA);

CS_AOAP = zeros(T0,T);
for i = 1:T0
    CS_AOAP(i,:) = AOAP_FACLOC(x,nDays,k,best,n0,T);
end
PCS_AOAP = mean(CS_AOAP);

% FAA is different from all other procedures. The PCSs change if the simulation budget changes.
% For example, if we want to plot the empirical PCS by the simulation budget from
% 1 to 1000, we need to run FAA 1000 times by changing the simulation
% budget from 1 to 1000.
PCS_FAA = zeros(1,T);
for t = [30,40:20:800]
    CS_FAA = zeros(T0,1);
    for i = 1:T0
        CS_FAA(i) = FAA_FACLOC(x,nDays,k,best,n0,t);
    end
    PCS_FAA(t) = mean(CS_FAA);
end

CS_DAA = zeros(T0,T);
for i = 1:T0
    CS_DAA(i,:) = DAA_FACLOC(x,nDays,k,best,n0,T);
end
PCS_DAA = mean(CS_DAA);

% plot
z = [30,40:20:800];
index = [1,2,4:4:40];
p1 = plot(z,PCS_OCBA(z));
hold on
p2 = plot(z,PCS_EA(z));
p3 = plot(z,PCS_AOAP(z));
p4 = plot(z,PCS_DAA(z));
p5 = plot(z,PCS_FAA(z));

% Line width
p1.LineWidth = 1.2;
p2.LineWidth = 1.2;
p3.LineWidth = 1.2;
p4.LineWidth = 1.2;
p5.LineWidth = 1.2;

% Color
p1.Color = "m";
p2.Color = "#EDB120";
p3.Color = "b";
p4.Color = "k";
p5.Color = "r";

% Marker
p1.Marker = "s";p1.MarkerSize = 10;p1.MarkerIndices = index;
p2.Marker = "+";p2.MarkerSize = 10;p2.MarkerIndices = index;
p3.Marker = "^";p3.MarkerSize = 10;p3.MarkerIndices = index;
p4.Marker = "o";p4.MarkerSize = 10;p4.MarkerIndices = index;
p5.Marker = "*";p5.MarkerSize = 10;p5.MarkerIndices = index;

xlabel('Simulation budget');
ylabel('PCS');
legend('OCBA','EA','AOAP','DAA','FAA');
set(gca,'FontSize',14);

