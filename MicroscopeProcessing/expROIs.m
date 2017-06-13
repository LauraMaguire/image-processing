function [roifilename, rotatedData] = expROIs(expPath, data)

roifilename = strcat(expPath(1:end-4),'_rois.mat');

grnList = data{1,1}(1:2:length(data{1,1}));
redList = data{1,1}(2:2:length(data{1,1}));

composite = imfuse(imadjust(grnList{1,end}), imadjust(redList{1,end}), 'falsecolor');
note = 'Rotate image by 90 degrees? Type y or n and hit enter.';

imshow(composite,'InitialMagnification',50)
t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', {note});
t.BackgroundColor = 'w';
t.FontSize = 18;
rotate = input('Rotate by 90 degrees? (y/n) \n','s');
close all

while strcmp(rotate,'y')
    data = rotate90(data); % doesn't work
    
    grnList = data{1,1}(1:2:length(data{1,1}));
    redList = data{1,1}(2:2:length(data{1,1}));
    composite = imfuse(imadjust(grnList{1,end}), imadjust(redList{1,end}), 'falsecolor');
    
    imshow(composite,'InitialMagnification',50)
    t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', {note});
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
rotatedData = data;
close all
end