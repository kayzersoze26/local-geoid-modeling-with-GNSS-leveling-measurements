X=[];
load gumushane_bilinendagilim_ANN_GBO_results_N20_np20.mat
X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) min(MRE_tr) min(MAE_ts)]
load gumushane_bilinendagilim_ANN_GBO_results_N30_np20.mat
X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) min(MRE_tr) min(MAE_ts)]
load gumushane_bilinendagilim_ANN_GBO_results_N50_np20.mat
X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) min(MRE_tr) min(MAE_ts)]

% X=[];
% load gumushane_ANN_GBO_results_N20_np20;
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]
% load gumushane_ANN_GBO_results_N20_np30_it100.mat
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]
% load gumushane_ANN_GBO_results_N20_np50_it100.mat
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]
% 
% 
% % X=[];
% load gumushane_ANN_GBO_results_N20_np20;
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]
% load gumushane_ANN_GBO_results_N20_np30_it100.mat
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]
% load gumushane_ANN_GBO_results_N20_np50_it100.mat
% X=[X;mean(MRE_tr) std(MRE_tr) mean(MRE_ts) std(MRE_ts) max(MRE_tr) max(MRE_ts)]