% SINGLE MOVIE RECORDER
% LKM 9/3/15

% This script turns a single microscope file (.vsi or .nd2) into a .avi
% movie file.  The movie is saved as <date_movie.avi> in the processed
% experiment folder.

% Last modified: 05/18/17 by LKM

% Inputs: Full file path for video for experiment info file.

function [] = MakeAVI(filepath)

% retreive experiment info
load(filepath);

% import the experiment
data = bfopen([info.expFolder '\' info.expName]);
frames = info.frames;
display(['Video has been imported. It has ', num2str(frames), ' frames.'])

% split images into green and red
ListOfImages = data{1,1};
GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

% Create the file names the movies will be saved under
movPath = [info.baseSavePath '\' info.saveFolder '\' ...
    info.date '_movie.avi'];

% Make the video writer object that will assemble the movie.
mov = VideoWriter(movPath);

% Set the frame rate. Always will make a 10-s movie.
mov.FrameRate = frames/10;

% Open the video writer before beginning.
open(mov);

% Loop over all green images, display them, and add them to the movie.
for i=1:frames
    % Convert to from 16-bit image data to double.
    imageg = imadjust(im2double(GreenImages{1,i}));
    imager = imadjust(im2double(RedImages{1,i}));
    imageb = zeros(1024,1344);
    image = cat(3,imager,imageg,imageb);
    % Display the image as a figure.
    imshow(image);
    % Make the figure a movie frame. ('gcf' means 'get current figure')
    F = getframe(gcf);
    % Add the frame to the movie.
    writeVideo(mov,F);
end

%Close the final figure.
close all

%Close the video writer.
close(mov);
end