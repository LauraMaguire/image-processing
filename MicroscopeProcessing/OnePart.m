% NIKON TWO-PART VIDEO PROCESSOR
% LKM 8/24/15

% This script is a modified version of Loren's and Grant's processing
% script.  It processes a Nikon video with two segments that have different
% timing intervals (the equivalent of double-video processing on the
% Olympus).

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

% Full file path of the video:
filename = 'Z:\Microscopy\160819\160819_ch1_D.vsi';

% filepath to save folder
folder = 'Z:\Processed Images\August 2016 Experiments\';

%name to save figures as
name = '160825-FSFG-15';

% seconds per frame:
tscale = 30;
%tscale1 = 3.8;

%number of frames:
frames1 = 240;

% Microns per pixel:
%xscale = 3.23/2; %for Nikon, 4x, 2x2 binning
xscale = 1.58; %for 4x Olympus
%xscale = 0.645; %for 10x Olympus

% Date of experiment
%date = '08/16/16 NIKON no2';
date = '08/25/16 Olympus, 50um 2x';

% Short description of hydrogel (keep below 20 characters)
gelNotes = 'LW FSFG 10mg/mL #15';

% Notes, line 1 (keep below 20 characters)
note1 = '25 uM NTF2-A488';
%note1 = 'no inlet soln';

% Notes, line 2 (keep below 20 characters)
note2 = '25 uM mCherry';
%note2 = '';


%% background stuff
b = load('Z:\Processed Images\August 2016 Experiments\160819-FSFG-ch2-bkgnd\160819-FSFG-ch2-bkgnd.mat');

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
    
%% Process the video.

% This section creates the 'output' object that contains the data from each
% ROI.
% output{1} = inlet (1st ROI) 
% output{2} = outlet (3rd ROI)
% output{3} = kymographs
% output{4} = not in the channel.

output = AllChannelProcess(mydata, roifilename,2);
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

% Create a two-segmented time axis.
time = (1:frames1)*tscale/60;

% Create a position axis.
pos = (1:size(kymo_red(1,:),2))*xscale;

%% background stuff
background = ones(2,length(time));
background(1,:)=b.gb*ones(1,length(time));
background(2,:)=b.rb*ones(1,length(time));
%% PLOTS BEGIN HERE
% Except in background plot, background is subtracted.
% Outlet and profile plots are continuously normalized to the inlet.

%% Plot of background intensity vs. time:
close all
plot(time, background(1,:),'g-')
hold all
plot(time, background(2,:),'r-')
title(['Background intensity (', gelNotes, ')'])
legend('Green','Red','Location','east')
xlabel('Time (minutes)')
ylabel('Background intensity')
annotation('textbox', [0.4,0.45,0.1,0.1],'String', {date, note1, note2})

saveas(gcf,[folder name '\' name '-bkgrnd.jpg'])

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
plot(time, (inlet(1,:))/(inlet(1,1)),'g-')
hold all
plot(time, (inlet(2,:))/(inlet(2,1)),'r-')
title(['Inlet intensity (', gelNotes, ')'])
legend('Green','Red','Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.2,0.2,0.1,0.1],'String', {date, note1, note2})

saveas(gcf,[folder name '\' name '-inlet.jpg'])

%% Plot of outlet intensity vs. time:
figure
plot(time, outlet(1,:)./inlet(1,:),'g-')
%plot(time, outlet(1,:)/inlet(1,1),'g-')
hold all
plot(time, outlet(2,:)./inlet(2,:),'r-')
%plot(time, outlet(2,:)/inlet(2,1),'r-')
title(['Accumulation in outlet (', gelNotes, ')'])
legend('Green','Red','Location','northwest')
xlabel('Time (minutes)')
ylabel('Intensity continuously normalized to inlet')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.5,0.2,0.1,0.1],'String', {date, note1, note2})

saveas(gcf,[folder name '\' name '-outlet.jpg'])
saveas(gcf,[folder name '\' name '-outlet.fig'])

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
%plot(pos, kymo_green(end,:)/inlet(1,1),'g-')
plot(pos, kymo_red(1,:)/inlet(2,1), 'm-')
plot(pos, kymo_red(end,:)/inlet(2,end), 'r-')
%plot(pos, kymo_red(end,:)/inlet(2,1), 'r-')
title(['Intensity profiles (', gelNotes, ')'])
legend('Green 0 min',grn_lgnd, 'Red 0 min', ...
    red_lgnd,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity continuously normalized to inlet')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.55,0.35,0.1,0.1],'String', {date, note1, note2})

saveas(gcf,[folder name '\' name '-profiles.jpg'])
saveas(gcf,[folder name '\' name '-profiles.fig'])

%% ONLY RUN IF NECESSARY - flip profiles horizontally

% We want the inlet to be on the left-hand side of the plots.  Run this
% section if necessary.

kymo_green = fliplr(kymo_green);
kymo_red = fliplr(kymo_red);

%% Clean up workspace (run this before saving workspace)
close all
clear ans file_size mydata roi3 roifilename time1 time2 b
clear final_time grn_lgnd red_lgnd frames i RedImages finalRed

save([folder name '\' name '.mat']);
