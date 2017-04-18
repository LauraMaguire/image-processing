%% CONVERTING OLYMPUS SNAPSHOT TO OTHER FORMATS
% LKM 1/13/16
% This script imports an Olympus .vsi file and displays the first frame.
% It is intended for converting a brightfield 'before' image into a jpeg.
% Input the file path and run all sections, then save the image as a jpeg.


%% USER INPUT

% Full file path of the video:
filename = 'Z:\Microscopy\160110\GEL3\FSFG50_NTF2_mCherry_10PEG_no302.vsi';

%% Import the video.

mydata = bfopen(filename);
display(['Video has been imported.']);

%% Display the first frame.
% SCALE: A smaller scale value means the images will be brighter.  Change 
% only the second number in the scale object, 
% i.e. scale = [0; <change this>].

scale = [0; 0.05];

image = im2double(mydata{1,1}{1,1});
image = imadjust(image,scale, [0; 1] );
imshow(image);