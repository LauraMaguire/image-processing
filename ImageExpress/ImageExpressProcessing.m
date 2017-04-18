%% Combine tifs from ImageExpress experiment
% Run this script after the initial processing script
% "ImageExpressReorganizer."  This script rearranges the output of the
% reorganizer script, assuming there are four images for each well for each
% timepoint.  The concatenated tifs are stored in folders named for the
% wells.  Plate layout and spacer details may need to be ajusted each time.

% Full file path to the reorganized data
base = 'C:\Users\Laura\Desktop\FG124 ImageExpress\Laura Maguire\2017-03-10\4488\well ';
% Full file path to the output folder
savename = 'C:\Users\Laura\Desktop\Processed_image_express';
% spacers for concatenating the tifs - may need to adjust
spacer1 = ones(4320+216,216);
spacer2 = ones(216,2160);
for a=65:71 %HTML code for A,B,C,D,E,F - may need to adjust
    for w=1:8 %may need to adjust
        newfolder = ['well' a sprintf('%.2d', w)];
        s = mkdir(savename, newfolder);
        for t=1:100 %may need to adjust
            im = cell(1,4);
            for i=1:4
                file = [base a sprintf('%.2d', w) '\site ' num2str(i) ' t' sprintf('%.2d', t) '.tif'];
                try
                    im{i} = imread(file);
                catch
                    warning('Image does not exist');
                    im{i} = ones(2160,2160);
                end
            end
            large_image = cat(2, cat(1, im{1},spacer2, im{3}), spacer1, cat(1,im{2},spacer2 ,im{4}));
            imshow(large_image);
            saveas(gcf, [savename '\' 'well' a sprintf('%.2d', w) '\t' sprintf('%.2d', t) '.tif']);
        end
    end
end

%% Create movies for all wells
savename = 'C:\Users\Laura\Desktop\Processed_image_express';
for a=65:70 %HTML code for A,B,C,D,E,F
    for w=1:8
        newfolder = ['well' a sprintf('%.2d', w)];
        mov = VideoWriter([savename '\' newfolder]);
        mov.FrameRate = 10;
        open(mov)
        for t=1:100
            im = imread([savename '\' newfolder '\t' sprintf('%.2d', t) '.tif']);
            imshow(im)
            F = getframe(gcf);
            writeVideo(mov,F);
        end
        close(mov)
        clear mov
    end
end
