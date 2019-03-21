list = dir('/Volumes/houghgrp/Processed Images');
list = list(4:end);
runs = length(list);

%%
masterInfo = cell(runs,1);
masterPlots = cell(runs,1);
%%

for r=1:runs
    filepath = [list(r).folder '/' list(r).name];
    cd(filepath);
    
    i = dir('*info.mat');
    load(i.name);
    masterInfo{r} = info;
    
%     p = dir('*plots.mat');
%     load(p.name);
%     masterPlots{r} = plots;
    
    disp(r);
end