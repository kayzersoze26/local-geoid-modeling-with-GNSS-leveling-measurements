clear all; clc;
% load trabzon_data.mat
% Data=trabzon_data;
load gumushane.mat
Data=gumushane;
% % load trab.mat
% % Data=trab;
X = Data(:,1:end-1);
Y = Data(:,end);

DataNum = size(X,1);
InputNum = size(X,2);
OutputNum = size(Y,2);
HiddenNeuronSize=30;
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

% trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.
% % Create a Fitting Network <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% hiddenLayerSize = 10;
% net = fitnet(hiddenLayerSize,trainFcn);
% 
% net.performFcn = 'mse';  % Mean Squared Error
% net.trainParam.lr=0.05;
% net.trainParam.epochs=5000;
% net.trainParam.showWindow=true;
% net.trainParam.goal=0.00001;
% net.trainParam.mu=0.00005;
% % net.trainParam.max_fail=1000000;

pr = [-1 1];
PR = repmat(pr,InputNum,1);

net = newff(PR,[HiddenNeuronSize HiddenNeuronSize OutputNum],{'tansig' 'tansig' 'tansig'});


net.trainFcn = 'trainlm'; 
net.trainParam.epochs=200;
net.trainParam.lr=0.01;
net.trainParam.goal=0.00001;
net.trainParam.mu=0.00005;
% Train the Network
[net,tr] = train(net,Xtr',Ytr');
% % view(net)
warning off;
% Test the Network

train_output = net(Xtr');
test_output = net(Xts');
Xtr2=Xtr; Xts2=Xts;

dnYts=Denormalize_Fcn(Yts,MinY, MaxY);
dntest_output=Denormalize_Fcn(test_output,MinY, MaxY);
dnYtr=Denormalize_Fcn(Ytr,MinY, MaxY);
dntrain_output=Denormalize_Fcn(train_output,MinY, MaxY);
Xtr=Denormalize_Fcn(Xtr2,MinX, MaxX);
Xts=Denormalize_Fcn(Xts2,MinX, MaxX);
trainPerf = perform(net,dnYtr,dntrain_output);
testPerf = perform(net,dnYts,dntest_output);

% MinX = min(X);
% MaxX = max(X);
% 
% MinY = min(Y);
% MaxY = max(Y);

data_info{it,1}=Xtr; data_info{it,2}=dnYtr; data_info{it,3}=dntrain_output;  data_info{it,4}=trIndex; 
data_info{it,5}=Xts; data_info{it,6}=dnYts; data_info{it,7}=dntest_output; data_info{it,8}=tsIndex; 

RMSE_tr(it) = sqrt(mse(dntrain_output - dnYtr))*100;
RMSE_ts(it) = sqrt(mse(dntest_output - dnYts))*100
r2_tr(it)=rsquare(Ytr,train_output');
r2_ts(it)=rsquare(Yts,test_output');
MAE_tr(it)=100*MAE(Ytr,train_output');
MAE_ts(it)=100*MAE(Yts,test_output');
RE_tr(it) = calcRE(Ytr,train_output')*100;
RE_ts(it) = calcRE(Yts,test_output')*100;
it

end
% 
clearvars -except RMSE_tr RMSE_ts r2_tr r2_ts MAE_tr MAE_ts RE_tr RE_ts data_info
% save NEW_V2_ANN_BR_results_N20