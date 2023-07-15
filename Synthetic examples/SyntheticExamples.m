% This file provides the codes as well as settings for synthetic examples
%
% notations:
% k: the number of designs
% n0: initial sample size for each design
% T: simulation budget (total number of simulation replications)
% T0: macro-replications for estimating the empirical PCS
% mu: the vector of mean performance of designs
% sigma: vector of standard deviation of designs
% best: index of the best design. it is set to be 1 across all tested synthetic examples

% Initialization-Example 1
k = 10;                                                                                                                       
n0 = 3;                                                                 
T = 1000;
T0 = 100000;
mu = 1:k;
sigma = 6*ones(k,1);                                                      
best = 1;

% Initialization-Example 2
%k = 10;                                                                                                                       
%n0 = 3;                                                                 
%T = 3000;
%T0 = 100000;
%mu = 1:k;
%mu = mu';
%sigma = 11-mu;                                                      
%best = 1;

% Initialization-Example 3
%k = 50; 
%n0 = 3; 
%T = 5000;
%T0 = 100000;
%mu = 1:k;
%mu = mu';
%sigma = 10*ones(k,1);                                                      
%best = 1;

% Initialization-Example 4
%k = 500;                                                                                                                       
%n0 = 3;                                                                 
%T = 80000;
%T0 = 10000;
%mu = [0,1+15*rand(1,k-1)];
%sigma = [6;3+6*rand(k-1,1)];                                                      
%best = 1;


% for all procedures, can use 'parfor' instead of 'for' to speed up experiments.
CS_OCBA = zeros(T0,T);
for i = 1:T0
    CS_OCBA(i,:) = OCBA(k,best,mu,sigma,n0,T);
end
PCS_OCBA = mean(CS_OCBA);

% FAA is different from all other procedures. The PCSs change if the simulation budget changes.
% For example, if we want to plot the empirical PCS by the simulation budget from
% 1 to 1000, we need to run FAA 1000 times by changing the simulation
% budget from 1 to 1000.
PCS_FAA = zeros(1,T);
for t = n0*k :10:  T
    CS_FAA = zeros(T0,1);
    for i = 1:T0
        CS_FAA(i) = FAA(k,best,mu,sigma,n0,t);
    end
    PCS_FAA(t) = mean(CS_FAA);
end

CS_DAA = zeros(T0,T);
for i = 1:T0
    CS_DAA(i,:) = DAA(k,best,mu,sigma,n0,T);
end
PCS_DAA = mean(CS_DAA);

% AOAP is designed to select the design with the largest mean. So we
% pass -mu to AOAP for consistency
CS_AOAP = zeros(T0,T);
for i = 1:T0
    CS_AOAP(i,:) = AOAP(k,best,-mu,sigma,n0,T);
end
PCS_AOAP = mean(CS_AOAP);

CS_EA = zeros(T0,T);
for i = 1:T0
    CS_EA(i,:) = EA(k,best,mu,sigma,n0,T);
end
PCS_EA = mean(CS_EA);


% plot
% need to change 'z' and 'index' for different tested examples
z = 30:10:1000;
index = [1,8:10:98];
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










