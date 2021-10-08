%% Start of Program
clc
clear
close all

%% Data Loading
% Data = xlsread('data.xlsx');
% % load trabzon_data.mat
% % Data=trabzon_data;
% % load gumushane.mat
% % Data=gumushane;
% % X = Data(:,1:end-1);
% % Y = Data(:,end);
load bilinenData.mat
Data=[bilinenX; bilinenY]
X = Data(:,1:end-1);
Y = Data(:,end);


DataNum = size(X,1);
InputNum = size(X,2);
OutputNum = size(Y,2);
nP=20;
MaxIt=250;
HiddenNeuronSize=50;
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
TrNum = 240
for it=1:5
trIndex = 1 : TrNum;
tsIndex = (1+TrNum) : DataNum;

Xtr = XN(trIndex,:);
Ytr = YN(trIndex,:);

Xts = XN(tsIndex,:);
Yts = YN(tsIndex,:);

%% Network Structure
pr = [-1 1];
% pr = [1 1];
PR = repmat(pr,InputNum,1);

Network = newff(PR,[HiddenNeuronSize HiddenNeuronSize HiddenNeuronSize OutputNum],{'tansig' 'tansig' 'tansig' 'tansig'});
% view(Network)

%% Training

Network = Train_GBO(nP,MaxIt,Network,Xtr,Ytr);

%% Assesment
YtrM = sim(Network,Xtr')';
YtsM = sim(Network,Xts')';
YtsM2=YtsM; Yts2=Yts; YtrM2=YtrM; Ytr2=Ytr; Xtr2=Xtr; Xts2=Xts;
YtsM=Denormalize_Fcn(YtsM2,MinY, MaxY);
Yts=Denormalize_Fcn(Yts2,MinY, MaxY);
YtrM=Denormalize_Fcn(YtrM2,MinY, MaxY);
Ytr=Denormalize_Fcn(Ytr2,MinY, MaxY);
Xtr=Denormalize_Fcn(Xtr2,MinX, MaxX);
Xts=Denormalize_Fcn(Xts2,MinX, MaxX);
data_info{it,1}=Xtr; data_info{it,2}=Ytr; data_info{it,3}=YtrM;  data_info{it,4}=trIndex; 
data_info{it,5}=Xts; data_info{it,6}=Yts; data_info{it,7}=YtsM;  data_info{it,8}=tsIndex; 
RMSE_tr(it) = sqrt(mse(YtrM - Ytr))*100;
RMSE_ts(it) = sqrt(mse(YtsM - Yts))*100
% RMSE_ts2(it) = sqrt(mse(YtsM2 - Yts2))*100
[r2_tr(it)]=rsquare(Ytr,YtrM);
[r2_ts(it)]=rsquare(Yts,YtsM);
[MAE_tr(it)]=100*MAE(Ytr,YtrM);
[MAE_ts(it)]=100*MAE(Yts,YtsM);
RE_tr(it) = calcRE(Ytr,YtrM)*100;
RE_ts(it) = calcRE(YtsM,Yts)*100;
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



clearvars -except RMSE_tr RMSE_ts r2_tr r2_ts MAE_tr MAE_ts RE_tr RE_ts data_info 
save gumushane_bilinendagilim_ANN_GBO_results_N50_np20
% save data_info_gumushane_2
load gong
sound(y,Fs)
