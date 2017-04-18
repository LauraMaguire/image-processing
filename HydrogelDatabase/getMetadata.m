% Script for easily looking at individual frames - mostly scratchwork and
% not as useful as databaseBuilder

%% Define the file path for all desired experiments.

% #1: ID1, 10 mg/mL bar gel, 2hr
exp{1} = 'Z:\Microscopy\2015\151203\FSFG_NTF2_no1.nd2';

% #2: ID2, 10 mg/mL bar gel, 2hr
exp{2} = 'Z:\Microscopy\2015\151203\FSFG_NTF2_no2.nd2';

% #3: ID3, 10 mg/mL bar gel, 2 hr
exp{3} = 'Z:\Microscopy\2015\151209\FSFG_NTF2_no1.nd2';

% #4: ID4, 10 mg/mL bar gel, overnight
exp{4} = 'Z:\Microscopy\2015\151209\FSFG_NTF2_no2.nd2';

% #5: ID5, 10 mg/mL bar gel with only free A488, 2 hr
exp{5} = 'Z:\Microscopy\2015\151209\FSFG_FreeDye.nd2';

% #6: ID6, 10 mg/mL bar gel, 2hr
exp{6} = 'Z:\Microscopy\2015\151210\FSFG_NTF2_no1.nd2';

% #7: ID7, 10 mg/mL bar gel, overnight
exp{7} = 'Z:\Microscopy\2015\151210\FSFG_NTF2_no2.nd2';

% #8: ID8, 30 mg/mL bar gel, 2 hr
exp{8} = 'Z:\Microscopy\2015\151214\30FSFG_NTF2_no1002.nd2';

% #9: ID9, 30 mg/mL bar gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
% Gel is deformed, maybe leaky
exp{9} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_30FSFG-NTF2-no2current2.vsi';

% #10: ID10, ctrl bar gel, 2 hr *not sure which video*
exp{10} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_ctrl_NTF2current4.vsi';

% #11: ID11, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{11} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no1current2.vsi';

% #12: ID12, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{12} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no2current2.vsi';

% #13: ID13, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{13} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no3current2.vsi';

% #14: ID14, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
% Bubble messes things up at the end
exp{14} = 'Z:\Microscopy\160106\FSFG10_NTF2_mCherry_10PEG03.vsi';

% #15: ID15, 10 mg/mL OF gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{15} = 'Z:\Microscopy\160107\FSFG10_NTF2_largeGel07.vsi';

% #16: ID16, 10 mg/mL OF gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{16} = 'Z:\Microscopy\160108\FSFG10_NTF2_largeGel\FSFG10_NTF2_largeGel03.vsi';

% #17: ID17, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{17} = 'Z:\Microscopy\160108\FSFG10_NTF2_mCherry_10PEG_bargel\FSFG10_NTF2_mCherry_10PEG03.vsi';

% #18: ID18, 50 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{18} = 'Z:\Microscopy\160110\GEL1\FSFG50_NTF2_mCherry_10PEG03.vsi';

% #19: ID19, 50 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
% Deformed, maybe leaky
exp{19} = 'Z:\Microscopy\160110\GEL2\FSFG50_NTF2_mCherry_10PEG_no203.vsi';

% #20: ID20, 50 mg/mL bar gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{20} = 'Z:\Microscopy\160110\GEL3\FSFG50_NTF2_mCherry_10PEG_no304.vsi';

% #21: ID26, 10 mg/mL SSSG bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{21} = 'Z:\Microscopy\160118\GEL2\160118_no2_SSSG_NTF2A488_mCherry03.vsi';

% #22: ID27, 10 mg/mL SSSG bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{22} = 'Z:\Microscopy\160118\GEL3\160118_no3_SSSG_NTF2A488_mCherry03.vsi';

% #23: ID28, 10 mg/mL SSSG OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{23} = 'Z:\Microscopy\160118\GEL4ON\160118_no4_SSSG_NTF2A488_mCherry_filledoutlet03.vsi';

% #24: ID34, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{24} = 'Z:\Microscopy\160124\Gel1\160124_no1_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';

% #25: ID35, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{25} = 'Z:\Microscopy\160125\gel1\160125_no1_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';

% #26: ID39, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{26} = 'Z:\Microscopy\160126\gel4\160126_no4_10FSFG_NTF2A488_mCherry_1kD_filled02.vsi';

% #27: ID41, Ctrl bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{27} = 'Z:\Microscopy\160127\gel2\160127_no2_CTRL_NTF2A488_mCherry_1kD03.vsi';

% #28: ID44, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
% ? not entirely sure it's the right video
exp{28} = 'Z:\Microscopy\160128\gel3\160128_no3_10FSFG_1kD_NTF2A488_mCherry_filledoutlet05.vsi';

% #29: ID47, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{29} = 'Z:\Microscopy\160201\gel2\160201_no2_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';

% #30: ID51, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
exp{30} = 'Z:\Microscopy\160208\gel2\160208_no2_FSFG_1kD_timingtest03.vsi';

% #31: ID56, 10 mg/mL OF gel, 48 hrs *ENTIRE EXPERIMENT*
exp{31} = 'Z:\Microscopy\160217\gel1\160217_no1_10FSFG_1kD_filledOutlet01.vsi';

% #32: ID66, 10 mg/mL bar gel, 2 hr?
exp{32} = 'Z:\Microscopy\160312\160312_no2_10FSFG_100umBar.nd2';

% #33: ID73, 10 mg/mL OF gel, 24 hr *ENTIRE EXPERIMENT*
exp{33} = 'Z:\Microscopy\160318\Olympus\160318_no1_10FSFG_5sec_filledOutlet02.vsi';

% #34: ID74, 10 mg/mL OF gel, 24 hr *ENTIRE EXPERIMENT*
exp{34} = 'Z:\Microscopy\160318\160318_no2_FSFG_5sec_outletfilled.nd2';

% #35: ID76, 1 mg/mL bar gel, 2 hr
exp{35} = 'Z:\Microscopy\160323\160323_no2_1FSFG_100umBar_wicked.nd2';

% #36: ID77, 1 mg/mL OF gel, overnight *ENTIRE EXPERIMENT*
exp{36} = 'Z:\Microscopy\160328\160328_no1_1FSFG_outletfilled.nd2';

% #37: ID78, 5 mg/mL bar gel, 3 hr *ENTIRE EXPERIMENT*
exp{37} = 'Z:\Microscopy\160328\OlympusGel2\160328_no2_5FSFG_100umBar_wicked04.vsi';

% #38: ID79, 5 mg/mL OF gel, overnight *ENTIRE EXPERIMENT*
exp{38} = 'Z:\Microscopy\160328\OlympusGel3\160328_no3_5FSFG_outletfilled02.vsi';

% #39: ID79, ctrl bar gel, 2 hr
exp{39} = 'Z:\Microscopy\160401\160401_no1_CTRL_100um.nd2';

% #40: ID83, ctrl bar gel, 2 hr
exp{40} = 'Z:\Microscopy\160406\160406_no3_CTRL_100um.nd2';

%% Get BF reader for all experiments

readers = cell(1,length(exp));
for i=1:length(exp)
    readers{i} = bfGetReader(exp{i});
    display(['Finished iteration' num2str(i)]);
end

%% Get the last and second-to-last frames of each experiment
final = cell(1, length(exp));
finalMinusOne = cell(1, length(exp));

for i=1:length(exp)
    final{i} = bfGetPlane(readers{i}, readers{i}.getImageCount());
    finalMinusOne{i} = bfGetPlane(readers{i}, readers{i}.getImageCount()-1);
end

%% Display final green frame of each experiment as a separate figure

for i=1:length(exp)
    figure(i)
    imshow(finalMinusOne{i});
    imcontrast
end

%%
omeMeta = readers{1}.getMetadataStore();

omeXML = char(omeMeta.dumpXML());

%%
fid = fopen('metadata.txt','wt');
fprintf(fid, omeXML);
fclose(fid);
%%

metadataKeys = omeMeta.keySet().iterator();
for i=1:omeMeta.size()
  key = metadataKeys.nextElement();
  value = omeMeta.get(key);
  fprintf('%s = %s\n', key, value)
end

%%
series1_plane_end = bfGetPlane(reader, reader.getImageCount());
series1_plane_endm1 = bfGetPlane(reader, reader.getImageCount()-1);

%%
figure(1);
imshow(series1_plane_end);
imcontrast
pause
figure(2)
imshow(series1_plane_endm1)
imcontrast


%%
roifilename = strcat(filename(1:end-4),'_rois.mat');


%%


To switch between series in a multi-image file, use the setSeries(int) method. To retrieve a plane given a set of (z, c, t) coordinates, these coordinates must be linearized first using getIndex(int, int, int)

% Read plane from series iSeries at Z, C, T coordinates (iZ, iC, iT)
% All indices are expected to be 1-based
reader.setSeries(iSeries - 1);
iPlane = reader.getIndex(iZ - 1, iC -1, iT - 1) + 1;
I = bfGetPlane(reader, iPlane);



file_size = size(mydata{1,1},1)
nchannels = 2;