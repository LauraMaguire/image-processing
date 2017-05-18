function [ output ] = BFprocess( alldata, roisfilename, file_size, series)
% BFprocess uses the previously-defined ROIs to calculate the average
% intensity of the inlet, outlet, and background, and to create a
% kymograph.

% Modified 10/13/15 by LKM.
% Originally modified from a script made by Loren and Grant.

channels = 2;

% If user has not specified a series number, use the first series.
if nargin < 4
    series =1;
end

% Load the previously-defined coordinates of the four ROIs.
ROIs = load(roisfilename);

% Pre-allocate vectors that will be filled later.
lhr = zeros(2,file_size/2);
rhr = zeros(2,file_size/2);
bkgrnd = zeros(2,file_size/2);

%ASSUMES NUMBER OF CHANNELS IS 2!!!!!!

    for i = 1:file_size/channels
        mygreendata = im2double(alldata{series,1}{2*i-1,1});
        myreddata = im2double(alldata{series,1}{2*i,1});
        BWA = roipoly(ROIs.xA1, ROIs.yA1, mygreendata, ROIs.xA2, ROIs.yA2);
        if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        BWB = roipoly(ROIs.xB1, ROIs.yB1, mygreendata, ROIs.xB2, ROIs.yB2);
        BWC = roipoly(ROIs.xC1, ROIs.yC1, mygreendata, ROIs.xC2, ROIs.yC2);
        BWD = roipoly(ROIs.xD1, ROIs.yD1, mygreendata, ROIs.xD2, ROIs.yD2);
        end
        
        npixelsA = sum(sum(BWA));
        if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        npixelsB = max(sum(BWB));
        npixelsC = sum(sum(BWC));
        npixelsD = sum(sum(BWD));
        end
        
        lhr(1,i) = sum(sum(mygreendata.*BWA))/npixelsA;
        lhr(2,i) = sum(sum(myreddata.*BWA))/npixelsA;
        if not(strcmp(roisfilename(end-8:end-3),'-bulk.'))
        rhr(1,i) = sum(sum(mygreendata.*BWC))/npixelsC;
        rhr(2,i) = sum(sum(myreddata.*BWC))/npixelsC;
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

output = {lhr; rhr; kymo; bkgrnd };

else
    output = {lhr};
end

end

