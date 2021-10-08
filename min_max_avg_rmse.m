
clear all;clc;
Y=[];

load gumushane_bilinendagilim_ANN_GBO_results_N20_np20.mat
X=data_info{4,7}-data_info{4,6}
Y=[Y; max(X) min(X) mean(abs(X))]

load gumushane_bilinendagilim_ANN_GBO_results_N30_np20.mat
X=data_info{12,7}-data_info{12,6}
Y=[Y; max(X) min(X) mean(abs(X))]

load gumushane_bilinendagilim_ANN_GBO_results_N50_np20.mat
X=data_info{3,7}-data_info{3,6}
Y=[Y; max(X) min(X) mean(abs(X))]