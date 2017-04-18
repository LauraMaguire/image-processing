%% Workspace / scratchwork for FSFG plots
%  Laura Maguire 5/9/16

% Don't run any section until the script 'databaseBuilder' has been run in
% its entirety.  Each section creates a plot.  Add more sections if there
% are more things you want to plot.


%% Plot 2-hr green/red acc. ratio as a function of FSFG concentration
close all
figure
hold on
plot(conc(fb),twoHrOutletRatio(fb),'ko');
plot(conc(sb),twoHrOutletRatio(sb),'ro','MarkerFaceColor','r');
plot(conc(dye),twoHrOutletRatio(dye),'go','MarkerFaceColor','g');
%axis([0 50 -0.01 50]);
xlabel('FSFG concentration (mg/mL)')
ylabel('Green/red ratio')
title('Green/red accumulation ratio at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only','Location','northeast')
hold off

%%
means = [mean(twoHrOutletRatio(sb)),mean(twoHrOutletRatio(cb)),...
    mean(twoHrOutletRatio(fb01)),mean(twoHrOutletRatio(fb05)),...
    mean(twoHrOutletRatio(fb10)),mean(twoHrOutletRatio(fb30)),...
    mean(twoHrOutletRatio(fb50))];

stdevs = [std(twoHrOutletRatio(sb)),std(twoHrOutletRatio(cb)),...
    std(twoHrOutletRatio(fb01)),std(twoHrOutletRatio(fb05)),...
    std(twoHrOutletRatio(fb10)),std(twoHrOutletRatio(fb30)),...
    std(twoHrOutletRatio(fb50))];

%% plot 2-hr green/red acc. ratio as a function of gel width
close all
figure
hold on
plot(gelWidths(1,fb),twoHrOutletRatio(fb),'bo');
plot(gelWidths(1,sb),twoHrOutletRatio(sb),'ro','MarkerFaceColor','r');
plot(gelWidths(1,dye),twoHrOutletRatio(dye),'go','MarkerFaceColor','g');
plot(gelWidths(1,cb),twoHrOutletRatio(cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
xlabel('Mean gel width (um)')
ylabel('Green/red ratio')
title('Green/red accumulation ratio at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% plot 2-hr green/red acc. ratio as a function of gel width
close all
figure
hold on
plot(gelWidths(1,fb10),twoHrOutletRatio(fb10),'bo','MarkerFaceColor','b');
plot(gelWidths(1,sb),twoHrOutletRatio(sb),'rd','MarkerFaceColor','r');
plot(gelWidths(1,dye),twoHrOutletRatio(dye),'gs','MarkerFaceColor','g');
plot(gelWidths(1,cb),twoHrOutletRatio(cb),'k+','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
xlabel('Mean gel width (um)')
ylabel('Green/red ratio')
title('Green/red accumulation ratio at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% plot 2-hr red acc. as a function of width
close all
figure
hold on
plot(gelWidths(1,fb),twoHrOutlet(2,fb),'bo');
plot(gelWidths(1,sb),twoHrOutlet(2,sb),'ro','MarkerFaceColor','r');
plot(gelWidths(1,dye),twoHrOutlet(2,dye),'go','MarkerFaceColor','g');
plot(gelWidths(1,cb),twoHrOutlet(2,cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
xlabel('Mean gel width (um)')
ylabel('Normalized accumulation')
title('Red accumulation at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% plot 2-hr red acc. as a function of width (FSFG only)
close all
figure
hold on
plot(gelWidths(1,cb),twoHrOutlet(2,cb),'ko','MarkerFaceColor','k');
plot(gelWidths(1,fb01),twoHrOutlet(2,fb01),'bo','MarkerFaceColor','b');
plot(gelWidths(1,fb05),twoHrOutlet(2,fb05),'co','MarkerFaceColor','c');
plot(gelWidths(1,fb10),twoHrOutlet(2,fb10),'go','MarkerFaceColor','g');
plot(gelWidths(1,fb30),twoHrOutlet(2,fb30),'mo','MarkerFaceColor','m');
plot(gelWidths(1,fb50),twoHrOutlet(2,fb50),'ro','MarkerFaceColor','r');
plot(gelWidths(1,[ps50 ps100]),twoHrOutlet(2,[ps50 ps100]),'ko','MarkerFaceColor','y');
%plot(gelWidths(1,pinned),twoHrOutlet(2,pinned),'ko');
xlabel('Mean gel width (um)')
ylabel('Normalized accumulation')
title('Red accumulation at t = 2 hr')
legend('0','1', '5','10','30','50', '10 PS',...
    'Location','northeast')
hold off

%% plot 2-hr red acc. as a function of outlet area
close all
figure
hold on
plot(outletArea(fb),twoHrOutlet(2,fb),'bo');
plot(outletArea(sb),twoHrOutlet(2,sb),'ro','MarkerFaceColor','r');
plot(outletArea(dye),twoHrOutlet(2,dye),'go','MarkerFaceColor','g');
plot(outletArea(cb),twoHrOutlet(2,cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
xlabel('Outlet area (um^2)')
ylabel('Normalized accumulation')
title('Red accumulation at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','west')
hold off

%% plot 2-hr red acc. as a function of outlet area (FSFG only)
close all
figure
hold on
plot(outletArea(cb),twoHrOutlet(2,cb),'ko','MarkerFaceColor','k');
plot(outletArea(fb01),twoHrOutlet(2,fb01),'bo','MarkerFaceColor','b');
plot(outletArea(fb05),twoHrOutlet(2,fb05),'co','MarkerFaceColor','c');
plot(outletArea(fb10),twoHrOutlet(2,fb10),'go','MarkerFaceColor','g');
plot(outletArea(fb30),twoHrOutlet(2,fb30),'mo','MarkerFaceColor','m');
plot(outletArea(fb50),twoHrOutlet(2,fb50),'ro','MarkerFaceColor','r');
plot(outletArea([ps50 ps100]),twoHrOutlet(2,[ps50 ps100]),'ko','MarkerFaceColor','y');
xlabel('Outlet area (um^2)')
ylabel('Normalized accumulation')
title('Red accumulation at t = 2 hr')
legend('0','1', '5','10','30','50','10 PS',...
    'Location','northeast')
hold off

%% EXTRA STUFF
%% Normalize by width of gel
figure
hold on
% plot(conc(fb),(twoHrOutletRatio(fb)./outletArea(fb))./gelWidths(1,fb),'bo');
% plot(conc(sb),(twoHrOutletRatio(sb)./outletArea(sb))./gelWidths(1,sb),'ro','MarkerFaceColor','r');
% plot(conc(dye),(twoHrOutletRatio(dye)./outletArea(dye))./gelWidths(1,dye),'go','MarkerFaceColor','g');
% plot(conc(cb),(twoHrOutletRatio(cb)./outletArea(cb))./gelWidths(1,cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
plot(conc(fb),(twoHrOutletRatio(fb))./gelWidths(1,fb),'bo');
plot(conc(sb),(twoHrOutletRatio(sb))./gelWidths(1,sb),'ro','MarkerFaceColor','r');
plot(conc(dye),(twoHrOutletRatio(dye))./gelWidths(1,dye),'go','MarkerFaceColor','g');
plot(conc(cb),(twoHrOutletRatio(cb))./gelWidths(1,cb),'ko','MarkerFaceColor','k');
xlabel('FSFG concentration (mg/mL)')
ylabel('Normalized accumulation divided by mean gel thickness')
title('Ratio at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% Red accumulation vs crosslinking time
figure
hold on
% plot(conc(fb),(twoHrOutletRatio(fb)./outletArea(fb))./gelWidths(1,fb),'bo');
% plot(conc(sb),(twoHrOutletRatio(sb)./outletArea(sb))./gelWidths(1,sb),'ro','MarkerFaceColor','r');
% plot(conc(dye),(twoHrOutletRatio(dye)./outletArea(dye))./gelWidths(1,dye),'go','MarkerFaceColor','g');
% plot(conc(cb),(twoHrOutletRatio(cb)./outletArea(cb))./gelWidths(1,cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
plot(linkTime(fb),(twoHrOutletRatio(fb)),'bo');
plot(linkTime(sb),(twoHrOutletRatio(sb)),'ro','MarkerFaceColor','r');
plot(linkTime(dye),(twoHrOutletRatio(dye)),'go','MarkerFaceColor','g');
plot(linkTime(cb),(twoHrOutletRatio(cb)),'ko','MarkerFaceColor','k');
xlabel('Time (s)')
ylabel('Selectivity')
title('Red acc. at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% total red molecules through gel vs thickness
figure
hold on
plot(gelWidths(1,fb),(twoHrOutlet(2,fb).*outletArea(fb)),'bo');
plot(gelWidths(1,sb),(twoHrOutlet(2,sb).*outletArea(sb)),'ro','MarkerFaceColor','r');
plot(gelWidths(1,dye),(twoHrOutlet(2,dye).*outletArea(dye)),'go','MarkerFaceColor','g');
plot(gelWidths(1,cb),(twoHrOutlet(2,cb).*outletArea(cb)),'ko','MarkerFaceColor','k');
xlabel('Mean gel width (um)')
ylabel('Normalized accumulation times outlet area')
title('Goes like red molecules in outlet at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% total red molecules through gel as a function of width (FSFG only)
%close all
figure
hold on
plot(gelWidths(1,cb),twoHrOutlet(2,cb).*outletArea(cb),'ko','MarkerFaceColor','k');
plot(gelWidths(1,fb01),twoHrOutlet(2,fb01).*outletArea(fb01),'bo','MarkerFaceColor','b');
plot(gelWidths(1,fb05),twoHrOutlet(2,fb05).*outletArea(fb05),'co','MarkerFaceColor','c');
plot(gelWidths(1,fb10),twoHrOutlet(2,fb10).*outletArea(fb10),'go','MarkerFaceColor','g');
plot(gelWidths(1,fb30),twoHrOutlet(2,fb30).*outletArea(fb30),'mo','MarkerFaceColor','m');
plot(gelWidths(1,fb50),twoHrOutlet(2,fb50).*outletArea(fb50),'ro','MarkerFaceColor','r');
plot(gelWidths(1,[ps50 ps100]),twoHrOutlet(2,[ps50 ps100]).*outletArea([ps50 ps100]),'ko','MarkerFaceColor','y');
%plot(gelWidths(1,pinned),twoHrOutlet(2,pinned).*outletArea(pinned),'ko');
xlabel('Mean gel thickness (um)')
ylabel('Normalized accumulation times outlet area')
title('Red accumulation at t = 2 hr')
legend('0','1', '5','10','30','50','10 PS',...
    'Location','northeast')
hold off

%% plot 2-hr RATIO as a function of width
close all
figure
hold on
plot(gelWidths(1,fb),twoHrOutletRatio(fb),'bo');
plot(gelWidths(1,sb),twoHrOutletRatio(sb),'ro','MarkerFaceColor','r');
plot(gelWidths(1,dye),twoHrOutletRatio(dye),'go','MarkerFaceColor','g');
plot(gelWidths(1,cb),twoHrOutletRatio(cb),'ko','MarkerFaceColor','k');
%axis([0 50 -0.01 50]);
xlabel('Mean gel width (um)')
ylabel('Green-to-red ratio')
title('Selectivity at t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% plot 2-hr RATIO as a function of width (FSFG only)
close all
figure
hold on
plot(gelWidths(1,cb),twoHrOutletRatio(cb),'ko','MarkerFaceColor','k');
plot(gelWidths(1,fb01),twoHrOutletRatio(fb01),'bo','MarkerFaceColor','b');
plot(gelWidths(1,fb05),twoHrOutletRatio(fb05),'co','MarkerFaceColor','c');
plot(gelWidths(1,fb10),twoHrOutletRatio(fb10),'go','MarkerFaceColor','g');
plot(gelWidths(1,fb30),twoHrOutletRatio(fb30),'mo','MarkerFaceColor','m');
plot(gelWidths(1,fb50),twoHrOutletRatio(fb50),'ro','MarkerFaceColor','r');
plot(gelWidths(1,[ps50 ps100]),twoHrOutletRatio([ps50 ps100]),'ko','MarkerFaceColor','y');
%plot(gelWidths(1,pinned),twoHrOutletRatio(pinned),'ko');
xlabel('Mean gel width (um)')
ylabel('Green-to-red ratio')
title('Selectivity at t = 2 hr')
legend('0','1', '5','10','30','50','10 PS',...
    'Location','northeast')
hold off

%% plot green vs red
close all
figure
hold on
plot(twoHrOutlet(2,fb),twoHrOutlet(1,fb),'bo');
plot(twoHrOutlet(2,sb),twoHrOutlet(1,sb),'ro','MarkerFaceColor','r');
plot(twoHrOutlet(2,dye),twoHrOutlet(1,dye),'go','MarkerFaceColor','g');
plot(twoHrOutlet(2,cb),twoHrOutlet(1,cb),'ko','MarkerFaceColor','k');
plot(test, test, '--k')
%axis([0 50 -0.01 50]);
xlabel('Red accumulation')
ylabel('Green accumulation')
title('Green vs red accumulation t = 2 hr')
legend('FSFG bar','SSSG bar', 'FSFG bar, free dye only',...
    'Control gels','Location','northeast')
hold off

%% green vs red (FSFG only)
close all
figure
hold on
plot(twoHrOutlet(2,cb),twoHrOutlet(1,cb),'ko','MarkerFaceColor','k');
plot(twoHrOutlet(2,fb01),twoHrOutlet(1,fb01),'bo','MarkerFaceColor','b');
plot(twoHrOutlet(2,fb05),twoHrOutlet(1,fb05),'co','MarkerFaceColor','c');
plot(twoHrOutlet(2,fb10),twoHrOutlet(1,fb10),'go','MarkerFaceColor','g');
plot(twoHrOutlet(2,fb30),twoHrOutlet(1,fb30),'mo','MarkerFaceColor','m');
plot(twoHrOutlet(2,fb50),twoHrOutlet(1,fb50),'ro','MarkerFaceColor','r');
plot(twoHrOutlet(2,[ps50 ps100]),twoHrOutlet(1,[ps50 ps100]),'ko','MarkerFaceColor','y');
%plot(twoHrOutlet(2,pinned),twoHrOutlet(1,pinned),'ko');
plot(test, test, '--k')
xlabel('Red accumulation')
ylabel('Green accumulation')
title('Green vs red accumulation t = 2 hr')
legend('0','1', '5','10','30','50','10 PS',...
    'Location','southeast')
axis([0 0.25 0 0.25]);
hold off


%%
pinned = find(dyeFraction(1,:)<0.001);
%%
hold on
plot(dyeFraction(1,of))
hold off

%%
hold on
plot(tau(1,pinned),dyeFraction(1,pinned),'ko')
hold off