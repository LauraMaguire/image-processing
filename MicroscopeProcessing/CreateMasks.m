function [ masks ] = CreateMasks( data)

% Stuff
outletThreshold = 0.3;
inletThreshold = 0.6;
%gelThreshold = 0.2;
outletErosion = 50;
inletErosion = 50;
%gelErosion = 7;

ListOfImages = data{1,1};
%GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

% make the outlet white and the rest of the image black
outlet = imextendedmax(RedImages{1,end},outletThreshold);
% erode the outlet ROI away from the edges
outletROI = imerode(outlet,ones(outletErosion)); 
% make the inlet white and the rest of the image black
inlet = imextendedmax(RedImages{1,end},inletThreshold);
% erode the inlet ROI away from the edges
inletROI = imerode(inlet,ones(inletErosion)); 

masks = {inletROI, outletROI};

end