% NIKON THREE-PART VIDEO PROCESSOR
% Updated 10/13/15 by LKM
% TESTING GIT

% This script is a modified version of Loren's and Grant's processing
% script.  It processes a Nikon video with three segments that have 
% different timing intervals.

% It is designed for small-outlet chambers, but can be used for X-chambers
% as well.  For X-chambers, do not run the section that rotates the video
% by 90 degrees.

% Last modified: 01/04/2016 by LKM

% Inputs:
%   (1) Full file path
%   (2) Each segment: Time per frame and number of frames
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

% Run each section of code separately by pressing 'ctrl+enter'. After 
% running, check plots and change the position of legend and text box if 
% necessary.

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

% Full file path of the video:
filename = 'Z:\Microscopy\160305\Nikon\1600305_no2_FG124_outletFilled.nd2';

% Segment 1 seconds per frame:
tscale1 = 120;

% Segment 2 seconds per frame:
tscale2 = 120;

% Segment 3 seconds per frame:
tscale3 = 120;

% Segment 1 number of frames:
frames1 = 1399;

% Segment 2 number of frames:
frames2 = 0;

% Segment 3 number of frames:
frames3 = 0;

% Microns per pixel:
xscale = 3.23; %for Nikon, 4x

% Date of experiment
date = '03/05/16 NIKON';

% Short description of hydrogel (keep below 20 characters)
gelNotes = '2 mg/mL FG124, 10% PEG, outlet-filled';

% Notes, line 1 (keep below 20 characters)
note1 = '25uM NTF2-A488';

% Notes, line 2 (keep below 20 characters)
note2 = '25uM mCherry';

%% PROCESSING BEGINS HERE

%% Import the video.

mydata = bfopen(filename);
file_size = size(mydata{1,1},1);
frames = file_size/2; %divide by the number of color channels (2)
display(['Video has been imported. It has ', num2str(frames), ' frames.'])

%% Rotate the outlet video if necessary
%  Only run this section if the small-outlet chamber was used!

for i=1:size(mydata{1,1},1)
    mydata{1,1}{i,1} = rot90(mydata{1,1}{i,1});
end
clear i
display('Video rotated by 90 degrees.');

%% Use the video to define ROIs.
close all
roifilename = strcat(filename(1:end-4),'_rois.mat');
MakeROIs(mydata, roifilename)

%% Check the inlet ROI
% This section displays the final red image overlaid with the inlet ROI.
% The inlet should be bright white, possibly slightly magenta.
% The scale value can be changed (smaller values make the image brighter),
% or the inletThreshold value can be changed if the inlet ROI doesn't
% overlay properly with the actual inlet.
global scale inletThreshold
scale = 0.05;
inletThreshold = 0.6;

RedImages = mydata{1,1}(2:2:length(mydata{1,1}));
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

output = BFprocess(mydata, roifilename,file_size);
display('Finished processing video.')

%% Rename output cells.
inlet = output{1};
outlet = output{2};
roi3 = output{3};
background = output{4};

% Reshape the third ROI output into concentration profiles.
kymo_green = reshape(roi3(1,:,:),[size(roi3(1,:,:),2) size(roi3(1,:,:),3)]);
kymo_red = reshape(roi3(2,:,:),[size(roi3(2,:,:),2) size(roi3(2,:,:),3)]);

% Remove the initial and final positions from the profiles (clean up):
kymo_green = kymo_green(:,(2:end-1));
kymo_red = kymo_red(:,(2:end-1));

%% Create scaled time and position axes.

% Create a three-segmented time axis.
time1 = (1:frames1)*tscale1/60;
time2 = time1(end)-tscale2/60+(1:frames2)*tscale2/60;
time3 = time2(end)-tscale3/60+(1:frames3)*tscale3/60;
time = [time1 time2 time3];

% Create a position axis.
pos = (1:size(kymo_red(1,:),2))*xscale;

%% PLOTS BEGIN HERE
% Except in background plot, background is subtracted.
% Outlet and profile plots are continuously normalized to the inlet.

%% Plot of background intensity vs. time:
close all
plot(time, background(1,:),'g-')
hold all
plot(time, background(2,:),'r-')
title(['Background intensity (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','southeast')
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
annotation('textbox', [0.6,0.3,0.1,0.1],'String', {date, note1, note2})

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
annotation('textbox', [0.15,0.7,0.1,0.1],'String', {date, note1, note2})

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
% section if necessary, then re-plot the profiles.

kymo_green = fliplr(kymo_green);
kymo_red = fliplr(kymo_red);

%% Clean up workspace
close all
clear ans file_size mydata roi3 roifilename time1 time2 time3
clear final_time grn_lgnd red_lgnd frames i RedImages finalRed
