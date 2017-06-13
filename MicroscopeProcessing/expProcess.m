function [ data, plots] = expProcess(path)
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


%% USER INPUTS

addpath('./src');
%path = 'Z:\Processed Images\2017-05\2017-05-16_50-50mix_linker_250kD_70kD\2017-5-16_2.mat';
load(path, 'info');


%% Adjust file paths based on PC/Mac difference.

if ispc % If this computer is a PC
    slash = '\'; % use backslashes along path
    expFolder = info.expFolderPC; % set base path to experiment
    baseSavePath = info.baseSavePathPC; % set base save path
else % If this computer is a Mac
    slash = '/'; % use forward slashes along path
    expFolder = info.expFolderMac; % set base path to experiment
    baseSavePath = info.baseSavePathMac; % set base save path
end
%% Import the video.

disp('Importing experiment...');
data = bfopen([expFolder slash info.expName]); % load experiment
info.frames = size(data{1,1},1)/info.nChannels; % verify number of frames
display(['Experiment has been imported. It has ', num2str(info.frames), ' frames.'])

%% Define ROIs.
roifilename = expROIs([info.expFolder '\' info.expName],data);

%% Process ROIs.

% This section creates the 'output' object that contains the data from each
% ROI.
% output{1} = inlet (1st ROI) 
% output{2} = outlet (3rd ROI)
% output{3} = kymographs
% output{4} = not in the channel.

output = BFProcess(data, roifilename, info.nChannels*info.frames);
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

% Create a time axis (in minutes)
info.timeAx =(1:size(output{1}(1,:),2))*info.tscale/60;

% Create a position axis.
info.posAx = (1:size(kymo_red(1,:),2))*info.xscale;

%%
greenConc = info.greenConc;
redConc = info.redConc;
greenName = info.greenName;
redName = info.redName;
conc = info.conc;
protein = info.protein;
geo = info.geo;
linker = info.linker;

%% Define text strings for legends and annotations.
grnleg = [num2str(greenConc) ' uM ' greenName];
redleg = [num2str(redConc) ' uM ' redName];
textnote = [num2str(conc) ' uM ' protein ' ' geo '. Linker: ' linker];

%% Plot of reservoir intensity vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(time, inlet(1,:)/inlet(1,1),'g-','LineWidth',3)
hold all
plot(time, inlet(2,:)/inlet(2,1),'r-','LineWidth',3)
title(['Reservoir intensity (' info.date ')'],'Interpreter','None')
legend(grnleg,redleg,'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.2,0.15,0.1,0.1],'String', {textnote, 'Normalized to intial reservoir.'})

savefig([baseSaveName slash date slash date '--reservoir.fig']);
saveas(gcf, [baseSaveName slash date slash date '--reservoir.png']);

%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(time, outlet(1,:)./inlet(1,:),'g-','LineWidth',3)
hold all
plot(time, outlet(2,:)./inlet(2,:),'r--','LineWidth',3)
title(['Accumulation (' info.date ')'],'Interpreter','None')
legend(grnleg,redleg,'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.3,0.4,0.1,0.1],'String', {textnote,'Intensity continuously normalized to reservoir.'})

savefig([baseSaveName slash date slash date '--accumulation.fig']);
saveas(gcf, [baseSaveName slash date slash date '--accumulation.png']);
%% Intensity profiles (kymographs):
% Plot of intensity vs position at several times
close all
final_time = int16(time(end));
grn_lgnd = ['Alexa488 ', num2str(final_time), ' min'];
red_lgnd = ['mCherry ', num2str(final_time), ' min'];
figure
plot(pos, kymo_green(2,:)/inlet(1,2),'c-')
hold all
plot(pos, kymo_green(end,:)/inlet(1,end),'g-')
%plot(pos, kymo_green(end,:)/inlet(1,1),'g-')
plot(pos, kymo_red(2,:)/inlet(2,2), 'm-')
plot(pos, kymo_red(end,:)/inlet(2,end), 'r-')
%plot(pos, kymo_red(end,:)/inlet(2,1), 'r-')
title(['Intensity profiles (', gelNotes, ')'])
legend('Alexa488 0 min',grn_lgnd, 'mCherry 0 min', ...
    red_lgnd,'Location','northeast')
xlabel('Position (microns)')
ylabel('Intensity continuously normalized to inlet')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.45,0.5,0.1,0.1],'String', {date, note1, note2})

%% ONLY RUN IF NECESSARY - flip profiles horizontally

% We want the inlet to be on the left-hand side of the plots.  Run this
% section if necessary.

kymo_green = fliplr(kymo_green);
kymo_red = fliplr(kymo_red);

%% Clean up workspace (run this before saving workspace)
clear ans file_size filename mydata roi3 roifilename
clear final_time grn_lgnd red_lgnd

end

