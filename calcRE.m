function RE=calcRE(gercek,hesaplanan) 
% hesaplanan
% gercek 
RE=mean((abs(hesaplanan-gercek))./gercek);