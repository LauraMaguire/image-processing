function [roifilename] = expROIs(expPath, data)

roifilename = strcat(expPath(1:end-4),'_rois.mat');

grnList = data{1,1}(1:2:length(data{1,1}));
redList = data{1,1}(2:2:length(data{1,1}));

composite = imfuse(imadjust(grnList{1,end}), imadjust(redList{1,end}), 'falsecolor');
note = 'Rotate image by 90 degrees? Type y or n and hit enter.';

imshow(composite)
t=annotation('textbox', [0.1,0.1,0.1,0.1],'String', {note});
t.BackgroundColor = 'w';
t.FontSize = 18;
rotate = input('Rotate by 90 degrees? (y/n) \n','s');
close all

while strcmp(rotate,'y')
    rotate90(data); % doesn't work
    imshow(composite)
    t=annotation('textbox', [0.1,0.1,0.1,0.1],'String', {note});
    t.BackgroundColor = 'w';
    t.FontSize = 18;
    rotate = input('Rotate by 90 degrees? (y/n) \n','s');
    close all
end
accept = 'n';
while ~strcmp(accept,'y')
    MakeROIs(data, roifilename);
    accept = input('Accept ROIs? (y/n) \n','s');
end
close all
end