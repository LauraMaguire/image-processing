% NIKON FOUR-CHANNEL VIDEO PROCESSOR
% LKM 3/28/16

% This script is a modified version of Loren's and Grant's processing
% script.  It processes a Nikon video with only one timing interval
% throughout.  It is designed for a video with four color channels, but
% can be adapted to other channel numbers with minor modifications.

% It is designed for small-outlet chambers, but can be used for X-chambers
% as well.  For X-chambers, do not run the section that rotates the video
% by 90 degrees.

% Last modified: 03/28/16 by LKM

% Inputs:
%   (1) Full file path
%   (2) Time per frame
%   (3) Length scale
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

% There are two sections that can optionally be run, and should not be in
% some cases.  The second processing section rotates the video by 90
% degrees and should only be used if the small-outlet chamber was used, not
% the X-chamber.  There is also a section after the profile plots that 
% horizontally flips all profiles. We always want the inlet on the left, so
% run this section if that is not true at first.

%% USER INPUTS

% Full file path of the video:
filename = 'Z:\Microscopy\160609\160315_no1_FG124_outletfilled_ThT.nd2';

% Seconds per frame:
tscale = 300; % Five minute intervals

% Number of color channels:
channels = 4;

% Microns per pixel:
xscale = 3.23; %for Nikon, 4x

% Date of experiment
date = '03/15/16 NIKON';

% Short description of hydrogel (keep below 20 characters)
gelNotes = '10 mg/mL FG124, 10% PEG, Th T';

% Notes, line 1 (keep below 20 characters)
note1 = '25uM eGFP-NTF2x2';

% Notes, line 2 (keep below 20 characters)
note2 = '25uM mCherry';

%% PROCESSING BEGINS HERE

%% Import the video.

data = bfopen(filename);
file_size = size(data{1,1},1);
frames = file_size/channels;
display(['Video has been imported. It has ', num2str(frames), ' frames.'])

%% Rotate the outlet video if necessary
%  Only run this section if the small-outlet chamber was used!

for i=1:size(data{1,1},1)
    data{1,1}{i,1} = rot90(data{1,1}{i,1});
end
clear i
display('Video rotated by 90 degrees.');

%% Use the video to define ROIs.
close all
roifilename = strcat(filename(1:end-4),'_rois.mat');
MakeROIs(data, roifilename)
    
%% Process the video.

% This section creates the 'output' object that contains the data from each
% ROI.
% output{1} = inlet (1st ROI) 
% output{2} = outlet (3rd ROI)
% output{3} = kymographs
% output{4} = not in the channel.

output = AllChannelProcess(data, roifilename, channels);
display('Finished processing video.')

%% Rename output cells.
inlet = output{1};
outlet = output{2};
roi3 = output{3};
background = output{4};

% Reshape the third ROI output into concentration profiles.
kymo_green = reshape(roi3(1,:,:),[size(roi3(1,:,:),2) size(roi3(1,:,:),3)]);
kymo_red = reshape(roi3(2,:,:),[size(roi3(2,:,:),2) size(roi3(2,:,:),3)]);
kymo_cyan = reshape(roi3(3,:,:),[size(roi3(3,:,:),2) size(roi3(3,:,:),3)]);
kymo_yellow = reshape(roi3(4,:,:),[size(roi3(4,:,:),2) size(roi3(4,:,:),3)]);

% Remove the initial and final positions from the profiles (clean up):
kymo_green = kymo_green(:,(2:end-1));
kymo_red = kymo_red(:,(2:end-1));
kymo_cyan = kymo_cyan(:,(2:end-1));
kymo_yellow = kymo_yellow(:,(2:end-1));

%% Create scaled time and position axes.

% Create a time axis.
time = (1:frames)*tscale/60;

% Create a position axis.
pos = (1:size(kymo_green(1,:),2))*xscale;

%% PLOTS BEGIN HERE
% Except in background plot, background is subtracted.
% Outlet and profile plots are continuously normalized to the inlet.

%% Plot of background intensity vs. time:
close all
plot(time, background(1,:),'g-')
hold all
plot(time, background(2,:),'r-')
plot(time, background(3,:),'c-')
plot(time, background(4,:),'y-')
title(['Background intensity (', gelNotes, ')'])
legend('Green', 'Red', 'Cyan', 'Yellow', 'Location', 'northeast')
xlabel('Time (minutes)')
ylabel('Background intensity')
annotation('textbox', [0.6,0.2,0.1,0.1],'String', {date, note1, note2,...
    'with thioflavin T'})

%% Run this section to subtract the background from all other traces.  Only run once!
for j = 1:channels
    inlet(j,:) = inlet(j,:) - background(j,:);
    outlet(j,:) = outlet(j,:) - background(j,:);
end
clear j

for i=1:size(pos)
kymo_green(:,i) = kymo_green(:,i) - background(1,:).';
kymo_red(:,i) = kymo_red(:,i) - background(2,:).';
end
clear i

display('Background has been subtracted.');

%% Plot of inlet intensity vs. time:
close all
figure
plot(time, (inlet(1,:))/(inlet(1,1)),'g-')
hold all
plot(time, (inlet(2,:))/(inlet(2,1)),'r-')
plot(time, (inlet(3,:))/(inlet(3,1)),'c-')
plot(time, (inlet(4,:))/(inlet(4,1)),'y-')
title(['Inlet intensity (', gelNotes, ')'])
legend('Green', 'Red', 'Cyan', 'Yellow', 'Location', 'northeast')
xlabel('Time (minutes)')
ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.6,0.2,0.1,0.1],'String', {date, note1, note2,...
    'with thioflavin T'})

%% Plot of outlet intensity vs. time:
figure
plot(time, outlet(1,:)./inlet(1,:),'g-')
hold all
plot(time, outlet(2,:)./inlet(2,:),'r-')
plot(time, outlet(3,:)./inlet(3,:),'c-')
plot(time, outlet(4,:)./inlet(4,:),'y-')
title(['Accumulation in outlet (', gelNotes, ')'])
legend('Green', 'Red', 'Cyan', 'Yellow', 'Location', 'northeast')
xlabel('Time (minutes)')
ylabel('Intensity continuously normalized to inlet')
annotation('textbox', [0.6,0.2,0.1,0.1],'String', {date, note1, note2,...
    'with thioflavin T'})

%% Intensity profiles (kymographs):
% Plot of intensity vs position at several times
close all
final_time = int16(time(end));
grn_lgnd = ['Green ', num2str(final_time), ' min'];
red_lgnd = ['Red ', num2str(final_time), ' min'];
figure
plot(pos, kymo_green(1,:)/inlet(1,1),'c-')
hold all
plot(pos, kymo_green(end,:)/inlet(1,end),'g-')
plot(pos, kymo_red(1,:)/inlet(2,1), 'm-')
plot(pos, kymo_red(end,:)/inlet(2,end), 'r-')
title(['Intensity profiles (', gelNotes, ')'])
legend('Green 0 min',grn_lgnd, 'Red 0 min', ...
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
kymo_cyan = fliplr(kymo_cyan);
kymo_yellow = fliplr(kymo_yellow);

%% Clean up workspace (run this before saving workspace)
close all
clear ans file_size data roi3 final_time grn_lgnd red_lgnd i j
