% Experiment information file.

% File path information
% expFolder: folder where experiment is located
info.expFolder = 'Z:\Microscopy\170516';
% expName: experiment file name
info.expName = 'GelA3_50-50_Hough_1Hour_timingfile_Katie.oex_03.vsi';
% baseSavePath: location of all processed image folders
info.baseSavePath = 'Z:\Processed Images';
% saveFolderOverwrite: name of folder where all results should be saved, if
% not standard.  Leave blank ('') if using standard naming.  Useful for
% older files.
info.saveFolderOverwrite = '2017-05\2017-05-16_50-50mix_linker_250kD_70kD';

% Date information
info.day = 16; % day of the month that experiment was run
info.month = 5; % month experiment was run
info.year = 2017; % year experiment was run
info.dailyIndex = 2; % indexes order in which experiments were run on that day
info.date = [num2str(info.year) '-' num2str(info.month) '-' ...
    num2str(info.day) '_' num2str(info.dailyIndex)]; % calculated date field

% Microscope information
info.scopeName = 'Olympus'; % Olympus or Nikon?
info.frames = 240; % number of frames
info.nChannels = 2; % number of channels
info.tScale = 30; % seconds per frame
info.xScale = 1.58; % microns per pixel (1.58 is for Olympus, 4x)
info.scopeNotes = ''; % extra notes about the microsope settings

% Gel information
info.protein = 'ctrl'; % name of protein anchored to gel ('ctrl' for no protein)
info.conc = 0; % protein concentration in mg/mL
info.geo = 'pipette ring'; % geometry of gel
info.linker = '50-50 1-8kD'; % MW of linker
info.gelNotes = ''; % extra notes about the gel

% Solution information
info.greenName = '250kD grn dex'; % name of green species
info.greenConc = 20; % concentration of green species (uM)
info.redName = '70kD red dex'; % name of red species
info.redConc = 20; % concentration of red species (uM)
info.buffer = 'PTB'; % buffer
info.solNotes = ''; % extra notes about solution

% Extra notes
info.extraNotes = '';

% Save all information in a matlab file.
% If saveFolderOverwrite is not a blank string, save in that folder.
% Otherwise, make the standard folder 'year-month-day_dailyIndex'.
if strcmp(info.saveFolderOverwrite, '')
    info.saveFolder = info.date;
else
    info.saveFolder = info.saveFolderOverwrite;
end
mkdir info.saveFolder info.baseSavePath
info.path = [info.baseSavePath '\' info.saveFolderOverwrite '\' ...
    info.date];
save(info.path);
