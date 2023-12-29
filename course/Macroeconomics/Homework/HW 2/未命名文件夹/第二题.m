%% A Standard RBC Model:
% Manual solution and simulation.
% Wu, Huabin. Apr. 12, 2022.

%% 参数设定
alf = 0.4;  bta = 0.98;  dlt = 0.05; tht = 1; gam=0.4;
gz  = 1;    rhoa = 0.9;    siga = 0.01;   
periods = 40 ;  

%% 求解模型变量稳态值
rs  = gz/bta-1;
ky  = alf/(rs+dlt);
cy  = 1-(gz-1+dlt)*ky;
ny  = ky^(-alf/(1-alf));
ws  = (1-alf)/ny;
ns  = 1/(1+cy*(1-gam)/gam/(1-alf));
ys  = ns/ny;
ks  = ky*ys;
is  = dlt*ks;
cs  = cy*ys;

%% 均衡系统
% 变量顺序：c k a
phi = (dlt+rs)/(1+rs);
xi  = 1/(alf+ns/(1-ns));
zta = 1+(1-alf)*xi;

B  = [1        0                      0;
      0        gz*ky                  0      ;
     -phi*zta  phi*(1-alf)*(1-alf*xi) tht*(1+phi*(1-alf)*xi)];
A  = [rhoa 0                   0      ;
      zta  alf*zta+(1-dlt)*ky -(1-alf)*tht*xi-cy;
      0    0                   tht     ];
I1   = [1; 0; 0];
% 均衡系统可表示为：X_{t+1} = Omg*X_t + R*epsi_{t+1}, X_t = [c_t, k_t, a_t]'.
Omg = B\A;
R = B\I1;
%% 最优路径求解过程
% 特征分解：Omg = V*D/V
% 均衡系统两边同时左乘 inv(Vs)得到:
% z_{t+1} = Ds*z_t + U*epsi_{t+1}, z_t=Vs\X_t, U=Vs\R.
[V,  D] = eig(Omg);
[d,idx] = sort(diag(D));
Ds      = D(idx,idx);
Vs      = V(:,idx);
Vs_1    = Vs\eye(3);

idB = 1:2; idF = 3  ; % x_t 中的前两个变量向后迭代，后一个变量需向前迭代。
idc = 3  ; ids = 1:2; % 控制变量c和状态变量a,k的位置。
Rs  = R(ids,:);

% 求出控制变量的最优路径(Policy Functions)
coefc = -Vs_1(idF,idc)\Vs_1(idF,ids);

% 代回均衡系统可得状态变量的最优路径(Transition Functions)
coefS = Omg(ids,idc)*coefc+Omg(ids,ids);

% 其他变量(Static Variables)的最优路径
coefn = xi*[1 alf]- tht*xi*coefc;
coefy = (1-alf)*coefn + [1 alf];
coefw = coefy - coefn;
coefr = (rs+dlt)/rs*(coefy - [0 1]);
coefi = (coefy - coefc*cy)/(dlt*ky);
coefC = [coefy;coefc;coefi;coefn;coefr;coefw];

%% 脉冲反应函数(Impulse Response Functions)
% S_t = coefS*S_{t-1} + R_s*epsi_{t}, R_s=[1;0], S_t=[a_t;k_t];
T       = 40; 
periods = 1:T;
epsi    = [1; zeros(T-1,1)] * siga;
S       = zeros(2,T); % initialize
S(:,1)  = Rs*epsi(1);
for ii = 2:T
    S(:,ii) = coefS*S(:,ii-1) + Rs*epsi(ii);
end
C       = coefC*S; 
IRFs    = [C; S]; % order: ycinrwak
IRFs    = IRFs([1 2 3 8 4 7 5 6],:);% reorder IRFs: yciknarw

% Plot the IRFs.
varNames = {'y','c','i','k','N','A','r','w'};
figure;
for ii=1:8
    subplot(3,3,ii);
    plot(periods,IRFs(ii,:),'-b','LineWidth', 1.5);hold on;
    plot(periods,zeros(1,T),'--r','LineWidth', 1);
    title(varNames{ii});
end

%% 随机模拟
T       = 25000; 
periods = 1:T;
rng(20220115,'simdTwister');
epsi    = randn(T,1)*siga;
S       = zeros(2,T); % initialize
S(:,1)  = Rs*epsi(1);
for ii = 2:T
    S(:,ii) = coefS*S(:,ii-1) + Rs*epsi(ii);
end
S(:,1:5000) = []; % 去掉前5000个值，减小初始值导致的模拟误差。
C       = coefC*S; 
Y=[C;S]'; 

% 画出模拟时间序列
PlotRange = 1:200;
TSs = Y(PlotRange,1:3);
figure;
plot(PlotRange,TSs,'linewidth',2);legend(varNames{1:3});

%% 各阶矩函数
Ss     = [ys;cs;is;ks;ns;1;rs;ws];
Mu     = log(Ss);               % 均值（稳态值的对数）
Phi    = [zeros(8,6) [coefC*coefS;coefS]];
Psi    = [coefC*Rs;Rs];
Gam0   = zeros(8,8); 
PSI    = Psi*Psi';

% 理论矩
Gam0(:)  = (eye(64)-kron(Phi,Phi))\PSI(:)*siga^2;  %协方差矩阵
Sigma2   = diag(Gam0);          % 方差 
Sigma    = sqrt(Sigma2);        % 标准差
invD     = diag(Sigma)\eye(8); 
CorrMat  = invD*Gam0*invD;      % 相关矩阵
CorrCoef = zeros(8,5);          % 自相关系数
for ii=1:5
  Gam{ii}= Phi^ii*Gam0;
  P{ii}  = invD*Gam{ii}*invD;
  CorrCoef(:,ii) = diag(P{ii});
end

% 模拟矩
sigma2   = var(Y);              % 模拟方差
sigma    = std(Y);              % 模拟标准差
gam0     = cov(Y);              % 模拟协方差矩阵
corrmat  = corr(Y);             % 模拟相关矩阵
corrcoef = zeros(8,5);          % 模拟自相关系数
for ii=1:5
  p{ii}  = corr(Y((ii+1):end,:),Y(1:(end-ii),:));
  corrcoef(:,ii)=diag(p{ii});
end
