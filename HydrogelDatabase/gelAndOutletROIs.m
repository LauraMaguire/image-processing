%% DRAW ACCURATE GEL AND OUTLET MASKS
%  Laura Maguire 5/9/16

% Use this script any time you add entries to the FSFG database.  Fill in
% all information in the 'databaseBuilder' script and then run this script
% one section at a time.

% Once a useful image is loaded, draw carefully around the borders of the
% hydrogel, and then the outlet.  A new ROI file will be created in the
% same folder as the experiment file.

% The comment below suppresses a warning message that does not apply here.
%#ok<*ASGLU>

% watch out for file 31 (48 hrs)

%% Full file path of the video:
filename = expFile{49};

roifilename = strcat(filename(1:end-4),'_outROI.mat');

% Import the video if not too long (48 hrs is too long).
exp = bfopen(filename);

% If video is too long to open, comment out line above and run this code
% instead, adjusting scale value as needed.
% readers = bfGetReader(filename);
% finalRed = bfGetPlane(readers, readers.getImageCount());
% scale = [0; 0.05];
% finalRed = imadjust(finalRed,scale, [0; 1] );
% figure
% imshow(finalRed)

%% Set up an image which shows both edges of the hydrogel.
% Use final red image, appropriately scaled, if possible.  Otherwise, use
% the code that shows the final green image or a composite of the two.

% The scale value changes the brightness of the displayed image below.  A
% smaller scale value results in a brighter image.  If changing, change
% only the last number; i.e. [0; <CHANGE THIS>].
scale = [0; 0.01];

ListOfImages = exp{1,1};
RedImages = ListOfImages(2:2:length(ListOfImages));
finalRed = im2double(RedImages{1,end});
finalRed = imadjust(finalRed,scale, [0; 1] );
figure
imshow(finalRed)

% Optional code for final green image:

%GreenImages = ListOfImages(1:2:length(ListOfImages));
%finalGreen = im2double(GreenImages{1,end});
%finalGreen = imadjust(finalGreen,scale, [0; 1] );
%figure
%imshow(finalGreen)

% Optional code for red and green composite falsecolor image:

%composite = imfuse(finalGreen, finalRed, 'falsecolor');
%figure
%imshow(composite);

%% Run this section when image is appropriately adjusted to draw the ROIs.

[xA1, yA1, gelMask, xA2, yA2] = roipoly(finalRed);
[xB1, yB1, outletMask, xB2, yB2] = roipoly(finalRed);

% Display the image with ROIs overlaid so user can check them. (Does not
% work if bfReader has been loaded instead of experiment file - comment out
% in that case.)
imshow(gelMask.*finalRed + outletMask.*finalRed)

% Save the ROI coordinates.
save(roifilename,'xA1','xA2','yA1','yA2','xB1','xB2','yB1','yB2')

display('done')

%% Tidy the workspace
clear xA1 xA2 yA1 yA2 xB1 xB2 yB1 yB2 composite finalRed finalGreen exp
clear filename roifilename ListOfImages GreenImages RedImages
clear gelMask outletMask scale
