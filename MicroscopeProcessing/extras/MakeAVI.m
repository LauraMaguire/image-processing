% SINGLE MOVIE RECORDER
% LKM 9/3/15

% This script turns a single microscope file (.vsi or .nd2) into two .avi
% movie files.  It uses a single frame rate and does not account for
% differences in timing interval that may occur during the microscope
% experiment.  The green-channel and red-channel movies are saved in the
% same Z drive folder as the original file.

% Last modified: 01/04/2106 by LKM

% Inputs:
%   (1) Full file path for video
%   (2) Number of color channels
%   (3) Brightness scale (adjust as needed)
%   (4) Frame rate of resulting .avi movies

% Run each section of code separately by pressing 'ctrl+enter'.

%% USER INPUTS

% Full file path of the video:
filename = 'C:\Users\Laura\Downloads\1_MT_Glutamate020.nd2';

% Number of color channels (almost always two: green and red):
nchannels = 2;

% Frame rate of final .avi movies (frames per second):
fps = 4;

%% PROCESSING BEGINS HERE

%% Import the video.

mydata = bfopen(filename);
file_size = size(mydata{1,1},1);
frames = file_size/nchannels;
display(['Video has been imported. It has ', num2str(frames), ' frames.'])

%% Rename some stuff for convenience
ListOfImages = mydata{1,1};
GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

% Create the file names the movies will be saved under
GrnMovieFileName = strcat(filename(1:end-4),'_grn.avi');
RedMovieFileName = strcat(filename(1:end-4),'_red.avi');

%% Display a green frame from a movie / Check the scale

% Run this before making the movie to ensure the scale is good.  A smaller
% scale value means the images will be brighter.  Change only the second
% number in the scale object, i.e. scale = [0; <change this>].

scale = [0; 0.15];

% Displays first green frame.
temp = im2double(GreenImages{1,end});
temp = imadjust(temp,scale, [0; 1] );
imshow(temp);

%% Create the green-channel movie

% Uses the same scale as the previous section.  Displays and creates a 
% movie and saves it to the folder the original file came from.

% Make the video writer object that will assemble the movie.
grnMov = VideoWriter(GrnMovieFileName);

% Set the frame rate.
grnMov.FrameRate = 4;

% Open the video writer before beginning.
open(grnMov);

% Loop over all green images, display them, and add them to the movie.
for i=1:1%frames
    % Convert to from 16-bit image data to double.
    imageg = imadjust(im2double(GreenImages{1,i}));
    imager = imadjust(im2double(RedImages{1,i}));
    imageb = zeros(1024,1344);
    image = cat(3,imager,imageg,imageb);
    % Apply the scaling.
    %image = imadjust(image,scale, [0; 1] );
    % Display the image as a figure.
    imshow(image);
    % Make the figure a movie frame. ('gcf' means 'get current figure')
    F = getframe(gcf);
    % Add the frame to the movie.
    writeVideo(grnMov,F);
end

%Close the final figure.
close all

%Close the video writer.
close(grnMov);

%Tidy the workspace.
clear i F

%% Display a red frame from a movie / Check the scale

% Run this before making the movie to ensure the scale is good.  A smaller
% scale value means the images will be brighter.  Change only the second
% number in the scale object, i.e. scale = [0; <change this>].

scale = [0; 0.03];

% Displays first red frame.
temp = im2double(RedImages{1,end});
temp = imadjust(temp,scale, [0; 1] );
imshow(temp);

%% Create the red-channel movie

redMov = VideoWriter(RedMovieFileName);
redMov.FrameRate = 4;
open(redMov);
for i=1:frames
    image = im2double(RedImages{1,i});
    image = imadjust(image,scale, [0; 1] );
    imshow(image);
    F=getframe(gcf);
    writeVideo(redMov,F);
end
close all
close(redMov);
clear i F image

%% Clean up workspace
clear ans file_size filename mydata ListOfImages GrnMovieFileName
clear RedMovieFileName temp grnMov redMov

%%
imshow(image)
