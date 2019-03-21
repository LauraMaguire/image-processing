%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(plots.timeAx, plots.accumulation(1,:)./plots.reservoir(1,:),'g--','LineWidth',3)
hold all
plot(plots.timeAx, plots.accumulation(2,:)./plots.reservoir(2,:),'r--','LineWidth',3)
plot(plots1.timeAx, plots1.accumulation(1,:)./plots1.reservoir(1,:),'g-','LineWidth',3)
plot(plots1.timeAx, plots1.accumulation(2,:)./plots1.reservoir(2,:),'r-','LineWidth',3)
title('Accumulation (FSFG-PEGDA700 replicates)','Interpreter','None')
legend({'NTF2, rep1','mCherry, rep1','NTF2, rep2','mCherry, rep2'},'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.4,0.15,0.1,0.1],'String', {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700','20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})

%%
%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(plots.timeAx, plots.accumulation(1,:)./plots.reservoir(1,:)./(plots.accumulation(2,:)./plots.reservoir(2,:)),'k--','LineWidth',3)
hold all
%plot(plots.timeAx, plots.accumulation(2,:)./plots.reservoir(2,:),'r--','LineWidth',3)
plot(plots1.timeAx, plots1.accumulation(1,:)./plots1.reservoir(1,:)./(plots1.accumulation(2,:)./plots1.reservoir(2,:)),'k-','LineWidth',3)
%plot(plots1.timeAx, plots1.accumulation(2,:)./plots1.reservoir(2,:),'r-','LineWidth',3)
title('Accumulation (FSFG-PEGDA700 replicates)','Interpreter','None')
legend({'NTF2, rep1','mCherry, rep1','NTF2, rep2','mCherry, rep2'},'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
    {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700','20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})
%%
figure('DefaultAxesFontSize',18)
plot(plots.posAx, plots.grnProfile(end,:)/plots.reservoir(1,end),'g-','LineWidth',2)
hold all
plot(plots1.posAx, plots1.grnProfile(end,:)/plots1.reservoir(1,end),'g--','LineWidth',2)
plot(plots.posAx, plots.redProfile(end,:)/plots.reservoir(2,end), 'r-','LineWidth',2)
plot(plots1.posAx, plots1.redProfile(end,:)/plots1.reservoir(2,end), 'r--','LineWidth',2)
title('Final Profiles (FSFG-PEGDA700 replicates)','Interpreter','None')
legend({'NTF2, rep1','NTF2, rep2','mCherry, rep1','mCherry, rep2'},'Location','northeast')
% title(['Intensity profiles (', info.date, ')'],'Interpreter','None')
% legend(grnInit,grnFinal, redInit, ...
%     redFinal,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity at 3 hrs')
annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
    {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700','20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})

%%
%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(plots1.timeAx, plots1.accumulation(1,:)./plots1.reservoir(1,:),'b-','LineWidth',3)
hold all
plot(plots2.timeAx, plots2.accumulation(1,:)./plots2.reservoir(1,:),'r-','LineWidth',3)
plot(plots3.timeAx, plots3.accumulation(1,:)./plots3.reservoir(1,:),'g-','LineWidth',3)
plot(plots4.timeAx, plots4.accumulation(1,:)./plots4.reservoir(1,:),'k-','LineWidth',3)

plot(plots1.timeAx, plots1.accumulation(2,:)./plots1.reservoir(2,:),'b--','LineWidth',3)
plot(plots2.timeAx, plots2.accumulation(2,:)./plots2.reservoir(2,:),'r--','LineWidth',3)
plot(plots3.timeAx, plots3.accumulation(2,:)./plots3.reservoir(2,:),'g--','LineWidth',3)
plot(plots4.timeAx, plots4.accumulation(2,:)./plots4.reservoir(2,:),'k--','LineWidth',3)
title('Accumulation (FSFG-PEGDA700 replicates)','Interpreter','None')
%legend({'NTF2, rep1','mCherry, rep1','NTF2, rep2','mCherry, rep2'},'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
%annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
%    {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700',...
%    '20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})

%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(plots1.timeAx, plots1.accumulation(1,:)./plots1.reservoir(1,:)./(plots1.accumulation(2,:)./plots1.reservoir(2,:)),'b-','LineWidth',3)
hold all
plot(plots2.timeAx, plots2.accumulation(1,:)./plots2.reservoir(1,:)./(plots2.accumulation(2,:)./plots2.reservoir(2,:)),'r-','LineWidth',3)
plot(plots3.timeAx, plots3.accumulation(1,:)./plots3.reservoir(1,:)./(plots3.accumulation(2,:)./plots3.reservoir(2,:)),'g-','LineWidth',3)
plot(plots4.timeAx, plots4.accumulation(1,:)./plots4.reservoir(1,:)./(plots4.accumulation(2,:)./plots4.reservoir(2,:)),'k-','LineWidth',3)

title('Accumulation Ratio (FSFG-PEGDA700 replicates)','Interpreter','None')
%legend({'NTF2, rep1','mCherry, rep1','NTF2, rep2','mCherry, rep2'},'Location','northeast')
xlabel('Time (minutes)')
ylabel('Green/Red Intensity Ratio')
%annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
%    {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700',...
%    '20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})

%%
figure('DefaultAxesFontSize',18)
plot(plots1.posAx, plots1.grnProfile(end,:)/plots1.reservoir(1,end),'b-','LineWidth',2)
hold all
plot(plots2.posAx, plots2.grnProfile(end,:)/plots2.reservoir(1,end),'r-','LineWidth',2)
plot(plots3.posAx, plots3.grnProfile(end,:)/plots3.reservoir(1,end),'g-','LineWidth',2)
plot(plots4.posAx, plots4.grnProfile(end,:)/plots4.reservoir(1,end),'k-','LineWidth',2)

% plot(plots1.posAx, plots1.grnProfile(end,:)/plots1.reservoir(1,end),'g--','LineWidth',2)
% plot(plots.posAx, plots.redProfile(end,:)/plots.reservoir(2,end), 'r-','LineWidth',2)
% plot(plots1.posAx, plots1.redProfile(end,:)/plots1.reservoir(2,end), 'r--','LineWidth',2)
title('Final Green Profiles (FSFG-PEGDA700 replicates)','Interpreter','None')
%legend({'NTF2, rep1','NTF2, rep2','mCherry, rep1','mCherry, rep2'},'Location','northeast')
% title(['Intensity profiles (', info.date, ')'],'Interpreter','None')
% legend(grnInit,grnFinal, redInit, ...
%     redFinal,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity at 3 hrs')
% annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
%     {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700',...
%     '20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})
%%
figure('DefaultAxesFontSize',18)
plot(plots1.posAx, plots1.redProfile(end,:)/plots1.reservoir(2,end),'b--','LineWidth',2)
hold all
plot(plots2.posAx, plots2.redProfile(end,:)/plots2.reservoir(2,end),'r--','LineWidth',2)
plot(plots3.posAx, plots3.redProfile(end,:)/plots3.reservoir(2,end),'g--','LineWidth',2)
plot(plots4.posAx, plots4.redProfile(end,:)/plots4.reservoir(2,end),'k--','LineWidth',2)

% plot(plots1.posAx, plots1.grnProfile(end,:)/plots1.reservoir(1,end),'g--','LineWidth',2)
% plot(plots.posAx, plots.redProfile(end,:)/plots.reservoir(2,end), 'r-','LineWidth',2)
% plot(plots1.posAx, plots1.redProfile(end,:)/plots1.reservoir(2,end), 'r--','LineWidth',2)
title('Final Red Profiles (FSFG-PEGDA700 replicates)','Interpreter','None')
%legend({'NTF2, rep1','NTF2, rep2','mCherry, rep1','mCherry, rep2'},'Location','northeast')
% title(['Intensity profiles (', info.date, ')'],'Interpreter','None')
% legend(grnInit,grnFinal, redInit, ...
%     redFinal,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity at 3 hrs')
% annotation('textbox', [0.4,0.15,0.1,0.1],'String',...
%     {'1 uL drop. 6% ac. 29:1 ac:bis-ac','10 mg/mL FSFG-PEGDA700',...
%     '20 uM NTF2 and mCherry in PTB','Intensity continuously normalized to reservoir.'})