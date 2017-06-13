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
res = output{1};
accum = output{2};
roi3 = output{3};
%background = output{4};

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
plot(time, res(1,:)/res(1,1),'g-','LineWidth',3)
hold all
plot(time, res(2,:)/res(2,1),'r-','LineWidth',3)
title(['Reservoir intensity (' info.date ')'],'Interpreter','None')
legend(grnleg,redleg,'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.2,0.15,0.1,0.1],'String', {textnote, 'Normalized to intial reservoir.'})

savefig([baseSavePath slash date slash date '--reservoir.fig']);
saveas(gcf, [baseSavePath slash date slash date '--reservoir.png']);

%% Plot of accumulation vs. time:
close all
figure('DefaultAxesFontSize',18)
plot(time, accum(1,:)./res(1,:),'g-','LineWidth',3)
hold all
plot(time, accum(2,:)./res(2,:),'r--','LineWidth',3)
title(['Accumulation (' info.date ')'],'Interpreter','None')
legend(grnleg,redleg,'Location','northeast')
xlabel('Time (minutes)')
ylabel('Intensity')
annotation('textbox', [0.3,0.4,0.1,0.1],'String', {textnote,'Intensity continuously normalized to reservoir.'})

savefig([baseSavePath slash date slash date '--accumulation.fig']);
saveas(gcf, [baseSavePath slash date slash date '--accumulation.png']);
%% Intensity profiles (kymographs):
% Plot of intensity vs position at several times
close all
plotProfiles(timeAx,posAx,kymo_green,kymo_red,res,info);
accept = input('Flip profiles left to right? (y/n) /n','s');
while strcmp(accept,'y')
    kymo_green = fliplr(kymo_green);
    kymo_red = fliplr(kymo_red);
    plotProfiles(timeAx,posAx,kymo_green,kymo_red,res,info);
    accept = input('Flip profiles left to right? (y/n) /n','s');
end

savefig([baseSavePath slash date slash date '--profiles.fig']);
saveas(gcf, [baseSavePath slash date slash date '--profiles.png']);

%% Save important results in "plots" structure.

plots = struct();
plots.timeAx = timeAx;
plots.posAx = posAx;
plots.annotation = textnote;
plots.grnleg = grnleg;
plots.redleg = redleg;
plots.reservoir = res;
plots.accumulation = accum;
plots.grnProfile = kymo_green;
plots.redProfile = kymo_red;
plots.date = info.date;

save([baseSavePath slash date slash date '--plots.mat', 'plots']);

%% Make AVI from experiment
MakeAVI(data, info, [baseSavePath slash date slash date '.avi']);

end