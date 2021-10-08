%%
clc
clear
close all

%IMPORT eğitim değişkenleri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opts = delimitedTextImportOptions("NumVariables", 7);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["m", "db", "dg", "v", "f", "F", "Ra"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
tb1 = readtable("C:\Users\kutay\Desktop\ysa_5x2.txt", opts);
% Convert to output type
m = tb1.m.';
db = tb1.db.';
dg = tb1.dg.';
v = tb1.v.';
f = tb1.f.';
F = tb1.F.';
Ra = tb1.Ra.';
% Clear temporary variables
clear opts tb1

train_input= [m;db;dg;v;f];
% train_target= [F;Ra];
train_target= [F];
clear m db dg v f F Ra

%IMPORT simülasyon değişkenleri
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["m", "db", "dg", "v", "f"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Import the data
tb2 = readtable("C:\Users\kutay\Desktop\ysa_5x2_sim.txt", opts);
% Convert to output type
m = tb2.m.';
db = tb2.db.';
dg = tb2.dg.';
v = tb2.v.';
f = tb2.f.';
% Clear temporary variables
clear opts tb2

sim_input= [m;db;dg;v;f];
clear m db dg v f

%YSA kodlaması
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Bayesian Regularization backpropagation.
% Create a Fitting Network <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
hiddenLayerSize = 50;
net = fitnet(hiddenLayerSize,trainFcn);
% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};
% transfer fonksiyonu 'logsig' 'purelin' 'tansig'
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 5/100;
% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error
% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotregression','plotfit'};

%tarama aralığı
% net.trainParam.lr=0.05;
% döngü(iterasyon) sayısı <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
net.trainParam.epochs=5000;
net.trainParam.showWindow=true;
net.trainParam.goal=0;
net.trainParam.mu=0.00005;
net.trainParam.max_fail=1000000;


% Train the Network
[net,tr] = train(net,train_input,train_target);
% Test the Network
train_output = net(train_input);
e = gsubtract(train_target,train_output);
performance = perform(net,train_target,train_output)
% Recalculate Training, Validation and Test Performance
trainTargets = train_target .* tr.trainMask{1};
valTargets = train_target .* tr.valMask{1};
testTargets = train_target .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,train_output)
valPerformance = perform(net,valTargets,train_output)
testPerformance = perform(net,testTargets,train_output)

% View the Network
% view(net)

% Simülasyon
sim_output=sim(net,sim_input);

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotregression(t,y)
% figure, plotfit(net,x,t)

txt_sim_output= sim_output.';
txt_train_output= train_output.';
txt_hata= e.';
% GRAFİK ALMA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
p3 = uipanel('Parent',fig1,'BorderType','none','BackgroundColor','white'); 
p3.Title = ['Train-Test Verileri Doğrulama']; 
p3.TitlePosition = 'centertop'; 
p3.FontSize = 20;
p3.FontWeight = 'bold';
font1= 12;
sz=size(train_input.',1);
eksen_1=1:1:sz;
eksen1=eksen_1';
%%%%%%
s1 = subplot(1,2,1,'Parent',p3);
plot(eksen1,train_target(1,:),'ko',eksen1,train_output(1,:),'rx');
title('Kesme Kuvveti');
xlabel('\bf Veri' ,'fontsize',font1)
ylabel('\bf Kuvvet (N)' ,'fontsize',font1)
legend('Train Target','Train Output','fontsize',font1);

% s2 = subplot(1,2,2,'Parent',p3);
% plot(eksen1,train_target(2,:),'ko',eksen1,train_output(2,:),'rx');
% title('Yüzey Pürüzlülüğü');
% xlabel('\bf Veri' ,'fontsize',font1)
% ylabel('\bf Ra (\mum)' ,'fontsize',font1)
% legend('Train Target','Train Output','fontsize',font1);


% s2 = subplot(3,4,5,'Parent',p3);
% plot(full_degree-full_degree(1),-full_Fy, 'LineWidth',cizgi);
% axis([full_degree(1)-full_degree(1) full_degree(end)-full_degree(1) 0 2500]);
% xlabel('\bf\it Dönüş Açısı, \rm\bf derece','fontsize',font1);
% ylabel('\bf\it Radyal Kuvveti, \rm\bf Fy','fontsize',font1);
% title('Standart Takım');

% TXT dosyasına kaydetme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt_t= train_output.';
fileID=fopen('C:\Users\Kutay\Desktop\train_output_5x1.txt','w+');
fclose(fileID);
for i=1:sz
txt_t_1= txt_t(i,1);
% txt_t_2= txt_t(i,2);
txt_t_11=strrep(sprintf('%.8f',txt_t_1),'.',',');
% txt_t_22=strrep(sprintf('%.8f',txt_t_2),'.',',');
fileID=fopen('C:\Users\Kutay\Desktop\train_output_5x1.txt','a+');
fprintf(fileID,'%s\n', txt_t_11);
fclose(fileID);
end
clear txt_t txt_t_1 txt_t_2 txt_t_11 txt_t_22

txt_t= e.';
fileID=fopen('C:\Users\Kutay\Desktop\train_hata_5x1.txt','w+');
fclose(fileID);
for i=1:sz
txt_t_1= txt_t(i,1);
% txt_t_2= txt_t(i,2);
txt_t_11=strrep(sprintf('%.8f',txt_t_1),'.',',');
% txt_t_22=strrep(sprintf('%.8f',txt_t_2),'.',',');
fileID=fopen('C:\Users\Kutay\Desktop\train_hata_5x1.txt','a+');
fprintf(fileID,'%s\n', txt_t_11);
fclose(fileID);
end
clear txt_t txt_t_1 txt_t_2 txt_t_11 txt_t_22

txt_t= sim_output.';
sz2=size(sim_output.',1);
fileID=fopen('C:\Users\Kutay\Desktop\sim_output_5x1.txt','w+');
fclose(fileID);
for i=1:sz2
txt_t_1= txt_t(i,1);
% txt_t_2= txt_t(i,2);
txt_t_11=strrep(sprintf('%.8f',txt_t_1),'.',',');
% txt_t_22=strrep(sprintf('%.8f',txt_t_2),'.',',');
fileID=fopen('C:\Users\Kutay\Desktop\sim_output_5x1.txt','a+');
fprintf(fileID,'%s\n', txt_t_11);
fclose(fileID);
end
clear txt_t txt_t_1 txt_t_2 txt_t_11 txt_t_22
clear ans e i sz sz2 eksen eksen_1 eksen1 fileID font1 hiddenLayerSize ...
    net p3 s1 s2 tr trainFcn valPerformance valTargets testTargets trainTargets


