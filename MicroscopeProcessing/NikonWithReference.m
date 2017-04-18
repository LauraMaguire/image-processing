% NIKON TRIPLE VIDEO PROCESSOR WITH REFERENCE SERIES
% Updated 10/22/15 by LKM

% This script processes a Nikon video with THREE segments that have 
% different timing intervals.  It's intended for small-outlet chambers with
% two time-series: one showing the gel and outlet, and one showing a
% reference intensity (bulk of inlet or microspheres).  The gel series
% should be series 1, and the reference series 2.

% Inputs:
%   (1) Full file path
%   (2) Each segment: Time per frame and number of frames
%   (3) Length scale
%   (4) Date of experiment
%   (5) Short gel description
%   (6) Any other experiment notes

% To define ROIs: Click the image to define vertices of a polygon.
% Double-click the original vertex to complete the ROI.  The script
% requires four ROIs for the gel series and one for the reference series.
% For the gel series, the order in which they are defined is important.
%   (1) Inlet
%   (2) Kymograph (concentration profile) region.  This ROI must be a
%   quadrilateral, and only the first and third points matter.  The script
%   reshapes this area into a rectangle using those two points as opposite
%   corners.
%   (3) Outlet
%   (4) Background region (outside of the channel)
%
% When all ROIs have been defined, press 'enter' to accept them.

% Run each section of code separately by pressing 'ctrl+enter'. After 
% running, check plots and change the position of legend and text box if 
% necessary.

% There are two sections that can optionally be run, and should not be in
% some cases.  The second processing section rotates the video by 90
% degrees and should only be used if the small-outlet chamber was used, not
% the X-chamber.  Next, the section after the background plot will subtract
% the background from all other traces, at each times point.  Only run this
% if the background plot looks reasonable.

%% USER INPUTS

% Full file path of the video:
filename = 'Z:\Microscopy\151021\30mgmL_FSFG\FSFG_30mgmL_NTF2-A488_mCherry_10PEG.nd2';

% Segment 1 seconds per frame:
tscale1 = 5;

% Segment 2 seconds per frame:
tscale2 = 60;

% Segment 3 seconds per frame:
tscale3 = 600;

% Segment 1 number of frames:
frames1 = 100;

% Segment 2 number of frames:
frames2 = 120;

% Segment 3 number of frames:
frames3 = 100;

% Microns per pixel:
xscale = 3.23; %Nikon, 4x

% Date of experiment
date = '10/22/15 NIKON';

% Short description of hydrogel (keep below 20 characters)
gelNotes = '30 mg/mL FSFG, 10% wt PEG';

% Notes, line 1 (keep below 20 characters)
note1 = '25uM NTF2-A488';

% Notes, line 2 (keep below 20 characters)
note2 = '25uM mCherry';

%% PROCESSING BEGINS HERE

%% Import the video.

mydata = bfopen(filename);
file_size = size(mydata{1,1},1);
frames = file_size/2; % This assumes there are two color channels.
display(['Video has been imported. It has ', num2str(frames), ' frames.'])

%% Display frames from each series for reference.

% Adjust the scale value if image is difficult to see. A smaller
% scale value means the images will be brighter.  Change only the second
% number in the scale object, i.e. scale = [0; <change this>].

scale = [0; 0.01];

image = im2double(mydata{1,1}{1,1});
image = imadjust(image,scale, [0; 1] );
subplot(2,1,1)
imshow(image);
title('Series 1: Gel and outlet');

image = im2double(mydata{2,1}{1,1});
image = imadjust(image,scale, [0; 1] );
subplot(2,1,2)
imshow(image);
title('Series 2: Reference');

%% Rotate the outlet video if necessary
%  Only run this section if the small-outlet chamber was used!
%  Only run this section once, or the video will be rotated too far.

for i=1:size(mydata{1,1},1)
    mydata{1,1}{i,1} = rot90(mydata{1,1}{i,1});
end
clear i
display('Series 1 rotated by 90 degrees.');

%% Define ROIs for the gel-outlet series (4 ROIs).
close all
rois1 = strcat(filename(1:end-4),'_rois-gel.mat');
MakeROIs(mydata, rois1, 1)

%% Define ROI for the reference series (1 ROI).
close all
rois2 = strcat(filename(1:end-4),'_rois-bulk.mat');
MakeROIs(mydata, rois2, 2)

%% Process the first series.

% This section creates the 'output' object that contains the data from each
% ROI.
% output{1} = inlet (1st ROI) 
% output{2} = outlet (3rd ROI)
% output{3} = kymographs
% output{4} = not in the channel.

output = BFprocess(mydata, rois1, file_size, 1);
display('Finished processing series 1.')

%% Process the second series
ref = BFprocess(mydata, rois2, file_size, 2);
ref = ref{1,1};
display('Finished processing series 2.')

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
% Outlet and profile plots are continuously normalized to the bulk inlet.

%% Plot of background intensity vs. time:
close all
plot(time, background(1,:),'g-')
hold all
plot(time, background(2,:),'r-')
title(['Background intensity (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','southeast')
xlabel('Time (minutes)')
ylabel('Background intensity')
annotation('textbox', [0.6,0.5,0.1,0.1],'String', {date, note1, note2})

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

ref(1,:) = ref(1,:) - background(1,:);
ref(2,:) = ref(2,:) - background(2,:);

display('Background has been subtracted.');

%% Compare inlet-edge and reference intensities over time

% This plot shows both channels over time for the edge of the inlet (taken
% from the gel series) and the reference series.  The traces are normalized
% to the initial value of the reference series.

close all
plot(time, ref(1,:)/ref(1,1),'g-')
hold all
plot(time, inlet(1,:)/ref(1,1),'g--')
plot(time, ref(2,:)/ref(2,1),'r-')
plot(time, inlet(2,:)/ref(2,1),'r--')
title(['Reference and gel-edge intensities (', gelNotes, ')'])
legend('Green ref','Green edge','Red ref','Red edge','Location','west')
xlabel('Time (minutes)')
ylabel('Intensity (normalized to initial reference)')
annotation('textbox', [0.6,0.5,0.1,0.1],'String', {date, note1, note2})

%% Plot of outlet intensity vs. time:
figure
plot(time, outlet(1,:)./ref(1,:),'g-')
hold all
plot(time, outlet(2,:)./ref(2,:),'r-')
title(['Accumulation in outlet (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','southeast')
xlabel('Time (minutes)')
ylabel('Intensity continuously normalized to reference')
annotation('textbox', [0.2,0.6,0.1,0.1],'String', {date, note1, note2})

%% Intensity profiles (kymographs):
% Plot of intensity vs position at several times
close all
final_time = int16(time(end));
grn_lgnd = ['Alexa488 ', num2str(final_time), ' min'];
red_lgnd = ['mCherry ', num2str(final_time), ' min'];
figure
plot(pos, kymo_green(1,:)/ref(1,1),'c-')
hold all
plot(pos, kymo_green(end,:)/ref(1,end),'g-')
%plot(pos, kymo_green(end,:)/inlet(1,1),'g-')
plot(pos, kymo_red(1,:)/ref(2,1), 'm-')
plot(pos, kymo_red(end,:)/ref(2,end), 'r-')
%plot(pos, kymo_red(end,:)/inlet(2,1), 'r-')
title(['Intensity profiles (', gelNotes, ')'])
legend('Alexa488 0 min',grn_lgnd, 'mCherry 0 min', ...
    red_lgnd,'Location','southeast')
xlabel('Position (microns)')
ylabel('Intensity continuously normalized to reference')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.2,0.6,0.1,0.1],'String', {date, note1, note2})

%% Clean up workspace
close all
clear ans file_size filename mydata roi3 rois1 rois2 time1 time2 time3
clear final_time grn_lgnd red_lgnd frames i image

