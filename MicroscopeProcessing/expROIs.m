function [roifilename] = expROIs(expPath, data)

roifilename = strcat(expPath(1:end-4),'_rois.mat');

grnList = data{1,1}(1:2:length(data{1,1}));
redList = data{1,1}(2:2:length(data{1,1}));

composite = imfuse(imadjust(grnList{1,end}), imadjust(redList{1,end}), 'falsecolor');

imshow(composite)
rotate = input('Rotate by 90 degrees? (y/n) \n','s');
close all
while strcmp(rotate,'y')
    rotate90(data);
    imshow(composite)
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