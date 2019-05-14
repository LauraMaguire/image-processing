
i=7;
%% grouped by chamber
hold on
for n=i:i+2
    plot(results{n}.time,results{n}.norm2(1,:),'o');
end
    legend({'control','FSFG cct1','FSFG cct2'},'Location','Northwest');
for n=i:i+2
    y = a(n,1).*exp(-tau(n,1)./(2.*results{n}.time))...
        .*(besseli(0,tau(n,1)./(2.*results{n}.time))+...
        besseli(1,tau(n,1)./(2.*results{n}.time)))+c(n,1);
    if a(n,1)>0
        plot(results{n}.time,y,'k','HandleVisibility','off');
    end
end
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('NTF2, intensities normalized to whole-gel average');
%%
hold on
for n=i:i+2
    plot(results{n}.time,results{n}.norm2(1,:)/results{n}.norm2(1,1),'o');
end
    legend({'control','FSFG cct1','FSFG cct2'},'Location','Northwest');
for n=i:i+2
    y = a(n,1).*exp(-tau(n,1)./(2.*results{n}.time))...
        .*(besseli(0,tau(n,1)./(2.*results{n}.time))+...
        besseli(1,tau(n,1)./(2.*results{n}.time)))+c(n,1);
    %if a(n,1)>0
        plot(results{n}.time,y/results{n}.norm2(1,1),'k','HandleVisibility','off');
    %end
end
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('NTF2, intensities normalized to whole-gel average, start at 1');
%%
hold on
for n=i:i+2
    plot(results{n}.time,results{n}.norm2(2,:),'o');
end
    legend({'control','FSFG cct1','FSFG cct2'},'Location','Northwest');
for n=i:i+2
    y = a(n,2).*exp(-tau(n,2)./(2.*results{n}.time))...
        .*(besseli(0,tau(n,2)./(2.*results{n}.time))+...
        besseli(1,tau(n,2)./(2.*results{n}.time)))+c(n,2);
    if a(n,1)>0
        plot(results{n}.time,y,'k','HandleVisibility','off');
    end
end
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('mCherry, intensities normalized to whole-gel average');
%%
hold on
for n=i:i+2
    plot(results{n}.time,results{n}.norm2(2,:)/results{n}.norm2(2,1),'o');
end
    legend({'control','FSFG cct1','FSFG cct2'},'Location','Northwest');
for n=i:i+2
    y = a(n,2).*exp(-tau(n,2)./(2.*results{n}.time))...
        .*(besseli(0,tau(n,2)./(2.*results{n}.time))+...
        besseli(1,tau(n,2)./(2.*results{n}.time)))+c(n,2);
    %if a(n,1)>0
        plot(results{n}.time,y/results{n}.norm2(2,1),'k','HandleVisibility','off');
    %end
end
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('mCherry, intensities normalized to whole-gel average, start at 1');

%% grouped by type, normed to 1
hold on
for n=[4 7 10 13 16 19]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'bo');
end
for n=[5 8 11 14 17 20]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
end
for n=[6 9 12 15 18 21]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
end
% for n=[3 6 9]
%     plot(results{n}.time,results{n}.norm2(1,:)/results{n}.norm2(1,1),'yo');
% end
    %legend({'1','FSFG cct1','FSFG cct2'},'Location','Northwest');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('NTF2, intensities normalized to whole-gel average');

%% grouped by type mCherry, normed to 1
hold on
for n=[4 7 10 13 16 19]
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'bo');
end
for n=[5 8 11 14 17 20]
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'ro');
end
for n=[6 9 12 15 18 21]
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'go');
end
% for n=[3 6 9]
%     plot(results{n}.time,results{n}.norm2(1,:)/results{n}.norm2(1,1),'yo');
% end
    %legend({'1','FSFG cct1','FSFG cct2'},'Location','Northwest');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('mCherry, intensities normalized to whole-gel average');
%%
% grouped by type, normed to 1, mCherry
figure
hold on
for n=[1 4 7]
    plot(results{n}.time,results{n}.norm2(2,:)/results{n}.norm2(2,1),'bo');
end
for n=[2 5 8]
    plot(results{n}.time,results{n}.norm2(2,:)/results{n}.norm2(2,1),'ro');
end
for n=[3 6 9]
    plot(results{n}.time,results{n}.norm2(2,:)/results{n}.norm2(2,1),'yo');
end
    %legend({'1','FSFG cct1','FSFG cct2'},'Location','Northwest');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('mCherry, intensities normalized to whole-gel average');
%%
b=load('/Volumes/houghgrp/Processed Images/2019-2-12_1/all-params.mat');
a = load('/Volumes/houghgrp/Processed Images/2019-2-6_1/all-params.mat');
%%

b.name = {'02-12 1 ctrl','02-12 1 cct1','02-12 1 cct2','02-12 2 ctrl',...
    '02-12 2 cct1','02-12 2 cct2','02-12 3 ctrl','02-12 3 cct1',...
    '02-12 3 cct2'};
a.name = {'02-06 1 ctrl','02-06 1 cct1','02-06 1 cct2','02-06 2 ctrl',...
    '02-06 2 cct1','02-06 2 cct2','02-06 3 ctrl','02-06 3 cct1',...
    '02-06 3 cct2','02-06 4 ctrl','02-06 4 cct1','02-06 4 cct2'};
%%
name = [a.name b.name];
%%
D = vertcat(a.D,b.D);
w = vertcat(a.w, b.w);
tau = vertcat(a.tau,b.tau);
amp= vertcat(a.a,b.a);
offset = vertcat(a.c,b.c);
partC = vertcat(a.partC,b.partC);
bProb = vertcat(a.bProb,b.bProb);
dBound = vertcat(a.dBound,b.dBound);
%%
for i=1:12
    a.norm{i} = a.results{i}.norm2;
end
for i=1:9
    b.norm{i} = b.results{i}.norm2;
end
%%
norm = [a.norm,b.norm];

%%
for i=1:12
    a.time{i} = a.results{i}.time;
end
for i=1:9
    b.time{i} = b.results{i}.time;
end
time = [a.time,b.time];

%% ctrl gels, normed to 1
hold on
plot(time{4},norm{n}(1,:)/norm{n}(1,1),'bo');
plot(time{4},norm{n}(2,:)/norm{n}(2,1),'ro');
for n=[7 10 13 16 19]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'bo','HandleVisibility','off');
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('No-FSFG gels');
%% cct1 gels, normed to 1
hold on
plot(time{5},norm{n}(1,:)/norm{n}(1,1),'bo');
plot(time{5},norm{n}(2,:)/norm{n}(2,1),'ro');
for n=[8 11 14 17 20]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'bo','HandleVisibility','off');
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('FSFG-1 gels');
%% cct2 gels, normed to 1
hold on
plot(time{6},norm{n}(1,:)/norm{n}(1,1),'bo');
plot(time{6},norm{n}(2,:)/norm{n}(2,1),'ro');
for n=[9 12 15 18 21]
    plot(time{n},norm{n}(1,:)/norm{n}(1,1),'bo','HandleVisibility','off');
    plot(time{n},norm{n}(2,:)/norm{n}(2,1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (s)');
title('FSFG-2 gels');
%% ctrl gels, normed to 1 and 0
hold on
zeroNorm1 = norm{4}(1,:)-norm{4}(1,2);
zeroNorm2 = norm{4}(2,:)-norm{4}(2,2);
plot(time{4}/60,zeroNorm1/zeroNorm1(1),'bo');
plot(time{4}/60,zeroNorm2/zeroNorm2(1),'ro');
for n=[7 10 16 19] %weird one is 13
    zeroNorm1 = norm{n}(1,:)-norm{n}(1,2);
    zeroNorm2 = norm{n}(2,:)-norm{n}(2,2);
    plot(time{n}/60,zeroNorm1/zeroNorm1(1),'bo','HandleVisibility','off');
    plot(time{n}/60,zeroNorm2/zeroNorm2(1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (min)');
title('No-FSFG gels');
%% cct1 gels, normed to 1 and zero
hold on
zeroNorm1 = norm{5}(1,:)-norm{5}(1,2);
zeroNorm2 = norm{5}(2,:)-norm{5}(2,2);
plot(time{5}/60,zeroNorm1/zeroNorm1(1),'bo');
plot(time{5}/60,zeroNorm2/zeroNorm2(1),'ro');
for n=[8 11 14 17 20]
    zeroNorm1 = norm{n}(1,:)-norm{n}(1,2);
    zeroNorm2 = norm{n}(2,:)-norm{n}(2,2);
    plot(time{n}/60,zeroNorm1/zeroNorm1(1),'bo','HandleVisibility','off');
    plot(time{n}/60,zeroNorm2/zeroNorm2(1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (min)');
title('FSFG-1 gels');
%% cct2 gels, normed to 1
hold on
zeroNorm1 = norm{6}(1,:)-norm{6}(1,2);
zeroNorm2 = norm{6}(2,:)-norm{6}(2,2);
plot(time{6}/60,zeroNorm1/zeroNorm1(1),'bo');
plot(time{6}/60,zeroNorm2/zeroNorm2(1),'ro');
for n=[9 12 15 18 21]
    zeroNorm1 = norm{n}(1,:)-norm{n}(1,2);
    zeroNorm2 = norm{n}(2,:)-norm{n}(2,2);
    plot(time{n}/60,zeroNorm1/zeroNorm1(1),'bo','HandleVisibility','off');
    plot(time{n}/60,zeroNorm2/zeroNorm2(1),'ro','HandleVisibility','off');
end
% for n=[5 8 11 14 17 20]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'ro');
% end
% for n=[6 9 12 15 18 21]
%     plot(time{n},norm{n}(1,:)/norm{n}(1,1),'go');
% end

legend({'NTF2-FITC','mCherry'},'Location','Southeast');
hold off
ylabel('Intensity');
xlabel('Time (min)');
title('FSFG-2 gels');

%%
hold on
histogram(D([4 7 10 16 19],1),10);
histogram(D([4 7 10 16 19],2),10);
hold off
figure
hold on
histogram(D([5 8 11 14 17 20],1),10);
histogram(D([5 8 11 14 17 20],2),10);
hold off
figure
hold on
histogram(D([6 9 12 15 18 21],1),10);
histogram(D([6 9 12 15 18 21],2),10);
hold off