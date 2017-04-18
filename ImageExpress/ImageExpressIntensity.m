%% ImageExpress 96-well plate videos: calculate well fluorescence intensity
%  as a function of time

% This script takes processed tif series from an ImageExpress experiment
% and calculates the total fluorescence intensity over time.

%% USER INPUTS

% The full file path to the folder containing the processed tifs
savename = 'Z:\170309_FG124_ImageExpress_timecourse\';

%% Sum the intensity in each well and store in an array

% Set up for wells A1-F8 in a block, set up for 100 time points
intensity = zeros(6,8,100); % may need adjusting
for a=65:70 %HTML code for A,B,C,D,E,F - may need adjusting
    for w=1:8 %may need adjusting
        newfolder = ['well' a sprintf('%.2d', w)];
        for t=1:100 %may need adjusting
            im = imread([savename '\' newfolder '\t' sprintf('%.2d', t) '.tif']);
            intens = sum(sum(im));
            intensity((a-64),w,t) = intens(1,1,1);
            disp([newfolder 't=' sprintf('%.2d', t)]);
        end
    end
end

%% Test plot of a conditions's blanked intensity
condition = 3;
for i=1:6
    plot(squeeze(intensity(condition,i,:)/mean(intensity(condition,8,:))))
    hold all
end







