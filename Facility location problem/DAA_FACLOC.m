function CS = DAA_FACLOC(x,nDays,k,best,n0,T)
% Define sample means and variances.
smean = zeros(1,k);
svar = zeros(1,k);
n = n0 * k;
CS = zeros(1,k);
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
    I = svar ./ (smean - smean(b)).^2;
    I1 = I; svar1 = svar;
    I1(b) = []; svar1(b) = [];
    I(b) = sqrt(svar(b)*sum(I1.^2./svar1));
    S = sum(I);
    w_OCBA = I/S; 

    T1 = 2*svar(b)*sum( (I1.^2./svar1/(S - I(b)) - I1 ).*log(max(I1)./I1)  ) - S;
    T2 = 2*( sum(I1.*log(max(I1)./I1)) + sqrt( svar(b)*sum( (I1.^2./svar1).* (log(max(I1)./I1)).^2 ) ) ) - S;
    T0 = ceil( max(T1,T2) );
    if (n+1) < T0
        T3 = T0;
    else
        T3 = n+1;
    end
    
    p = S*(2*I(b) - S);
    q = -4*svar(b)*sum( I1.^2.*log(I1)./svar1 ) + 2*(S - I(b))*( 2*sum(I1.*log(I1)) + T3 + S );
    r = 4*svar(b)*sum( I1.^2.*(log(I1)).^2./svar1 ) - ( 2*sum(I1.*log(I1)) + T3 + S )^2;
    lambda = (-q + sqrt(q^2-4*p*r))/(2*p);
    alpha = (lambda - 2*log(I))/(1+T3/S);
    
    w_OCBA_fb = w_OCBA.*alpha;
    z = w_OCBA_fb.^2./svar;
    z(b) = [];
    w_OCBA_fb(b) = sqrt(svar(b))*sqrt(sum(z));

% Generate a sample value of a random variable with probability w_OCBA
    N1 = (n + 1) * w_OCBA_fb;
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