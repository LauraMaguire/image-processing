%% FIND MINIMUM GEL WIDTH
% This script is used to find the minimum width of a hydrogel and write it
% to the third row of the gelWidths array.  Change 'index' to show
% different gels.  Upon running this script, the gel mask will be shown.
% Draw a rectangle over the region you want to be considered when
% calculating the minimum.  The new ROI will then be shown and the minimum
% thickness calculated and added to the array.  Run again if not happy with
% the rectangle placement.

index = 50;
imshow(gelMasks{2,index})
h = imrect;
% Use the following line instead if the gel is really oddly-shaped; just
% draw a line at the thinnest part from one edge of the gel to the other.
% Manually enter the number of pixels below.
%h = imdistline;

minWindow = h.createMask;
close all
imshow(minWindow.*gelMasks{2,index})

filtered = sum(minWindow.*gelMasks{2,index});
k = find(filtered);
nonzero = filtered(k);
%plot(filtered);
gelWidths(3,index) = data{index}.xscale*min(filtered(k));
display(['Min width of gel ' num2str(index) ' is ' num2str(gelWidths(3,index))]);