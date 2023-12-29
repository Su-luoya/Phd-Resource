clear all;
sigmas=[0,0.5,0.8,0.9,0.99];
results=struct;
for i=1:length(sigmas)
    sigma=sigmas(i);
    save sigma;
    dynare rbc;
    results.(sprintf('sigma%d',i))=oo_;
end

ss = ['eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99']; %% 图例
y_ea = [results.sigma1.irfs.y_ea; results.sigma2.irfs.y_ea; results.sigma3.irfs.y_ea;...
    results.sigma4.irfs.y_ea; results.sigma5.irfs.y_ea];
c_ea = [results.sigma1.irfs.c_ea; results.sigma2.irfs.c_ea; results.sigma3.irfs.c_ea;...
    results.sigma4.irfs.c_ea; results.sigma5.irfs.c_ea];
k_ea = [results.sigma1.irfs.k_ea; results.sigma2.irfs.k_ea; results.sigma3.irfs.k_ea;...
    results.sigma4.irfs.k_ea; results.sigma5.irfs.k_ea];
N_ea = [results.sigma1.irfs.N_ea; results.sigma2.irfs.N_ea; results.sigma3.irfs.N_ea;...
    results.sigma4.irfs.N_ea; results.sigma5.irfs.N_ea];
i_ea = [results.sigma1.irfs.i_ea; results.sigma2.irfs.i_ea; results.sigma3.irfs.i_ea;...
    results.sigma4.irfs.i_ea; results.sigma5.irfs.i_ea];
w_ea = [results.sigma1.irfs.w_ea; results.sigma2.irfs.w_ea; results.sigma3.irfs.w_ea;...
    results.sigma4.irfs.w_ea; results.sigma5.irfs.w_ea];
r_ea = [results.sigma1.irfs.r_ea; results.sigma2.irfs.r_ea; results.sigma3.irfs.r_ea;...
    results.sigma4.irfs.r_ea; results.sigma5.irfs.r_ea];
A_ea = [results.sigma1.irfs.A_ea; results.sigma2.irfs.A_ea; results.sigma3.irfs.A_ea;...
    results.sigma4.irfs.A_ea; results.sigma5.irfs.A_ea];

periods = 1:1:50;
periods = periods';
 
figure;
nexttile
plot(periods,y_ea,'Linewidth',1.5);xlabel('y_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,c_ea,'Linewidth',1.5);xlabel('c_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,k_ea,'Linewidth',1.5);xlabel('k_{t+1}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,N_ea,'Linewidth',1.5);xlabel('N_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,i_ea,'Linewidth',1.5);xlabel('i_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,w_ea,'Linewidth',1.5);xlabel('w_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,r_ea,'Linewidth',1.5);xlabel('r_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');
nexttile
plot(periods,A_ea,'Linewidth',1.5);xlabel('A_{t}');
legend('eta = 0','eta = 0.5','eta = 0.8','eta = 0.9','eta = 0.99');