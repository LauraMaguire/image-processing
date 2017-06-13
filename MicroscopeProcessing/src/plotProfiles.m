function [] = plotProfiles(timeAx,posAx,kymo_green,kymo_red,res,info)

grnleg = [num2str(info.greenConc) ' uM ' info.greenName];
redleg = [num2str(info.redConc) ' uM ' info.redName];
textbox = [num2str(info.conc) ' mg/mL ' info.protein ', ' info.geo ', linker: ' info.linker '. ' info.gelNotes];


final_time = int16(timeAx(end));
grnFinal = [grnleg ' ' num2str(final_time) ' min'];
redFinal = [redleg ' ' num2str(final_time) ' min'];
grnInit = [grnleg ' initial'];
redInit = [redleg ' initial'];

figure('DefaultAxesFontSize',18)
plot(posAx, kymo_green(1,:)/res(1,1),'g-')
hold all
plot(posAx, kymo_green(end,:)/res(1,end),'g-','LineWidth',3)
plot(posAx, kymo_red(2,:)/res(2,1), 'r--')
plot(posAx, kymo_red(end,:)/res(2,end), 'r--','LineWidth',3)
title(['Intensity profiles (', info.date, ')'],'Interpreter','None')
legend(grnInit,grnFinal, redInit, ...
    redFinal,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity')
annotation('textbox', [0.4,0.6,0.1,0.1],'String', {textbox, 'Continuously normalized to reservoir.'})

end