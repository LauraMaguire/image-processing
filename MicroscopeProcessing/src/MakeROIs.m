function [ roifilename ] = MakeROIs( mydata, roifilename, series )
% This function allows users to create the ROIs described in the
% video-processing scripts.  It displays a movie frame, allows users to
% click to create ROIs, and returns a file containing the ROI coordinates.
% The ROI file is created in the same directory in which the video resides,
% and has the same names as the video with the addition of 'roi-gel' or
% 'roi-bulk', depending on whether which series is selected.

% Modified 10/13/15 by LKM.
% Originally modified from an earlier script by Loren and Grant.

% The comment below suppresses a warning message that does not apply here.
%#ok<*ASGLU>

% If user has not specified a series number, use the first series.
if nargin < 3
    series =1;
end

% Some useful definitions
ListOfImages = mydata{1,1};
GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

% The scale value changes the brightness of the displayed image below.  A
% smaller scale value results in a brighter image.  If changing, change
% only the last number; i.e. [0; <CHANGE THIS>].
scale = [0; 0.05];

% Make a composite falsecolor image of the final green and red frames so
% that user can see both edges of the gel.
finalGreen = im2double(GreenImages{1,end});
finalGreen = imadjust(finalGreen,scale, [0; 1] );

finalRed = im2double(RedImages{1,end});
finalRed = imadjust(finalRed,scale, [0; 1] );

composite = imfuse(finalGreen, finalRed, 'falsecolor');
imshow(composite);

% Begin the case-switching section.  Different numbers of ROIs are needed
% depending on whether we are looking at the 'gel' or 'bulk' series.  The
% gel series (indexed as 1) shows the outlet, gel, and a thin slice of the
% inlet.  The 'bulk' series (indexed as 2) shows the inlet far from the 
% gel.

switch series
    
    % Case 1 handles the gel series.  In this case, we define four ROIs.
    % In order, these are: inlet, kymograph, outlet, and background.  The
    % user selects the ROIs using the roipoly function.
    case 1 
        % Inlet ROI
        [xA1, yA1, BW1, xA2, yA2] = roipoly(composite);
        % Kymograph ROI
        [xB1, yB1, BW2, xB2, yB2] = roipoly(composite);
        % Outlet ROI
        [xC1, yC1, BW3, xC2, yC2] = roipoly(composite);
        % Background ROI
        [xD1, yD1, BW4, xD2, yD2] = roipoly(composite);
    
        % Adjust the kymograph ROI into a rectangle which is square with
        % the image.
        low = min(xB2(1), xB2(3));
        high = max(xB2(1), xB2(3));
        
        xB2(1) = low;
        xB2(2) = low;
        xB2(3) = high;
        xB2(4) = high;
        
        low = min(yB2(1), yB2(3));
        high = max(yB2(1), yB2(3));
        
        yB2(1) = low;
        yB2(2) = high;
        yB2(3) = high;
        yB2(4) = low;
        
        BW2 = roipoly(xB1, yB1, composite, xB2, yB2);
        
        % Display the image with ROIs overlaid so user can check them.
        imshow(BW1.*finalGreen + BW2.*finalGreen + BW3.*finalGreen + BW4.*finalGreen)

        % Save the ROI coordinates.
        save(roifilename,'xA1','xA2','yA1','yA2', 'xB1','xB2',...
            'yB1','yB2','xC1','xC2','yC1','yC2', 'xD1', 'yD1','xD2', 'yD2')
        
    % Case 2 handles the bulk series. In this case, we only define one ROI.
    
    case 2

        % Inlet ROI
        [xA1, yA1, BW1, xA2, yA2] = roipoly(composite);
        
        % Display the image with ROI overlaid so user can check it.
        imshow(BW1.*composite)

        % Save the ROI coordinates.
        save(roifilename,'xA1','xA2','yA1','yA2')

end

end

