function CS = EA(k,best,mu,sigma,n0,T)
% Define sample means and variances.
smean = zeros(1,k);
svar = zeros(1,k);
n = n0 * k;
CS = zeros(1,k);
% Warm-up
N(1:k) = n0;
for i = 1:k
    temp_x = sigma(i) * randn(1,n0) + mu(i);
    smean(i) = mean(temp_x);
    svar(i) = var(temp_x);
end

% Check selection is correct or not
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
    z = sigma(a) * randn(1) + mu(a);    
% Update sample mean and sample variance    
    svar(a) = (N(a) - 1)/N(a) * svar(a) + (smean(a)-z)^2/(N(a)+1);
    smean(a) = (smean(a) * N(a) + z)/(N(a) + 1);
    N(a) = N(a) + 1 ;
    n = n + 1;
% Check selection is correct or not
    [~,b] = min(smean) ;
    if b == best
        CS(n) = 1;
    else
        CS(n) = 0;
    end
end

end
