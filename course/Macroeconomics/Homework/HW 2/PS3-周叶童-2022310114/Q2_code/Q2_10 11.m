% Q2_10
clear
omega=[0.9641 -0.0246 0.0902;-0.2362 1.0645 0.2862;0 0 0.9]
[vv,lamb]=eig(omega) %find the eigenvalues of omega

% Q2_11
clear
%preparation for solution
n = 1; %number of jumper
m =2; %number of states
omega0=[1.0645 0.2862 -0.2362;0 0.9 0;-0.0246 0.0902 0.9641];  
[vv,lamb]=eig(omega0); %find the eigenvalues of omega
[lamb_sorted,index]=sort(abs(diag(lamb)));
%sort the eigenvector matrix
for ii = 1:m + n
 vv_sorted(:,ii) = vv(:,index(ii));
end
%find the index of the first eigenvalue whose value >=1
first_unstable_index = find(abs(lamb_sorted)>=1, 1 );
% num of stable eigenvalue
S = first_unstable_index - 1; 
% num of unstable eigenvalue
T = m+n - S; 
Gamma = inv(vv_sorted);
Gamma21 = Gamma(S+1:S+T,1:m); % low left, size = T*m;
Gamma22 = Gamma(S+1:S+T,m+1:n+m);% lower right, size = T*n;
%the policy function coefficients
pol= -inv(Gamma22)*Gamma21
