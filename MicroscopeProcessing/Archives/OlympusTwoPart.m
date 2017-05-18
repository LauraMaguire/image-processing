% TWO-VIDEO PROCESSOR AND STITCHER
% LKM 6/23/15

% This script is a modified version of Loren's and Grant's processing
% script.  It processes two back-to-back videos and stitches the results
% together.

% It is designed for small-outlet chambers, but can be used for X-chambers
% as well.  For X-chambers, do not run the section that rotates the video
% by 90 degrees.

% Last modified: 01/04/2016 by LKM

% Inputs:
%   (1) Full file path for each video
%   (2) Time per frame for each video
%   (3) Length scale of both videos
%   (4) Date of experiment
%   (5) Short gel description
%   (6) Any other experiment notes

% To define ROIs: Click the image to define vertices of a polygon.
% Double-click the original vertex to complete the ROI.  The script
% requires four ROIs.  The order in which they are defined is important.
%   (1) Inlet
%   (2) Kymograph (concentration profile) region.  This ROI must be a
%   quadrilateral, and only the first and third points matter.  The script
%   reshapes this area into a rectangle using those two points as opposite
%   corners.
%   (3) Outlet
%   (4) Background region (outside of the channel)
%
% When all four ROIs have been defined, press 'enter' to accept them.

% Run each section of code separately by pressing 'ctrl+enter'. Script can
% be run straight through as well.  After running, check plots and change
% position of legend and text box if necessary.

% There are three sections that can optionally be run, and should not be in
% some cases.  The second processing section rotates the video by 90
% degrees and should only be used if the small-outlet chamber was used, not
% the X-chamber.  Next, the section after the background plot will subtract
% the background from all other traces, at each times point.  Only run this
% if the background plot looks reasonable. Finally, there is a section
% after the profile plots that horizontally flips all profiles. We always
% want the inlet on the left, so run this section if that is not true at
% first.

%% USER INPUTS

% Full file path of the first video in sequence:
filename1 = 'Z:\Microscopy\160108\FSFG10_NTF2_mCherry_10PEG_bargel\FSFG10_NTF2_mCherry_10PEG01.vsi';
% Full file path of the second video:
filename2 = 'Z:\Microscopy\160108\FSFG10_NTF2_mCherry_10PEG_bargel\FSFG10_NTF2_mCherry_10PEG03.vsi';

% Seconds per frame for the first video:
tscale1 = 5;
%tscale1 = 3.8;

% Seconds per frame for the second video:
tscale2 = 60; % This is for 1 min/frame.

% Microns per pixel (assumed to be same for both videos):
xscale = 1.58; % Olympus 4x

% Date of experiment
date = '01/29/16';

% Short description of hydrogel (keep below 20 characters)
gelNotes = '10 mg/mL FSFG 6mer, 1kD linker, presoaked 100 uM NTF2';

% Notes, line 1 (keep below 20 characters)
note1 = '25 um NTF2-A488 + 75 uM NTF2';

% Notes, line 2 (keep below 20 characters)
note2 = '25 uM mCherry';

%% PROCESSING BEGINS HERE

%% Import the first video.

mydata1 = bfopen(filename1);
file_size1 = size(mydata1{1,1},1);
frames1 = file_size1/2; %divide by the number of color channels (2)
display(['First video has been imported. It has ', num2str(frames1), ' frames.'])

%% Import the second video.

mydata2 = bfopen(filename2);
file_size2 = size(mydata2{1,1},1);
frames2 = file_size2/2; %divide by the number of color channels (2)
display(['Second video has been imported. It has ', num2str(frames2), ' frames.'])

%% Rotate the outlet videos if necessary
%  Only run this section if the small-outlet chamber was used!

for i=1:size(mydata1{1,1},1)
    mydata1{1,1}{i,1} = rot90(mydata1{1,1}{i,1});
end
clear i
for i=1:size(mydata2{1,1},1)
    mydata2{1,1}{i,1} = rot90(mydata2{1,1}{i,1});
end
clear i
display('Videos rotated by 90 degrees.');


%% Use the final video to define ROIs.
close all
roifilename = strcat(filename1(1:end-4),'_rois.mat');
MakeROIs(mydata2, roifilename)

%% Check the inlet ROI
% This section displays the final red image overlaid with the inlet ROI.
% The inlet should be bright white, possibly slightly magenta.
% The scale value can be changed (smaller values make the image brighter),
% or the inletThreshold value can be changed if the inlet ROI doesn't
% overlay properly with the actual inlet.
global scale inletThreshold
scale = 0.05;
inletThreshold = 0.6;

RedImages = mydata2{1,1}(2:2:length(mydata2{1,1}));
finalRed = im2double(RedImages{1,end});
finalRed = imadjust(finalRed,[0; scale], [0; 1] );

close all
imshowpair(finalRed,imextendedmax(finalRed,inletThreshold),'falsecolor');
    
%% Process the video.

% This section creates the 'output' object that contains the data from each
% ROI.
% output{1} = inlet (1st ROI) 
% output{2} = outlet (3rd ROI)
% output{3} = kymographs
% output{4} = not in the channel.

output1 = autoProcess(mydata1, roifilename);
display('Finished processing first video.')

output2 = autoProcess(mydata2, roifilename);
display('Finished processing second video.')

%% Concatenate output cells. (Stitch together videos.)
inlet = [output1{1} output2{1}];
outlet = [output1{2} output2{2}];
roi3 = [output1{3} output2{3}];
background = [output1{4} output2{4}];

% Reshape the third ROI output into concentration profiles.
kymo_green = reshape(roi3(1,:,:),[size(roi3(1,:,:),2) size(roi3(1,:,:),3)]);
kymo_red = reshape(roi3(2,:,:),[size(roi3(2,:,:),2) size(roi3(2,:,:),3)]);

% Remove the initial and final positions from the profiles (clean up):
kymo_green = kymo_green(:,(2:end-1));
kymo_red = kymo_red(:,(2:end-1));

%% Create scaled time and position axes.

% Create a time axis for each video; concatenate into one.
time1 =(1:size(output1{1}(1,:),2))*tscale1/60;
time2 =time1(end)-tscale2/60+(1:size(output2{1}(1,:),2))*tscale2/60;
time = [time1 time2];

% Create a position axis.
pos = (1:size(kymo_red(1,:),2))*xscale;

%% PLOTS BEGIN HERE
% Except in background plot, all intensities are normalized to the inital
% intensity of the inlet, and background is subtracted.

%% Plot of background intensity vs. time:
close all
plot(time, background(1,:),'g-')
hold all
plot(time, background(2,:),'r-')
title(['Background intensity (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','northeast')
xlabel('Time (minutes)')
ylabel('Background intensity')
annotation('textbox', [0.5,0.5,0.1,0.1],'String', {date, note1, note2})

%% If background intensity looks typical, run this to subtract it from
%  the other traces. Only run this section once!

inlet(1,:) = inlet(1,:) - background(1,:);
inlet(2,:) = inlet(2,:) - background(2,:);

outlet(1,:) = outlet(1,:) - background(1,:);
outlet(2,:) = outlet(2,:) - background(2,:);

for i=1:size(kymo_green,2)
kymo_green(:,i) = kymo_green(:,i) - background(1,:).';
kymo_red(:,i) = kymo_red(:,i) - background(2,:).';
end
clear i

display('Background has been subtracted.');

%% Plot of inlet intensity vs. time:
close all
figure
plot(time, inlet(1,:)/inlet(1,1),'g-')
hold all
plot(time, inlet(2,:)/inlet(2,1),'r-')
title(['Inlet intensity (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','northwest')
xlabel('Time (minutes)')
ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.2,0.6,0.1,0.1],'String', {date, note1, note2})

%% Plot of outlet intensity vs. time:
figure
plot(time, outlet(1,:)./inlet(1,:),'g-')
%plot(time, outlet(1,:)/inlet(1,1),'g-')
hold all
plot(time, outlet(2,:)./inlet(2,:),'r-')
%plot(time, outlet(2,:)/inlet(2,1),'r-')
title(['Accumulation in outlet (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','southeast')
xlabel('Time (minutes)')
ylabel('Intensity continuously normalized to inlet')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.2,0.5,0.1,0.1],'String', {date, note1, note2})

%% Intensity profiles (kymographs):
% Plot of intensity vs position at several times
close all
final_time = int16(time(end));
grn_lgnd = ['Alexa488 ', num2str(final_time), ' min'];
red_lgnd = ['mCherry ', num2str(final_time), ' min'];
figure
plot(pos, kymo_green(1,:)/inlet(1,1),'c-')
hold all
plot(pos, kymo_green(end,:)/inlet(1,end),'g-')
%plot(pos, kymo_green(end,:)/inlet(1,1),'g-')
plot(pos, kymo_red(1,:)/inlet(2,1), 'm-')
plot(pos, kymo_red(end,:)/inlet(2,end), 'r-')
%plot(pos, kymo_red(end,:)/inlet(2,1), 'r-')
title(['Intensity profiles (', gelNotes, ')'])
legend('Alexa488 0 min',grn_lgnd, 'mCherry 0 min', ...
    red_lgnd,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity continuously normalized to inlet')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.5,0.6,0.1,0.1],'String', {date, note1, note2})

%% ONLY RUN IF NECESSARY - flip profiles horizontally

% We want the inlet to be on the left-hand side of the plots.  Run this
% section if necessary.

kymo_green = fliplr(kymo_green);
kymo_red = fliplr(kymo_red);

%% Clean up workspace (run this before saving workspace)
close all
clear ans file_size1 file_size2 mydata1 mydata2 roi3 finalRed
clear final_time grn_lgnd red_lgnd roifilename time1 time2 RedImages
