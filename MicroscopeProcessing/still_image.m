    imageg = imadjust(im2double(GreenImages{1,2}),grnScale);
    imager = imadjust(im2double(RedImages{1,2}),redScale);
    imageb = zeros(size(imager));
    image = cat(3,imager,imageg,imageb);
    % Display the image as a figure.
    imshow(image, 'InitialMagnification',50);