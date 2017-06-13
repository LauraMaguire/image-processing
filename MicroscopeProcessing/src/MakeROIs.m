function [ ] = MakeROIs( mydata, roifilename, series )
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
imshow(composite, 'InitialMagnification',50);

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
        % Reservoir
        figure
        t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', ...
            {'Draw a polygon within the reservoir.', 'Double-click to close the polygon.'});
        t.BackgroundColor = 'w';
        t.FontSize = 18;
        [xA1, yA1, BW1, xA2, yA2] = roipoly(composite);
        close all
        
        % Accumulation area
        figure
        t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', ...
            {'Draw a polygon within the accumulation area.', 'Double-click to close the polygon.'});
        t.BackgroundColor = 'w';
        t.FontSize = 18;
        [xC1, yC1, BW3, xC2, yC2] = roipoly(composite);
        close all
        
        % Profiles
        figure
        t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', ...
            {'Click and hold to draw a horizontal slice through ',' the reservoir, gel, and accumulation area.', 'Double-click to finalize the rectangle.'});
        t.BackgroundColor = 'w';
        t.FontSize = 18;
        imshow(composite,'InitialMagnification',50);
        h = imrect;
        pos = wait(h);
        BW2 = createMask(h);
        close all
            
%         figure
%         t=annotation('textbox', [0.1,0.1,0.1,0.1],'String', ...
%             {'Draw a polygon for background subtraction.', 'Double-click to close the polygon.'});
%         t.BackgroundColor = 'w';
%         t.FontSize = 18;
%         % Background ROI
%         [xD1, yD1, BW4, xD2, yD2] = roipoly(composite);
%         close all
    

        
        % Display the image with ROIs overlaid so user can check them.
        figure
        t=annotation('textbox', [0.05,0.05,0.1,0.1],'String', ...
            {'Accept ROIs?', 'Type y or n and hit enter.'});
        t.BackgroundColor = 'w';
        t.FontSize = 18;
        imshow(BW1.*finalGreen + BW2.*finalGreen + BW3.*finalGreen,'InitialMagnification',50);% + BW4.*finalGreen)
        
        % Save the ROI coordinates.
        save(roifilename,'xA1','xA2','yA1','yA2', 'BW2',...
            'xC1','xC2','yC1','yC2');%, 'xD1', 'yD1','xD2', 'yD2')
        
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

