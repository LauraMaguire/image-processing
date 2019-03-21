%%
pos = 1000/128*(1:128);
bind.AC = bind.A_rec+bind.C_rec;
nobind.AC = nobind.A_rec+nobind.C_rec;
t=2e4/60*bind.TimeRec;

%%

figure
set(0,'defaulttextfontsize',18);


plot(200/60*nobind.TimeRec(1:50),nobind.FluxAccum_rec(1:50),'r--','LineWidth',2);
hold all
plot(200/60*bind.TimeRec(1:50),bind.FluxAccum_rec(1:50),'g-','LineWidth',2);
xlabel('Time (min)','FontSize',18);
ylabel('Accumulation','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','northwest');
title('Accumulation (assumes infinite reservoirs)','FontSize',18);

%%

figure
set(0,'defaulttextfontsize',18);


plot(200/60*nobind.TimeRec(1:end),nobind.Flux2Res_rec(1:end),'r--','LineWidth',2);
hold all
plot(200/60*bind.TimeRec(1:end),bind.Flux2Res_rec(1:end),'g-','LineWidth',2);
xlabel('Time (min)','FontSize',18);
ylabel('Flux','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Flux','FontSize',18);

%%
figure
set(0,'defaulttextfontsize',18);

bind.AC = bind.A_rec+bind.C_rec;
nobind.AC = nobind.A_rec+nobind.C_rec;
t = 2e4/60*bind.recObj.TimeRec;
pos = 1e3/128*(1:128);

plot(pos,nobind.AC(:,31)./max(bind.AC(:,31)),'r--','LineWidth',2);
hold all
plot(pos,bind.AC(:,31)./max(bind.AC(:,31)),'g-','LineWidth',2);
xlabel('Position (um)','FontSize',18);
ylabel('Intensity','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Profiles (100 min)','FontSize',18);

%%
%%
figure
s = 244;
f = 150;
e=350;

plot(plots.posAx(f:e),plots.redProfile(s,(f:e)),'r--','LineWidth',2);
hold all
plot(plots.posAx(f:e),plots.grnProfile(s,(f:e)),'g-','LineWidth',2);
%axis([-500 1000 0.1 1.2]);
xlabel('Position (um)','FontSize',18);
ylabel('Intensity','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Profiles (100 min)','FontSize',18);
clear hl

%%
rs = -7.3e-6;
gs = -6.5e-6;
redcor = plots.redProfile(s,:) - rs*plots.posAx;
grncor = plots.grnProfile(s,:) - gs*plots.posAx;

%%
z = 317;
redadj = (redcor-redcor(end))./(redcor(z)-redcor(end));
grnadj = (grncor-grncor(end))./(grncor(z)-grncor(end));

%%
figure
% s = 200;
% f = 70;
% e = 390;
% z = 400;
plot(plots.posAx,redcor,'r--','LineWidth',2);
hold all
plot(plots.posAx,grncor,'g-','LineWidth',2);
%axis([-500 1000 0 1.1]);
xlabel('Position (um)','FontSize',18);
ylabel('Intensity','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Profiles (100 min)','FontSize',18);
clear hl

%%
figure
% s = 200;
% f = 70;
% e = 390;
% z = 400;
plot(plots.posAx,redadj,'r--','LineWidth',2);
hold all
plot(plots.posAx,grnadj,'g-','LineWidth',2);
%axis([-500 1000 0 1.1]);
xlabel('Position (um)','FontSize',18);
ylabel('Intensity','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Profiles (final)','FontSize',18);
clear hl

%%
figure
s = 200;
f = 70;
e = 390;
z = 400;
plot(plots.posAx(f:e)-670,plots.redProfile(s,(f:e))/plots.redProfile(s,z),'r--','LineWidth',2);
hold all
plot(plots.posAx(f:e)-670,plots.grnProfile(s,(f:e))/plots.grnProfile(s,z),'g-','LineWidth',2);
%axis([-500 1000 0.1 1.2]);
xlabel('Position (um)','FontSize',18);
ylabel('Intensity','FontSize',18);
hl=legend('No binding','100 uM K_D');
set(hl,'FontSize',18);
set(hl,'Location','southeast');
title('Profiles (100 min)','FontSize',18);


%%
redcor = plots.redProfile(s,:)/plots.redProfile(s,z)+ 0.000342*plots.posAx;
plot(redcor);
grncor = plots.grnProfile(s,:)/plots.grnProfile(s,z)+ 0.000262*plots.posAx;