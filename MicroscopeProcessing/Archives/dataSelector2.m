plots = cell(length(data),1);


for r=1:length(data)
    info = data{r};
    plots{r} = load([info.baseSavePathMac '/' info.date '/' info.date ...
        '--plots.mat']);
end

%%

for i = 1:length(data)
    p = plots{i}.plots;
    if i==4
        r = p.accumulation(1,:)./p.reservoir(1,:);
    else
        r = p.accumulation(2,:)./p.reservoir(2,:);
    end
    t = p.timeAx;
    [fitresult, gof] = accumulationFit(t, r);
end