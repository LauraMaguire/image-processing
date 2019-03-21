%%
plot(plots.timeAx, plots.accumulation(2,:)/plots.reservoir(2,1),'r');
title('mCherry accumulation within mucus')
%legend(grnInit,grnFinal, redInit, ...
%    redFinal,'Location','northeast')
xlabel('Time (min)')
ylabel('Normalized fluorescence intensity')
xlim([0 plots.timeAx(end)])
%annotation('textbox', [0.4,0.6,0.1,0.1],'String', {textbox, 'Continuously normalized to reservoir.'})








%% norm = plots.accumulation(2,:)./plots.reservoir(2,:);
%%
plot(norm(1:7))

%%
norm2 = plots.accumulation(2,:)/0.0624803988073318;
%%
plot(norm2)
%%
acc = [norm(1:7) 0 0 0 norm2(11:40)];
%%
plot(plots.timeAx(1:length(acc)), acc,'-r')
title('mCherry accumulation within mucus')
%legend(grnInit,grnFinal, redInit, ...
%    redFinal,'Location','northeast')
xlabel('Time (min)')
ylabel('Normalized fluorescence intensity')
%annotation('textbox', [0.4,0.6,0.1,0.1],'String', {textbox, 'Continuously normalized to reservoir.'})

%%
profile2 = plots.redProfile(:,:)/plots.reservoir(2,1);
%%
subplot(2,1,1)
plot(plots.posAx(200:end)-plots.posAx(200),profile2(1,200:end));
hold all 
plot(plots.posAx(200:end)-plots.posAx(200),profile2(37,200:end));
title('mCherry profiles during inflow')
legend('t = 0','t = 5 min')
ylabel('Normed. fluorescence')

subplot(2,1,2)
plot(plots.posAx(200:end)-plots.posAx(200),profile2(51,200:end));
hold all
plot(plots.posAx(200:end)-plots.posAx(200),profile2(end,200:end));
title('mCherry profiles during outflow')
legend('t = 7 min','t = 25 min')
xlabel('Position (microns)')
ylabel('Normed. fluorescence')