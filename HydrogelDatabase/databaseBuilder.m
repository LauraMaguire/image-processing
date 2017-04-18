%% FSFG DATABASE BUILDER
%  Laura Maguire 5/9/16

% This script creates a 'database' of FSFG, SSSG, and hydrogel experiments
% run since December 2015.  All experiments were run after we switched to
% the decomposing buffer for lyophilizing, but some gels were crosslinked
% using our first UV LED and some with the second, more powerful LED.
% Crosslinker MW is always 1 kDa; inlet solution is always 25 uM mCherry +
% 25 uM NTF2-A488 (except in one case where free A488 was substituted for
% NTF2-A488).

% The only user input is the 'baseFilePath' which should point towards the
% Google Drive folder on the user's computer.  Note that the experiment and
% data file paths will not work if the file structure is changed on the Z
% drive or Google Drive.

% This script can be run all at once, and must be run before running any
% part of the scripts 'FSFG_dataset_plots' or 'gelAndOutletROIs'.

% This script creates many arrays in the workspace:

%   1) expFile - the full file path of each experiment.  If a multi-part
%   Olympus experiment, the segment containing the two-hour point is used.

%   2) dataFile - the file path of the saved workspace created when the
%   data is processed in Google Drive.

%   3) data - a cell array containing each saved workspace.

%   4) protein - a cell array naming the type of Nup/protein anchored in
%   the gel. Current options: FSFG, SSSG, ctrl, FSFG-freeDye (for the inlet
%   containing only free dye) and FSFG-bad (used to denote leaky/outlier 
%   gels).

%   5) concentration - Nup concentration in mg/mL.  Ctrl gels are '0'.

%   6) mask - a cell array describing the mask used to make the hydrogel.
%   If a bar gel, entry is width of mask in microns.  'OF' denotes an
%   outlet-filling gel.

%   7) linkTime - hydrogel crosslinking time in seconds.

%   8) newLED - this is 0 for the gels made with the old LED and 1 for
%   those made with the new.

%   9) twoHourMark - the frame number corresponding to two hours into the
%   experiment.  Experiments that did not last for two hours are '0'.

%   10) twoHrOutlet - an array giving the normalized outlet intensity at
%   two hours.  Intensity is normalized to the average inlet at two hours.
%   First row is the green channel; second row is red.

%   11) twoHrOutletRatio - the ratio of green to red from twoHrOutlet

%   12) gelMasks - a cell array of gel and outlet masks.  Row 1 is the gel
%   mask defined by hand; row 2 is the rotated/squared gel mask after the
%   radon transform has been used; row 3 is the outlet mask defined by
%   hand.

%   13) gelWidths - a numerical array of gel widths.  Row 1 is the mean
%   width; row 2 is the standard deviation in width; row 3 is the minimum
%   width (meaningless for OF gels).  Widths given in um.

%   14) outletArea - the outlet area in um^2

%   15) roiFile - list of file names for newly-drawn gel and outlet masks

% This script also creates several subsets of data to make analysis easier.
% Currently these subsets are:
%   1) fb - all non-leaky FSFG bar gels except the free dye gel
%   2) fb01, fb05, fb10, fb30, fb50 - non-leaky FSFG bar gels (excpet the
%   free dye gel) with the indicated FSFG concentration (mg/mL)
%   3) dye - the single FSFG bar gel with only free A488 in the inlet
%   4) sb - all non-leaky SSSG bar gels (all 10 mg/mL)
%   5) cb - all non-leaky control bar gels (all 0 mg/mL protein)

%% Define the file path and other information for all desired experiments.

%baseFilePath = 'D:\Libraries\Google Drive\';
baseFilePath = 'C:\Users\Laura\Google Drive\';
extra = cell(1,50);

% #1: ID1, 10 mg/mL bar gel, 2hr
expFile{1} = 'Z:\Microscopy\2015\151203\FSFG_NTF2_no1.nd2';
dataFile{1} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151203_FSFG_NTF2_no1_LKM\151209_no1.mat';
protein{1} = 'FSFG'; conc(1) = 10; mask{1} = 100;
linkTime(1) = 120; newLED(1) = 0;

% #2: ID2, 10 mg/mL bar gel, 2hr
expFile{2} = 'Z:\Microscopy\2015\151203\FSFG_NTF2_no2.nd2';
dataFile{2} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151203_FSFG_NTF2_no2_LKM\151203_no2.mat';
protein{2} = 'FSFG'; conc(2) = 10; mask{2} = 100;
linkTime(2) = 120; newLED(2) = 0;

% #3: ID3, 10 mg/mL bar gel, 2 hr
expFile{3} = 'Z:\Microscopy\2015\151209\FSFG_NTF2_no1.nd2';
dataFile{3} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151209_FSFG_NTF2_no1\151209_no1.mat';
protein{3} = 'FSFG'; conc(3) = 10; mask{3} = 100;
linkTime(3) = 120; newLED(3) = 0;

% #4: ID4, 10 mg/mL bar gel, overnight
expFile{4} = 'Z:\Microscopy\2015\151209\FSFG_NTF2_no2.nd2';
dataFile{4} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151209_FSFG_NTF2_no2\151209_no2.mat';
protein{4} = 'FSFG'; conc(4) = 10; mask{4} = 100;
linkTime(4) = 120; newLED(4) = 0;

% #5: ID5, 10 mg/mL bar gel with only free A488, 2 hr
expFile{5} = 'Z:\Microscopy\2015\151209\FSFG_FreeDye.nd2';
dataFile{5} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151209_FSFG_freeDye\151209_FSFG_freeDye.mat';
protein{5} = 'FSFG-freeDye'; conc(5) = 10; mask{5} = 100;
linkTime(5) = 120; newLED(5) = 0;

% #6: ID6, 10 mg/mL bar gel, 2hr
expFile{6} = 'Z:\Microscopy\2015\151210\FSFG_NTF2_no1.nd2';
dataFile{6} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151210_FSFG_NTF2_no1\121510_no1.mat';
protein{6} = 'FSFG'; conc(6) = 10; mask{6} = 100;
linkTime(6) = 120; newLED(6) = 0;

% #7: ID7, 10 mg/mL bar gel, overnight
expFile{7} = 'Z:\Microscopy\2015\151210\FSFG_NTF2_no2.nd2';
dataFile{7} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151210_FSFG_NTF2_no2\151210_no2.mat';
protein{7} = 'FSFG'; conc(7) = 10; mask{7} = 100;
linkTime(7) = 120; newLED(7) = 0;

% #8: ID8, 30 mg/mL bar gel, 2 hr
expFile{8} = 'Z:\Microscopy\2015\151214\30FSFG_NTF2_no1002.nd2';
dataFile{8} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151214_30FSFG_NTF2\151214_no1.mat';
protein{8} = 'FSFG'; conc(8) = 30; mask{8} = 100;
linkTime(8) = 120; newLED(8) = 0;

% #9: ID9, 30 mg/mL bar gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
% Gel is deformed, maybe leaky
extra{9} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_30FSFG-NTF2-no2current1.vsi';
expFile{9} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_30FSFG-NTF2-no2current2.vsi';
dataFile{9} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151214_30FSFG_NTF2_no2\151214_30FSFG_NTF2_no2.mat';
protein{9} = 'FSFG-bad'; conc(9) = 30; mask{9} = 100;
linkTime(9) = 120; newLED(9) = 0;

% #10: ID10, ctrl bar gel, 2 hr *not sure which video*
extra{10} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_ctrl_NTF2current3.vsi';
expFile{10} = 'Z:\Microscopy\2015\151214\151214OLYMPUS\151214_ctrl_NTF2current4.vsi';
dataFile{10} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151214_ctrl_NTF2\151214_ctrl.mat';
protein{10} = 'ctrl'; conc(10) = 0; mask{10} = 100;
linkTime(10) = 120; newLED(10) = 0;

% #11: ID11, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{11} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no1current1.vsi';
expFile{11} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no1current2.vsi';
dataFile{11} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151215_30FSFG_NTF2_no1\151215-no1.mat';
protein{11} = 'FSFG'; conc(11) = 30; mask{11} = 100;
linkTime(11) = 120; newLED(11) = 0;

% #12: ID12, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{12} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no2current1.vsi';
expFile{12} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no2current2.vsi';
dataFile{12} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151215_30FSFG_NTF2_no2\151215-no2.mat';
protein{12} = 'FSFG'; conc(12) = 30; mask{12} = 100;
linkTime(12) = 120; newLED(12) = 0;

% #13: ID13, 30 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{13} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no3current1.vsi';
expFile{13} = 'Z:\Microscopy\2015\151215\151215_30FSFG-NTF2-no3current2.vsi';
dataFile{13} = 'Z:\Processed Images\2015 experiments\December 2015 Experiments\151215_30FSFG_NTF2_no3\151215_30FSFG_NTF2_no3.mat';
protein{13} = 'FSFG'; conc(13) = 30; mask{13} = 100;
linkTime(13) = 120; newLED(13) = 0;

% #14: ID14, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
% Bubble messes things up at the end
extra{14} = 'Z:\Microscopy\160106\FSFG10_NTF2_mCherry_10PEG02.vsi';
expFile{14} = 'Z:\Microscopy\160106\FSFG10_NTF2_mCherry_10PEG03.vsi';
dataFile{14} = 'Z:\Processed Images\Jan 2016 Experiments\160106_10mg_mL_FSFG_NTF2_mCherry_10PEG\FSFG_10mgmL_NTF2_mCherry_10PEG_Workspace.mat';
protein{14} = 'FSFG-bad'; conc(14) = 10; mask{14} = 100;
linkTime(14) = 120; newLED(14) = 0;

% #15: ID15, 10 mg/mL OF gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{15} = 'Z:\Microscopy\160107\FSFG10_NTF2_largeGel06.vsi';
expFile{15} = 'Z:\Microscopy\160107\FSFG10_NTF2_largeGel07.vsi';
dataFile{15} = 'Z:\Processed Images\Jan 2016 Experiments\160107_FSFG_NTF2_fillsOutlet\160107_FSFG_NTF2_fillsOutlet.mat';
protein{15} = 'FSFG'; conc(15) = 10; mask{15} = 'OF';
linkTime(15) = 120; newLED(15) = 0;

% #16: ID16, 10 mg/mL OF gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{16} = 'Z:\Microscopy\160108\FSFG10_NTF2_largeGel\FSFG10_NTF2_largeGel02.vsi';
expFile{16} = 'Z:\Microscopy\160108\FSFG10_NTF2_largeGel\FSFG10_NTF2_largeGel03.vsi';
dataFile{16} = 'Z:\Processed Images\Jan 2016 Experiments\160108_FSFG_NTF2_mCherry_filledoutlet\160108_FSFG10_NTF2_largeGel_workspace.mat';
protein{16} = 'FSFG'; conc(16) = 10; mask{16} = 'OF';
linkTime(16) = 120; newLED(16) = 0;

% #17: ID17, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
% This one has green/red = 15 at 2 hr; can't find anything wrong with it
extra{17} = 'Z:\Microscopy\160108\FSFG10_NTF2_mCherry_10PEG_bargel\FSFG10_NTF2_mCherry_10PEG02.vsi';
expFile{17} = 'Z:\Microscopy\160108\FSFG10_NTF2_mCherry_10PEG_bargel\FSFG10_NTF2_mCherry_10PEG03.vsi';
dataFile{17} = 'Z:\Processed Images\Jan 2016 Experiments\160108_FSFG10mgmL_NTF2_bargel\160108_FSFG10mgmL_NTF2_mCherry_10PEGbar_workspace.mat';
protein{17} = 'FSFG'; conc(17) = 10; mask{17} = 100;
linkTime(17) = 120; newLED(17) = 0;

% #18: ID18, 50 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
extra{18} = 'Z:\Microscopy\160110\GEL1\FSFG50_NTF2_mCherry_10PEG02.vsi';
expFile{18} = 'Z:\Microscopy\160110\GEL1\FSFG50_NTF2_mCherry_10PEG03.vsi';
dataFile{18} = 'Z:\Processed Images\Jan 2016 Experiments\160110_50mg_mLFSFG_NTF2_mCherry_10PEG_no1\160110_50mgmLFSFG_NTF2_workspace.mat';
protein{18} = 'FSFG'; conc(18) = 50; mask{18} = 100;
linkTime(18) = 120; newLED(18) = 0;

% #19: ID19, 50 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
% Deformed, maybe leaky
extra{19} = 'Z:\Microscopy\160110\GEL2\FSFG50_NTF2_mCherry_10PEG_no202.vsi';
expFile{19} = 'Z:\Microscopy\160110\GEL2\FSFG50_NTF2_mCherry_10PEG_no203.vsi';
dataFile{19} = 'Z:\Processed Images\Jan 2016 Experiments\160110_50mg_mLFSFG_NTF2_mCherry_10PEG_no2\160110_50FSFG_NTF2_mCherry_no2_workspace.mat';
protein{19} = 'FSFG-bad'; conc(19) = 50; mask{19} = 100;
linkTime(19) = 120; newLED(19) = 0;

% #20: ID20, 50 mg/mL bar gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
% Deformed
expFile{20} = 'Z:\Microscopy\160110\GEL3\FSFG50_NTF2_mCherry_10PEG_no304.vsi';
dataFile{20} = 'Z:\Processed Images\Jan 2016 Experiments\160110_50mg_mLFSFG_NTF2_mCherry_10PEG_no3_overnight\160110_50FSFG_overnight_workspace.mat';
protein{20} = 'FSFG'; conc(20) = 50; mask{20} = 100;
linkTime(20) = 120; newLED(20) = 0;

% #21: ID26, 10 mg/mL SSSG bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{21} = 'Z:\Microscopy\160118\GEL2\160118_no2_SSSG_NTF2A488_mCherry03.vsi';
dataFile{21} = 'Z:\Processed Images\Jan 2016 Experiments\160118_no2_SSSG_NTF2A488_mCherry\160118_no2_SSSG_NTF2A488_mCherry_workspace.mat';
protein{21} = 'SSSG'; conc(21) = 10; mask{21} = 100;
linkTime(21) = 120; newLED(21) = 0;

% #22: ID27, 10 mg/mL SSSG bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{22} = 'Z:\Microscopy\160118\GEL3\160118_no3_SSSG_NTF2A488_mCherry03.vsi';
dataFile{22} = 'Z:\Processed Images\Jan 2016 Experiments\160118_no3_SSSG_NTF2A488_mCherry\160118_no3_SSSG_NTF2_mCherry_workspace.mat';
protein{22} = 'SSSG'; conc(22) = 10; mask{22} = 100;
linkTime(22) = 120; newLED(22) = 0;

% #23: ID28, 10 mg/mL SSSG OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{23} = 'Z:\Microscopy\160118\GEL4ON\160118_no4_SSSG_NTF2A488_mCherry_filledoutlet03.vsi';
dataFile{23} = 'Z:\Processed Images\Jan 2016 Experiments\160118_no4_SSSG_outletfilled_NTF2_mCherry\160118_no4_SSSG_outletfilled_NTF2_mCherry_workspace.mat';
protein{23} = 'SSSG'; conc(23) = 10; mask{23} = 'OF';
linkTime(23) = 120; newLED(23) = 0;

% #24: ID34, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{24} = 'Z:\Microscopy\160124\Gel1\160124_no1_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';
dataFile{24} = 'Z:\Processed Images\Jan 2016 Experiments\160124_no1_10FSFG_1kD_NTF2A488_mCherry_filledOutlet\160124_no1_FSFG_NTF2A488_mCherry_outletfilled_workspace.mat';
protein{24} = 'FSFG'; conc(24) = 10; mask{24} = 'OF';
linkTime(24) = 120; newLED(24) = 0;

% #25: ID35, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{25} = 'Z:\Microscopy\160125\gel1\160125_no1_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';
dataFile{25} = 'Z:\Processed Images\Jan 2016 Experiments\160125_no1_10FSFG_NTF2A488_mCherry_outletfilled\160125_no1_10FSFG_NFT2A488_mCherry_outletfilled_workspace.mat';
protein{25} = 'FSFG'; conc(25) = 10; mask{25} = 'OF';
linkTime(25) = 120; newLED(25) = 0;

% #26: ID39, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{26} = 'Z:\Microscopy\160126\gel4\160126_no4_10FSFG_NTF2A488_mCherry_1kD_filled02.vsi';
dataFile{26} = 'Z:\Processed Images\Jan 2016 Experiments\160126_no4_10FSFG_NTF2A488_mCherry_outletfilled\160126_no4_10FSFG_outletfilled_workspace.mat';
protein{26} = 'FSFG'; conc(26) = 10; mask{26} = 'OF';
linkTime(26) = 120; newLED(26) = 0;

% #27: ID41, Ctrl bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{27} = 'Z:\Microscopy\160127\gel2\160127_no2_CTRL_NTF2A488_mCherry_1kD03.vsi';
dataFile{27} = 'Z:\Processed Images\Jan 2016 Experiments\160127_no2_CTRL_1kD_NTF2A488_mCherry\160127_no2_CTRL_NTF2A488_mCherry_workspace.mat';
protein{27} = 'ctrl'; conc(27) = 0; mask{27} = 100;
linkTime(27) = 120; newLED(27) = 0;

% #28: ID44, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
% ? not entirely sure it's the right video
expFile{28} = 'Z:\Microscopy\160128\gel3\160128_no3_10FSFG_1kD_NTF2A488_mCherry_filledoutlet05.vsi';
dataFile{28} = 'Z:\Processed Images\Jan 2016 Experiments\160128_no3_10FSFG_outletfilled\160128_no3_10FSFG_1kD_outletfilled_workspace.mat';
protein{28} = 'FSFG'; conc(28) = 10; mask{28} = 'OF';
linkTime(28) = 120; newLED(28) = 0;

% #29: ID47, 10 mg/mL OF gel, overnight *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{29} = 'Z:\Microscopy\160201\gel2\160201_no2_10FSFG_1kD_NTF2A488_mCherry_filledOutlet03.vsi';
dataFile{29} = 'Z:\Processed Images\Feb 2016 Experiments\160201_no2_10FSFG_outletFilled_1kD\160201_no2_10FSFG_1kD_filledoutlet_workspace.mat';
protein{29} = 'FSFG'; conc(29) = 10; mask{29} = 'OF';
linkTime(29) = 120; newLED(29) = 0;

% #30: ID51, 10 mg/mL bar gel, 2 hr *SECOND VIDEO, 8 min - 2 hr 8 min*
expFile{30} = 'Z:\Microscopy\160208\gel2\160208_no2_FSFG_1kD_timingtest03.vsi';
dataFile{30} = 'Z:\Processed Images\Feb 2016 Experiments\160208_no2_10FSFG_200x5sec\160208_no2_10FSFG_200x5sec_workspace.mat';
protein{30} = 'FSFG'; conc(30) = 10; mask{30} = 100;
linkTime(30) = 120; newLED(30) = 0;

% #31: ID56, 10 mg/mL OF gel, 48 hrs *ENTIRE EXPERIMENT*
expFile{31} = 'Z:\Microscopy\160217\gel1\160217_no1_10FSFG_1kD_filledOutlet02.vsi';
dataFile{31} = 'Z:\Processed Images\Feb 2016 Experiments\160217_outletFilled_2day\160217_48hr.mat';
protein{31} = 'FSFG'; conc(31) = 10; mask{31} = 'OF';
linkTime(31) = 120; newLED(31) = 0;

% #32: ID66, 10 mg/mL bar gel, 2 hr?
expFile{32} = 'Z:\Microscopy\160312\160312_no2_10FSFG_100umBar.nd2';
dataFile{32} = 'Z:\Processed Images\Mar 2016 Experiments\160312_no2_10FSFG_100umBar\160312_no2_10FSFG_100umBar_workspace.mat';
protein{32} = 'FSFG'; conc(32) = 10; mask{32} = 100;
linkTime(32) = 30; newLED(32) = 1;

% #33: ID73, 10 mg/mL OF gel, 24 hr *ENTIRE EXPERIMENT*
expFile{33} = 'Z:\Microscopy\160318\Olympus\160318_no1_10FSFG_5sec_filledOutlet02.vsi';
dataFile{33} = 'Z:\Processed Images\Mar 2016 Experiments\160318_no1_10FSFG_5sec_filledOutlet\160318_no1_10FSFG_5sec_filledOutlet_workspace.mat';
protein{33} = 'FSFG'; conc(33) = 10; mask{33} = 'OF';
linkTime(33) = 5; newLED(33) = 1;

% #34: ID74, 10 mg/mL OF gel, 24 hr *ENTIRE EXPERIMENT*
expFile{34} = 'Z:\Microscopy\160318\160318_no2_FSFG_5sec_outletfilled.nd2';
dataFile{34} = 'Z:\Processed Images\Mar 2016 Experiments\160318_no2_FSFG_5sec_outletfilled\160318_no2_FSFG_5sec_outletfilled_workspace.mat';
protein{34} = 'FSFG'; conc(34) = 10; mask{34} = 'OF';
linkTime(34) = 5; newLED(34) = 1;

% #35: ID76, 1 mg/mL bar gel, 2 hr
expFile{35} = 'Z:\Microscopy\160323\160323_no2_1FSFG_100umBar_wicked.nd2';
dataFile{35} = 'Z:\Processed Images\Mar 2016 Experiments\160323_no2_1FSFG_100umBar_wicked\160323_no2_1FSFG_100umBar_wicked_workspace.mat';
protein{35} = 'FSFG'; conc(35) = 1; mask{35} = 100;
linkTime(35) = 10; newLED(35) = 1;

% #36: ID77, 1 mg/mL OF gel, overnight *ENTIRE EXPERIMENT*
expFile{36} = 'Z:\Microscopy\160328\160328_no1_1FSFG_outletfilled.nd2';
dataFile{36} = 'Z:\Processed Images\Mar 2016 Experiments\160328_no1_1FSFG_outletfilled\160328_no1_1FSFG_outletfilled_workspace.mat';
protein{36} = 'FSFG'; conc(36) = 1; mask{36} = 'OF';
linkTime(36) = 5; newLED(36) = 1;

% #37: ID78, 5 mg/mL bar gel, 3 hr *ENTIRE EXPERIMENT*
expFile{37} = 'Z:\Microscopy\160328\OlympusGel2\160328_no2_5FSFG_100umBar_wicked04.vsi';
dataFile{37} = 'Z:\Processed Images\Mar 2016 Experiments\160328_no2_5FSFG_100umBar_wicked\160328_no2_5FSFG_100umBar_wicked_workspace.mat';
protein{37} = 'FSFG'; conc(37) = 5; mask{37} = 100;
linkTime(37) = 10; newLED(37) = 1;

% #38: ID79, 5 mg/mL OF gel, overnight *ENTIRE EXPERIMENT*
expFile{38} = 'Z:\Microscopy\160328\OlympusGel3\160328_no3_5FSFG_outletfilled02.vsi';
dataFile{38} = 'Z:\Processed Images\Mar 2016 Experiments\160328_no3_5FSFG_outletfilled\160328_no3_5FSFG_outletfilled_workspace.mat';
protein{38} = 'FSFG'; conc(38) = 5; mask{38} = 'OF';
linkTime(38) = 5; newLED(38) = 1;

% #39: ID79, ctrl bar gel, 2 hr
expFile{39} = 'Z:\Microscopy\160401\160401_no1_CTRL_100um.nd2';
dataFile{39} = 'Z:\Processed Images\April 2016 Experiments\160401_no1_CTRL_100um\160401_no1_CTRL_100um_workspace.mat';
protein{39} = 'ctrl'; conc(39) = 0; mask{39} = 100;
linkTime(39) = NaN; newLED(39) = 1;

% #40: ID83, ctrl bar gel, 2 hr
expFile{40} = 'Z:\Microscopy\160406\160406_no3_CTRL_100um.nd2';
dataFile{40} = 'Z:\Processed Images\April 2016 Experiments\160406_no3_CTRL_100um\160406_no3_CTRL_100um_workspace.mat';
protein{40} = 'ctrl'; conc(40) = 0; mask{40} = 100;
linkTime(40) = NaN; newLED(40) = 1;

% #41: ID90, 10mg/mL thick (330 um) bar gel, 2 hr
expFile{41} = 'Z:\Microscopy\160504\160504_no1_10FSFG_330um.nd2';
dataFile{41} = 'Z:\Processed Images\May 2016 Experiments\160504_no1_10FSFG_330um\160504_no1_10FSFG_330um_workspace.mat';
protein{41} = 'FSFG'; conc(41) = 10; mask{41} = 330;
linkTime(41) = 30; newLED(41) = 1;

% #42: ID91, 10mg/mL thin (50 um) bar gel, 2 hr
expFile{42} = 'Z:\Microscopy\160504\160504_no2_10FSFG_50um.nd2';
dataFile{42} = 'Z:\Processed Images\May 2016 Experiments\160504_no2_10FSFG_50um\160504_no2_10FSFG_50um_workspace.mat';
protein{42} = 'FSFG'; conc(42) = 10; mask{42} = 50;
linkTime(42) = 30; newLED(42) = 1;

% #43: ID92, 10mg/mL thick (330 um) bar gel, ON
expFile{43} = 'Z:\Microscopy\160504\160504_no3_10FSFG_330um.nd2';
dataFile{43} = 'Z:\Processed Images\May 2016 Experiments\160504_no3_10FSFG_330um\160504_no3_10FSFG_330um_workspace.mat';
protein{43} = 'FSFG'; conc(43) = 10; mask{43} = 330;
linkTime(43) = 10; newLED(43) = 1;

% Adding in FSFG gels presoaked in NTF2 (not chronological with the others)

% #44: ID32, 10mg/mL bar gel, 2 hr, 100uM presoaking, weird inlet conc.
expFile{44} = 'Z:\Microscopy\160122\gel1\160122_no1_10FSFG_soak_NTF2A488_mCherry03.vsi';
dataFile{44} = 'Z:\Processed Images\Jan 2016 Experiments\160122_no1_100uMsoak_FSFG_NTF2A488_mCherry\160122_no1_10FSFG_100uMsoak_NTF2A488_mcherry_1kD_workspace.mat';
protein{44} = 'FSFG'; conc(44) = 10; mask{44} = 100;
linkTime(44) = 120; newLED(44) = 0; soak(44) = 100;

% #45: ID33, 10mg/mL bar gel, 2 hr, 100uM presoaking
expFile{45} = 'Z:\Microscopy\160122\gel2\160122_no2_10FSFG_soak_100NTF2A488_mCherry03.vsi';
dataFile{45} = 'Z:\Processed Images\Jan 2016 Experiments\160122_no2_100uMsoak_FSFG_NTF2A488_mCherry\160122_no2_10FSFG_soak100_NTF2A488_mCherry_1kD_workspace.mat';
protein{45} = 'FSFG'; conc(45) = 10; mask{45} = 100;
linkTime(45) = 120; newLED(45) = 0; soak(45) = 100;

% #46: ID37, 10mg/mL bar gel, 2 hr, 50uM presoaking
expFile{46} = 'Z:\Microscopy\160126\gel2\160126_no2_10FSFG_50uMsoak_NTF2A488_mCherry_1kD03.vsi';
dataFile{46} = 'Z:\Processed Images\Jan 2016 Experiments\160126_no2_10FSFG_50uMsoak\160126_no2_10FSFG_50uMsoak_workspace.mat';
protein{46} = 'FSFG'; conc(46) = 10; mask{46} = 100;
linkTime(46) = 120; newLED(46) = 0; soak(46) = 50;

% #47: ID42, 10mg/mL bar gel, 2 hr, 100uM presoaking
expFile{47} = 'Z:\Microscopy\160128\gel1\160128_no1_10FSFG_1kD_soak100_NTF2A488_mCherry03.vsi';
dataFile{47} = 'Z:\Processed Images\Jan 2016 Experiments\160128_no1_10FSFG_1kD_soak100_NTF2_mCherry\160128_no1_10FSFG_1kD_soak100_NTF2_mCherry_workspace.mat';
protein{47} = 'FSFG'; conc(47) = 10; mask{47} = 100;
linkTime(47) = 120; newLED(47) = 0; soak(47) = 100;

% #48: ID43, 10mg/mL bar gel, 2 hr, 50uM presoaking
expFile{48} = 'Z:\Microscopy\160128\gel2\160128_no2_10FSFG_1kD_soak50_NTF2A488_mCherry03.vsi';
dataFile{48} = 'Z:\Processed Images\Jan 2016 Experiments\160128_no2_10FSFG_1kD_soak50\160128_no2_10FSFG_1kD_soak50_workspace.mat';
protein{48} = 'FSFG'; conc(48) = 10; mask{48} = 100;
linkTime(48) = 120; newLED(48) = 0; soak(48) = 50;

% #49: ID45, 10mg/mL bar gel, 2 hr, 100uM presoaking
expFile{49} = 'Z:\Microscopy\160129\gel1\160129_no1_10FSFG_100uMsoak_NTF2A488_mCherry_1kD03.vsi';
dataFile{49} = 'Z:\Processed Images\Jan 2016 Experiments\160129_no1_100uMsoak_10FSFG\OldProcessing\160129_10FSFG_100uMsoak_1kD_workspace.mat';
protein{49} = 'FSFG'; conc(49) = 10; mask{49} = 100;
linkTime(49) = 120; newLED(49) = 0; soak(49) = 100;

% #50: ID54, 10mg/mL OF gel, overnight, 100uM presoaking
% 'had to restart expt because of turret error'
expFile{50} = 'Z:\Microscopy\160215\gel1\160215_no1_10FSFG_100uMSoak_1kD_filledOutlet03.vsi';
dataFile{50} = 'Z:\Processed Images\Feb 2016 Experiments\160215_outletFilled_presoaked_24hr\160215_secondVideo\160215_no1_secondVideo.mat';
protein{50} = 'FSFG'; conc(50) = 10; mask{50} = 'OF';
linkTime(50) = 120; newLED(50) = 0; soak(50) = 100;

%% Load saved workspaces

data = cell(1,length(dataFile));
for i=1:length(dataFile)
    display(['Loading file ' num2str(i) ' of ' num2str(length(dataFile))]);
    data{i} = load(dataFile{i});
end
clear i

%% Fill in any missing data
data{32}.frames = 120;
data{32}.time = (1:data{32}.frames)*data{32}.tscale1/60;

data{33}.frames = 720;
data{33}.time = (1:data{33}.frames)*data{33}.tscale/60;

data{34}.frames = 700;
data{34}.time = (1:data{34}.frames)*data{34}.tscale/60;

data{35}.frames = 120;
data{35}.time = (1:data{35}.frames)*data{35}.tscale1/60;

data{36}.frames = 720;
data{36}.time = (1:data{36}.frames)*data{36}.tscale/60;

data{37}.frames = 180;
data{37}.time = (1:data{37}.frames)*data{37}.tscale/60;

data{38}.time = (1:data{38}.frames)*data{38}.tscale/60;

data{39}.frames = 89;
data{38}.time = (1:data{38}.frames)*data{38}.tscale/60;

% Get rid of blip in the middle of Exp 31 (48 hr OF gel)
for i=1:length(data{31}.time)
    if (data{31}.outlet(1,i)/data{31}.inlet(1,i))<-5
        data{31}.inlet(1,i) = NaN;
        data{31}.inlet(2,i) = NaN;
        data{31}.outlet(1,i) = NaN;
        data{31}.outlet(2,i) = NaN;
    end
end

% Correcting for 2x2 binning on the Nikon (makes apparent x scale twice
% actual x scale)
for i=1:length(dataFile)
    if data{i}.xscale>2
        data{i}.xscale = 3.23/2;
    end
end
clear i

%% Find the frame at 2 hrs (round down)
%  twoHourMark = 0 for experiments lasting less than two hours
twoHourMark = zeros(1,length(dataFile));
for i=1:length(data)
    [~, col] = find(abs(data{i}.time - 120) < 1);
    if numel(col)>0
        twoHourMark(i) = col(1);
    else
        twoHourMark(i) = 0;
    end
end
clear col i

%% Rescale all outlet data so that every trace begins at zero
for i=1:length(dataFile)
    data{i}.outlet(1,:) = data{i}.outlet(1,:) - data{i}.outlet(1,1);
    data{i}.outlet(2,:) = data{i}.outlet(2,:) - data{i}.outlet(2,1);
end
clear i

%% Define subsets of data

% all non-leaky FSFG bar gels lasting at least two hours
% fb = [1,2,3,4,6,7,8,10,11,12,13,17,18,20,27,30,32,35,37,40,41,42,43];
% Without outlier at 17
% fb = [1,2,3,4,6,7,8,10,11,12,13,18,20,27,30,32,35,37,40,41,42,43];
% Without twisty gels
fb = [1,2,3,4,6,7,8,10,11,12,13,27,30,32,35,37,40,41,42,43];

% all SSSG bar gels lasting at least two hours
sb = [21,22];

% a lone 10 mg/mL FSFG bar gel with free dye instead of NTF2
dye = 5;

% subset of FSFG bar gels: ctrl gels (FSFG concentration = 0)
cb =  [10,27,40];

% subset of FSFG bar gels: FSFG concentration = 1
fb01 = 35;

% subset of FSFG bar gels: FSFG concentration = 5
fb05 = 37;

% subset of FSFG bar gels: FSFG concentration = 10
% fb10 = [1,2,3,4,6,7,17,30,32,41,42,43];
% Without outlier at 17
fb10 = [1,2,3,4,6,7,30,32,41,42,43];

% subset of FSFG bar gels: FSFG concentration = 30
fb30 = [8,11,12,13];

% subset of FSFG bar gels: FSFG concentration = 50
% Both of these are twisty gels
fb50 = [18,20];

% subset of FSFG bar gels: presoaked in 100 uM NTF2
ps100 = [44,45,47,49];

% subset of FSFG gels: presoaked in 50 uM NTF2
ps50 = [46,48];

% subset of all gels: outlet-filled gels
of = [15,16,23,24,25,26,28,29,31,33,34,36,38,50];

%% Make database of ROI files
roiFile = cell(1,length(dataFile));
for i=1:length(dataFile)
    roiFile{i} = strcat(expFile{i}(1:end-4),'_outROI.mat');
end
clear i

%% Make some lists showing the gel mask and width
gelMasks = cell(3,length(dataFile));
gelWidths = zeros(3,length(dataFile));
for i=1:length(dataFile)
    r = load(roiFile{i});
    display(['Loaded mask ' num2str(i)])
    gel = roipoly(r.xA1, r.yA1, zeros(480,640), r.xA2, r.yA2);
    gelMasks{3,i} = roipoly(r.xB1, r.yB1, zeros(480,640), r.xB2, r.yB2);
    gelMasks{1,i} = gel;
    %Compute the radon transform
        theta = 0:179;
        [R,xp] = radon(gel, theta);
        %imagesc(theta,xp,R);
    % Rotate the gel
        [row,col] = find(R==max(max(R)));
        rotatedGel = imrotate(gel,0.5*(90-theta(col)));
        gelMasks{2,i} = rotatedGel;
        %imshow(gel4);
    % Calculate mean and st. dev. of gel width
    rawWidths = sum(rotatedGel);
    k = find(rawWidths);
    widths = rawWidths(k);
    widths = widths(2:end-1);
    gelWidths(1,i) = data{i}.xscale*mean(widths);
    gelWidths(2,i) = data{i}.xscale*std(widths);
    gelWidths(3,i) = data{i}.xscale*min(widths);
end
clear gel R theta col rotatedGel rawWidths k widths r i xp row

%% Calculate outlet area for each gel (in square microns)
outletArea = zeros(1,length(dataFile));
for i=1:length(dataFile)
    %outletArea(i) = sum(sum(gelMasks{3,i}));
    outletArea(i) = (data{i}.xscale)*(data{i}.xscale)*sum(sum(gelMasks{3,i}));
end
clear i

%% make vectors of outlet accumulation and ratio at two hours
twoHrOutlet = zeros(2,length(dataFile));
twoHrOutletRatio = zeros(1,length(dataFile));
for i=1:length(dataFile)
    if twoHourMark(i) ~= 0
        twoHrOutlet(1,i) = data{i}.outlet(1,twoHourMark(i))/...
            data{i}.inlet(1,twoHourMark(i));
        twoHrOutlet(2,i) = data{i}.outlet(2,twoHourMark(i))/...
            data{i}.inlet(2,twoHourMark(i));
        twoHrOutletRatio(i) = twoHrOutlet(1,i)/twoHrOutlet(2,i);
    else
        twoHrOutlet(1,i) = NaN;
        twoHrOutlet(2,i) = NaN;
        twoHrOutletRatio(i) = NaN;        
    end
end
clear i
display('Finished building database');
