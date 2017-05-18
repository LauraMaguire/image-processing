function [ output ] = AllChannelProcess( data, roisfilename, channels)
% AllChannelProcess uses a previously-defined ROI definition file to
% calculate average values of background, inlet and outlet for each frame
% of video, as well as concentration profiles.

% This script works for an arbitrary number of color channels, but cannot
% handle an extra "bulk inlet" or reference series.

% Modified 3/28/16 by LKM.
% Originally modified from a script made by Loren and Grant.

% Inputs:
%   1) "data" is the data object originally imported using bfopen.
%   2) "roisfilename" is the complete file path of the ROI definition file.
%   3) "channels" specifies the number of color channels in the video.

% Output: An "output" object consisting of 4 cells.
%   The average inlet intensity is the first cell, average outlet intensity
%   second, concentration profiles third (requiring reshaping), and average
%   background fourth.  Each cell is an array with the first index showing
%   the channel number and the second index the frame number.

% SCRIPT BEGINS HERE

% Load the previously-defined coordinates of the four ROIs.
ROIs = load(roisfilename);

% Calculate the file size from the imported data.
file_size = size(data{1,1},1);

% Calculate the number of frames in the video using file size and number of
% channels.
frames = file_size/channels;

% Make a list of all images from the data.  This list is sorted by frame
% and then color, and will need to be re-sorted to make one list of images
% for each color channel.
unsortedImages = data{1,1};

% Pre-allocate arrays that will be filled later.
images = cell(channels, frames);
inlet = zeros(channels,frames);
outlet = zeros(channels,frames);
bkgrnd = zeros(channels,frames);

% Re-sort the images list so that the first index is the channel number and
% the second is the frame number.  Populates the pre-allocated cell array
% "images".
for n = 1:channels
    tempImages = unsortedImages(n:channels:length(unsortedImages));
    for k=1:frames
        images{n,k} = tempImages{1,k};
    end
end
clear n k

% Loop over frames and channels, creating masks from the ROI file and
% filling in the pre-allocated inlet, outlet, and background arrays.
for i = 1:frames
    for j = 1:channels
        % Create masks for each image and ROI.
        BWA = roipoly(ROIs.xA1, ROIs.yA1, images{j,i}, ROIs.xA2, ROIs.yA2);
        BWB = roipoly(ROIs.xB1, ROIs.yB1, images{j,i}, ROIs.xB2, ROIs.yB2);
        BWC = roipoly(ROIs.xC1, ROIs.yC1, images{j,i}, ROIs.xC2, ROIs.yC2);
        BWD = roipoly(ROIs.xD1, ROIs.yD1, images{j,i}, ROIs.xD2, ROIs.yD2);
        
        % Calculate total pixels in each ROI.
        npixelsA = sum(sum(BWA));
        npixelsB = max(sum(BWB));
        npixelsC = sum(sum(BWC));
        npixelsD = sum(sum(BWD));
       
        % Fill in output arrays with average values for each ROI.
        inlet(j,i) = sum(sum(im2double(images{j,i}).*BWA))/npixelsA;
        outlet(j,i) = sum(sum(im2double(images{j,i}).*BWC))/npixelsC;
        bkgrnd(j,i) = sum(sum(im2double(images{j,i}).*BWD))/npixelsD;
        kymo_temp(j,i,:) = (sum(im2double(images{j,i}).*BWB)/npixelsB)'; %#ok<AGROW>
    end
end
clear j i

% Resize profiles to the size of the second ROI.
kymo = kymo_temp(:,:,int16(ROIs.xB2(1)):int16(ROIs.xB2(3)));

% Create output object.
output = {inlet; outlet; kymo; bkgrnd };

end

