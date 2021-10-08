clear all; clc; 
X=[]; Y=[]; Z=[];
% load ANN_GBO_results_nP5_200.mat
load V2_ANN_LM_results_N5.mat
X=[X; mean(RMSE_tr) std(RMSE_tr) mean(RMSE_ts) std(RMSE_ts)]
Y=[Y; mean(r2_tr) std(r2_tr) mean(r2_ts) std(r2_tr)]
Z=[Z; mean(MAE_tr) std(MAE_tr) mean(MAE_ts) std(MAE_ts)]
% load ANN_LM_results_N10.mat
% X=[X; mean(RMSE_tr) std(RMSE_tr) mean(RMSE_ts) std(RMSE_ts)]
% Y=[Y; mean(r2_tr) std(r2_tr) mean(r2_ts) std(r2_tr)]
% Z=[Z; mean(MAE_tr) std(MAE_tr) mean(MAE_ts) std(MAE_ts)]
xyz=[X;Y;Z]
mmin=10000;
for i=1:30
    if(RMSE_ts(1,i)<mmin)
        mmin=RMSE_ts(1,i)
        mmin_ind=i;
    end      
end

mmax=-1;
for i=1:30
    if(RMSE_ts(1,i)>=mmax)
        mmax=RMSE_ts(1,i)
        mmax_ind=i;
    end      
end

d1=[RMSE_tr(1,mmin_ind) RMSE_ts(1,mmin_ind) MAE_tr(1,mmin_ind) MAE_ts(1,mmin_ind) r2_tr(1,mmin_ind) r2_ts(1,mmin_ind)]
d2=[RMSE_tr(1,mmax_ind) RMSE_ts(1,mmax_ind) MAE_tr(1,mmax_ind) MAE_ts(1,mmax_ind) r2_tr(1,mmax_ind) r2_ts(1,mmax_ind)]
dd=[d1;d2]
train_input=data_info{mm_ind,1}
train_output=data_info{mm_ind,2}
test_input=data_info{mm_ind,5}
test_output=data_info{mm_ind,6}
scatter(train_input(:,1),train_input(:,2))
hold on
scatter(test_input(:,1),test_input(:,2))