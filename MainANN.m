%% Start of Program
clc
clear
close all

%% Data Loading
% Data = xlsread('data.xlsx');
% load trab
% Data=trab;
load Data
X = Data(:,1:end-1);
Y = Data(:,end);


DataNum = size(X,1);
InputNum = size(X,2);
OutputNum = size(Y,2);
nP=200;
MaxIt=100;
%% Normalization
MinX = min(X);
MaxX = max(X);

MinY = min(Y);
MaxY = max(Y);

XN = X;
YN = Y;
% 
for i = 1:InputNum
    XN(:,i) = Normalize_Fcn(X(:,i),MinX(i),MaxX(i));
end

for i = 1:OutputNum
    YN(:,i) = Normalize_Fcn(Y(:,i),MinY(i),MaxY(i));
end

%% Test and Train Data
TrPercent = 70;
TrNum = round(DataNum * TrPercent / 100);
TsNum = DataNum - TrNum;

for it=1:30
R = randperm(DataNum);
% R=[1:607];
trIndex = R(1 : TrNum);
tsIndex = R(1+TrNum : end);

Xtr = XN(trIndex,:);
Ytr = YN(trIndex,:);

Xts = XN(tsIndex,:);
Yts = YN(tsIndex,:);

%% Network Structure
pr = [-1 1];
PR = repmat(pr,InputNum,1);

Network = newff(PR,[5 5 OutputNum],{'tansig' 'tansig' 'tansig'});
% view(Network)

%% Training

Network = Train_GBO(nP,MaxIt,Network,Xtr,Ytr);

%% Assesment
YtrM = sim(Network,Xtr')';
YtsM = sim(Network,Xts')';
data_info{it,1}=Xtr; data_info{it,2}=Ytr; data_info{it,3}=trIndex; 
data_info{it,4}=Xts; data_info{it,5}=Yts; data_info{it,6}=tsIndex; 
RMSE_tr(it) = sqrt(mse(YtrM - Ytr))*100
RMSE_ts(it) = sqrt(mse(YtsM - Yts))*100
[r2_tr(it)]=rsquare(Ytr,YtrM)
[r2_ts(it)]=rsquare(Yts,YtsM)
[MAE_tr(it)]=MAE(Ytr,YtrM)
[MAE_ts(it)]=MAE(Yts,YtsM)
it

end

% % Display
% figure(1)
% plot(Ytr,'-or');
% hold on
% plot(YtrM,'-sb');
% hold off
% 
% figure(2)
% plot(Yts,'-or');
% hold on
% plot(YtsM,'-sb');
% hold off
% 
% figure(3)
% t = -1:.1:1;
% plot(t,t,'b','linewidth',2)
% hold on
% plot(Ytr,YtrM,'ok')
% hold off
% 
% figure(4)
% t = -1:.1:1;
% plot(t,t,'b','linewidth',2)
% hold on
% plot(Yts,YtsM,'ok')
% hold off



clearvars -except RMSE_tr RMSE_ts r2_tr r2_ts MAE_tr MAE_ts data_info 
save ANN_GBO_results_N5_np100

load gong
sound(y,Fs)
