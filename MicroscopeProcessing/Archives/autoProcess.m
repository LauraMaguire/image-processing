function [ output ] = autoProcess( data, roisfilename, series)
% BFprocess uses the previously-defined ROIs to calculate the average
% intensity of the inlet, outlet, and background, and to create a
% kymograph.

% Modified 10/13/15 by LKM.
% Originally modified from a script made by Loren and Grant.

file_size = size(data{1,1},1);
global scale inletThreshold

% If user has not specified a series number, use the first series.
if nargin < 3
    series =1;
end

% Load the previously-defined coordinates of the four ROIs.
ROIs = load(roisfilename);

% Pre-allocate vectors that will be filled later.
inlet = zeros(2,file_size/2);
outlet = zeros(2,file_size/2);
bkgrnd = zeros(2,file_size/2);

% Some useful definitions
ListOfImages = data{1,1};
GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

%ASSUMES NUMBER OF CHANNELS IS 2

for i = 1:file_size/2
    mygreendata = im2double(data{series,1}{2*i-1,1});
    myreddata = im2double(data{series,1}{2*i,1});
    if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        BWB = roipoly(ROIs.xB1, ROIs.yB1, mygreendata, ROIs.xB2, ROIs.yB2);
        BWC = roipoly(ROIs.xC1, ROIs.yC1, mygreendata, ROIs.xC2, ROIs.yC2);
        BWD = roipoly(ROIs.xD1, ROIs.yD1, mygreendata, ROIs.xD2, ROIs.yD2);
    end
        
    % Define current green and red images
    grnImage = im2double(GreenImages{1,i});
    redImage = im2double(RedImages{1,i});
        
    % Mask image EXCEPT for outlet
    outletROI = imerode(BWC,ones(50)); 
    grnOutlet = grnImage.*outletROI;
    redOutlet = redImage.*outletROI;

    % Calculate mean intensity of outlet
    outletPixels = sum(sum(outletROI)); % total pixels in outlet
        
    grnOutletIntensity = sum(sum(grnOutlet)); % total green intensity
    avgGrnOutlet = grnOutletIntensity/outletPixels;
        
    redOutletIntensity = sum(sum(redOutlet)); % total red intensity
    avgRedOutlet = redOutletIntensity/outletPixels;
    
    % make the inlet white and the rest of the image black
    adj = imadjust(redImage,[0; scale], [0; 1] );
    inletMask = imextendedmax(adj,inletThreshold);
    % erode the inlet ROI away from the edges
    inletROI = imerode(inletMask,ones(50)); 
        
    % Mask image EXCEPT for inlet
    grnInlet = grnImage.*inletROI;
    redInlet = redImage.*inletROI;

    % Calculate mean intensity of outlet
    inletPixels = sum(sum(inletROI)); % total pixels in inlet
        
    grnInletIntensity = sum(sum(grnInlet)); % total green intensity
    avgGrnInlet = grnInletIntensity/inletPixels;
        
    redInletIntensity = sum(sum(redInlet)); % total red intensity
    avgRedInlet = redInletIntensity/inletPixels;
    
    if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        npixelsB = max(sum(BWB));
        npixelsD = sum(sum(BWD));
    end
    
    % Append avg inlet intensities to "inlet" result
    inlet(1,i) = avgGrnInlet;
    inlet(2,i) = avgRedInlet;
    if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        % Append avg outlet intensities to "outlet" result
        outlet(1,i) = avgGrnOutlet;
        outlet(2,i) = avgRedOutlet;
        % Append avg background to "bkgrnd" result
        bkgrnd(1,i) = sum(sum(mygreendata.*BWD))/npixelsD;
        bkgrnd(2,i) = sum(sum(myreddata.*BWD))/npixelsD;
        
        %kymograph - for now the center ROI must be a horizontal rectangle
        kymo_temp(1,i,:) = (sum(mygreendata.*BWB)/npixelsB)'; % size of the whole image
        kymo_temp(2,i,:) = (sum(myreddata.*BWB)/npixelsB)'; % size of the whole image
    end
        
end

if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
kymo = kymo_temp(:,:,int16(ROIs.xB2(1)):int16(ROIs.xB2(3))); 
% resize to be only the size of the rectangle over which we averaged

output = {inlet; outlet; kymo; bkgrnd };

else
    output = {inlet};
end

end

