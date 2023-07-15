function CS = OCBA_FACLOC(x,nDays,k,best,n0,T)
% Define sample means and variances.
smean = zeros(1,k);
svar = zeros(1,k);
n = n0 * k;
CS = zeros(1,T);
% Warm-up
N(1:k) = n0;
temp_x = zeros(n0,1);
for i = 1:k
    for j = 1:n0
        temp_x(j) = - FACLOC( x(i,:), nDays);
    end
    smean(i) = mean(temp_x);
    svar(i) = var(temp_x);
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
    [~,b] = min(smean);
% Obtain the OCBA ratio
    I = (smean - smean(b)).^2 ./ svar;
    I1 = I; svar1 = svar;
    I1(b) = []; svar1(b) = [];
    I(b) = 1/(sqrt(svar(b)*sum(I1.^(-2)./svar1)));
    S = sum(I.^(-1));
    w_OCBA = I.^(-1)/S; 
% Generate a sample value of a random variable with probability w_OCBA
    N1 = (n + 1) * w_OCBA;
    [~,a] = max(N1-N);
    z = - FACLOC( x(a,:), nDays);    
% Update sample mean and sample variance
    svar(a) = (N(a) - 1)/N(a) * svar(a) + (smean(a)-z)^2/(N(a)+1);
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