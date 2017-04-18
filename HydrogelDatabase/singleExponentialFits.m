%%

%% Only run this once!
sat = zeros(2, length(expFile));
singleTau = zeros(2, length(expFile));
singleGOF = zeros(10,length(expFile));

%%
for i=44:50
    close all
    greenOutlet = data{i}.outlet(1,:)./data{i}.inlet(1,:);
    time = data{i}.time;
    [fitresult, gof] = createSingleFit(time, greenOutlet);
    sat(1,i) = fitresult.c;
    singleTau(1,i) = fitresult.tau;
    singleGOF(1,i) = gof.sse;
    singleGOF(2,i) = gof.rsquare;
    singleGOF(3,i) = gof.dfe;
    singleGOF(4,i) = gof.adjrsquare;
    singleGOF(5,i) = gof.rmse;
    saveas(gcf,[ 'Z:\Processed Images\Analysis\FSFG dataset\one-exponent-green\fig' num2str(i)],'jpg');
    display(num2str(i/length(expFile)));
end

%%
for i=44:50
    close all
    Outlet = data{i}.outlet(2,:)./data{i}.inlet(2,:);
    time = data{i}.time;
    [fitresult, gof] = createSingleFit(time, Outlet);
    sat(1,i) = fitresult.c;
    singleTau(2,i) = fitresult.tau;
    singleGOF(6,i) = gof.sse;
    singleGOF(7,i) = gof.rsquare;
    singleGOF(8,i) = gof.dfe;
    singleGOF(9,i) = gof.adjrsquare;
    singleGOF(10,i) = gof.rmse;
    saveas(gcf,[ 'Z:\Processed Images\Analysis\FSFG dataset\one-exponent-red\fig' num2str(i)],'jpg');
    display(num2str(i/length(expFile)));
end

%%
plot(singleGOF(1,1:8), 'bo')

%%double exponential green fits
bad = [9,11,12,13,14,18,19,20,30,31,33,34,35,36,38,39,40,41,42,43];
good = [1,2,3,4,6,7,8,10,15,16,17,21,22,23,24,25,26,27,28,29,32,37];
dyefit = 5;
dubiousGels = [9,14,17,19,20];
fo = [15,16,23,24,25,26,28,29,31,33,34,36];

%%
close all
figure
hold on
plot(gelWidths(1,okay),tauDye(1,okay),'bo');
xlabel('Mean gel width (um)');
ylabel('Dye lifetime (min)');
title('Dye lifetime vs. gel width');
hold off

figure
hold on
plot(gelWidths(1,okay),tau(1,okay),'ro');
xlabel('Mean gel width (um)');
ylabel('Protein lifetime (min)');
title('Protein lifetime vs. gel width');
hold off


figure
hold on
plot(gelWidths(1,okay),dyeFraction(1,okay),'go');
xlabel('Mean gel width (um)');
ylabel('Dye fraction');
title('Dye fraction vs. gel width');
hold off

%%
close all
figure
hold on
plot(singleGOF(10,:),singleGOF(5,:),'bo');
xx=0.001*(1:100);
plot(xx,xx,'k--');
xlabel('Red one-component rmse');
ylabel('Green one-component rmse');
title('Compare red and green one-component fits');
axis([0 0.01 0 0.05]);
hold off

figure
hold on
plot(GOF(10,:),GOF(5,:),'bo');
xx=0.001*(1:100);
plot(xx,xx,'k--');
xlabel('Red two-component rmse');
ylabel('Green two-component rmse');
title('Compare red and green two-component fits');
axis([0 0.05 0 0.05]);
hold off

figure
plot(GOF(4,:),singleGOF(4,:),'ko');
hold all
xx=0.01*(1:1000)-0.01;
plot(xx,xx,'k--');
xlabel('Green two-component adj. R-square');
ylabel('Green one-component adj. R-square');
title('Compare green one- and two-component fits');
 axis([0.92 1 0.8 1]);
hold off

figure
hold on
plot(GOF(9,:),singleGOF(9,:),'ro');
xx=0.01*(1:1000)-0.01;
plot(xx,xx,'k--');
xlabel('Red two-component adj. R-square');
ylabel('Red one-component adj. R-square');
title('Compare red one- and two-component fits');
axis([0 1 0 1]);
hold off

%% green and red lifetimes
figure
%hold on
plot(tau(1,cb)/60,singleTau(2,cb)/60,'ko','MarkerFaceColor','k');
hold all
plot(tau(1,fb01)/60,singleTau(2,fb01)/60,'bo','MarkerFaceColor','b');
plot(tau(1,fb05)/60,singleTau(2,fb05)/60,'co','MarkerFaceColor','c');
plot(tau(1,fb10)/60,singleTau(2,fb10)/60,'go','MarkerFaceColor','g');
plot(tau(1,fb30)/60,singleTau(2,fb30)/60,'mo','MarkerFaceColor','m');
plot(tau(1,fb50)/60,singleTau(2,fb50)/60,'ro','MarkerFaceColor','r');
plot(tau(1,sb)/60,singleTau(2,sb)/60,'ro');
plot(tau(1,dye)/60,singleTau(2,dye)/60,'go');
%plot(tau(1,fb),singleTau(2,fb),'bo');
xx=(1:100);
plot(xx,xx,'k--');
legend('0','1', '5','10','30','50','SSSG', 'free dye',...
    'Location','northeast');
xlabel('Green lifetime (hr) (2-fit)');
ylabel('Red lifetime (hr) (1-fit)');
title('Red vs. green lifetimes');
%axis([0 10000 0 10000]);
%hold off

%%
for i=1:length(expFile)
    tauRatio(i) = tau(1,i)/singleTau(2,i);
end
%%
%% green and red lifetimes
figure
%hold on
plot(gelWidths(1,cb),1./tauRatio(cb),'ko','MarkerFaceColor','k');
hold all
plot(gelWidths(1,fb01),1./tauRatio(fb01),'bo','MarkerFaceColor','b');
plot(gelWidths(1,fb05),1./tauRatio(fb05),'co','MarkerFaceColor','c');
plot(gelWidths(1,fb10),1./tauRatio(fb10),'go','MarkerFaceColor','g');
plot(gelWidths(1,fb30),1./tauRatio(fb30),'mo','MarkerFaceColor','m');
plot(gelWidths(1,fb50),1./tauRatio(fb50),'ro','MarkerFaceColor','r');
plot(gelWidths(1,sb),1./tauRatio(sb),'ro');
%plot(gelWidths(1,dye),1./tauRatio(dye),'go');
%plot(tau(1,fb),singleTau(2,fb),'bo');
% xx=(1:100);
% plot(xx,xx,'k--');
legend('0','1', '5','10','30','50','SSSG', 'free dye',...
    'Location','northeast');
xlabel('Mean gel width (um)');
ylabel('Red/green lifetime ratio');
title('Red/green lifetime ratio vs gel width');
%axis([0 10000 0 10000]);
%hold off

%% bad fits
k = find(dyeFraction(1,:)<0.01);
m = setdiff(1:length(dyeFraction(1,:)),k);

%plot(gelWidths(1,m),tau(1,m),'bo')
hold on
plot(gelWidths(1,k),singleTau(1,k),'go')
plot(gelWidths(1,:),singleTau(2,:),'ro')
axis([0 500 0 400*60])
