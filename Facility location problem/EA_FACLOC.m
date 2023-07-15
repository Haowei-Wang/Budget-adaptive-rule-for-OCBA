function [CS] = EA_FAC(x,nDays,k,best,n0,T)
% Define sample means and variances.
smean = zeros(1,k);
%svar = zeros(1,k);
n = n0 * k;
CS = zeros(1,k);
% Warm-up
N(1:k) = n0;
for i = 1:k
    temp_x = - FACLOC( x(i,:), nDays);
    smean(i) = mean(temp_x);
    %svar(i) = var(temp_x);
end
%check best
[~,b] = min(smean) ;
if b == best
    CS(n) = 1;
else
    CS(n) = 0;
end

% Begin Loop
while n < T
% Generate a sample value of a random variable with probability w_OCBA
    a = mod(n,k) + 1;
    z = - FACLOC( x(a,:), nDays);    
% Update sample mean and sample variance    
    %svar(a) = (N(a) - 1)/N(a) * svar(a) + (smean(a)-z)^2/(N(a)+1);
    smean(a) = (smean(a) * N(a) + z)/(N(a) + 1);
    N(a) = N(a) + 1 ;
    n = n + 1;
    %Check selection is correct or not
    [~,b] = min(smean) ;
    if b == best
        CS(n) = 1;
    else
        CS(n) = 0;
    end
end

end
