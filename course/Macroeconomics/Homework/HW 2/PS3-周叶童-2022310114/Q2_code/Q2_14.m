% Q2_14

Ms=[0.9230 0.1929;0 0.9];
H = 60; 
IRF = zeros(3,H); 
IRF(2,1) = 0.01; 
IRF(3,1) = pol*IRF(1:2,1);
for ii=2:H
    IRF(1:2,ii)=Ms*IRF(1:2,ii-1);
    IRF(3,ii)=pol*Ms*IRF(1:2,ii-1); 
end 
IRF2 = zeros(5,H);
A=(0.4 - 1 + 1/(1 - 0.3584))^(-1);
for jj=1:H
    IRF2(1,jj) = A*IRF(2,jj) +0.4*IRF(1,jj) - A*IRF(3,jj);
    IRF2(2,jj) = IRF(2,jj) + 0.4*IRF(1,jj) + 0.6*IRF2(1,jj);
    IRF2(3,jj) = IRF2(2,jj)- IRF2(1,jj); 
    IRF2(4,jj) = IRF2(2,jj)- IRF(1,jj); 
    IRF2(5,jj) = 1.1412/0.3242*IRF2(2,jj) - 0.8170/0.3242*IRF(3,jj); 
end
subplot(3,3,1)
plot(IRF(3,:),'-k','Linewidth',2)
title('C')
subplot(3,3,2)
plot(IRF2(1,:),'-k','Linewidth',2)
title('L')
subplot(3,3,3)
plot(IRF2(3,:),'-k','Linewidth',2)
title('W')
subplot(3,3,4)
plot(IRF2(4,:),'-k','Linewidth',2)
title('R')
subplot(3,3,5)
plot(IRF2(5,:),'-k','Linewidth',2)
title('I')
subplot(3,3,6)
plot(IRF(1,:),'-k','Linewidth',2)
title('K')
subplot(3,3,7)
plot(IRF(2,:),'-k','Linewidth',2)
title('A')
subplot(3,3,8)
plot(IRF2(2,:),'-k','Linewidth',2)
title('Y')