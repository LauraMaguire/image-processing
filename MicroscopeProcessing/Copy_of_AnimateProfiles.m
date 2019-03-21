%% Scipts to plot and animate the concentration profiles
% Laura Maguire 9/21/15

% The profiles are stored in arrays that are named with variations on
% "kymo," because we originally plotted them as kymographs.  Each
% experiment results in a profile for the green channel (the transport
% factor that should be binding to the hydrogel) and the red channel
% (mCherry, our inert negative control protein that should not be binding).
% The transport factor and mCherry are about the same size.

% The first dimension of each array indexes the frame number of the 
% experiment.  The second dimension indexes position across the inlet, gel, 
% and outlet. Most of our movies are taken at 5 seconds per frame for the 
% first 100 frames (about 8 minutes) and then switch to 1 min/frame for the
% next 120 frames.  I've included a scaled time axis for each experiment in
% case you  want to plot something as a function of time instead of frame 
% number, as well as a scaled position axis to show real distances instead
% of pixels.


%% Display a profile, specifying frame number

%frameNumber = 100;
%plot(pos_01, greenKymo_01(frameNumber,:));

%% Animate a profile

% Displays and creates a movie of the profile.  Saves in the current
% Matlab folder as "temp.avi" and gets overwritten every time this section
% is run.

% INPUT: Set which profile is animated and pick the correct position and 
% time axes.

% Make the video writer object that will assemble the movie.
Mov = VideoWriter('temp.avi');

% Set the frame rate (frames per second).
Mov.FrameRate = 10;

% Open the video writer before beginning.
open(Mov);
t=1:101;
% Loop over all green images, display them, and add them to the movie.
% i=1:size(kymo2,1)
for i=1:length(t)
    % Give the profile a handle so I can delete it later.
    h1 = plot(tot(:,i),'r-');
    hold all
    h3 = plot(tot1(:,i),'g--');
    % Make the axes and labels pretty.
    %axis([1 pos(end) -0.01 ceil(max(max(kymo2)))]);
    axis([1 130 -1e-6 20e-5]);
    xlabel('Position (um)');
    ylabel('Intensity (cont. normed. to inlet)');
    % Show current time and frame number as annotation.
    h2 = annotation('textbox', [0.7,0.8,0.1,0.1],'String', ...
        {['Frame ' num2str(i)], ['Time (hr) ' num2str(t(i),3)]});
    % Make the figure into a movie frame.
    F = getframe;
    % Add the frame to the movie.
    writeVideo(Mov,F);
    % Get rid of trace and annotation without closing figure.
    delete(h1);
    delete(h2);
    delete(h3);
end

%Close the final figure.
close all

%Close the video writer.
close(Mov);

%Tidy the workspace.
clear Mov kymo i F h1 h2 h3 kymo2
