clear all;
sigmas=linspace(0.5,2.5,100);
results=struct;
for i=1:length(sigmas)
    sigma=sigmas(i);
    save sigma;
    dynare rbc;
    results.(sprintf('sigma%d',i))=oo_;
end

k_1=[results.sigma1.dr.ghx(6,1)];
A_1=[results.sigma1.dr.ghx(6,2)];
c_1=[results.sigma1.dr.ghx(6,3)];
for i=2:length(sigmas)
    k_1=[k_1,results.(sprintf('sigma%d',i)).dr.ghx(6,1)];
    A_1=[A_1,results.(sprintf('sigma%d',i)).dr.ghx(6,2)];
    c_1=[c_1,results.(sprintf('sigma%d',i)).dr.ghx(6,3)];
end

figure
plot(sigmas,k_1,sigmas,A_1,sigmas,c_1);
legend('k(-1)','A(-1)','c(-1)')