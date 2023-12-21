%Q2_15

T = 25000;
e = 0.01*randn(1,T);
s = zeros(2,T); 
C = zeros(6,T); 
Tech=[0;1];
for j = 2:T
    s(:,j) = Ms*s(:,j-1) + Tech*e(1,j); 
end
for jj = 1:T
    C(1,jj)=pol*s(:,jj); 
    C(2,jj) = A*s(2,jj) + 0.4*A*s(1,jj) - A*C(1,jj);
    C(3,jj) = s(2,jj) + 0.4*s(1,jj) + 0.6*C(2,jj);
    C(4,jj) = C(3,jj)- C(2,jj); 
    C(5,jj) = C(3,jj)- s(1,jj); 
    C(6,jj) = 1.1412/0.3242*C(3,jj) - 0.8170/0.3242*C(1,jj);
end
subplot(4,2,1)
plot(C(1,5001:T),'-b','Linewidth',1)
title('C ')
subplot(4,2,2)
plot(C(3,5001:T),'-b','Linewidth',1)
title('Y ')
subplot(4,2,3)
plot(s(1,5001:T),'-b','Linewidth',1)
title('K')
subplot(4,2,4)
plot(C(6,5001:T),'-b','Linewidth',1)
title('I ')
subplot(4,2,5)
plot(s(2,5001:T),'-b','Linewidth',1)
title('A ')
subplot(4,2,6)
plot(C(5,5001:T),'-b','Linewidth',1)
title('R')
subplot(4,2,7)
plot(C(4,5001:T),'-b','Linewidth',1)
title('W')
subplot(4,2,8)
plot(C(2,5001:T),'-b','Linewidth',1)
title('L')
X = C(:,5001:T)';
X = [X,s(1,5001:T)',s(2,5001:T)']; 
Varcov = cov(X)
Autocorrelation = corr(X)