
data = bfopen('/Volumes/houghgrp/Microscopy/mucus/181012/181012-mucus__current_3.vsi');

 %%
images = data{1,1};

BFImages = images(1:2:length(images));
RedImages = images(2:2:length(images));
%%
inflow = cell(7,1);
bfin = cell(7,1);
for i=9:15
    inflow{i-8} = RedImages{i};
    bfin{i-8} = BFImages{i};
end

%%
intermission = cell(3,1);
for i=1:3
    intermission{i} = zeros(1024,1344);
end

%%
outflow = cell(102,1);
bfout = cell(102,1);
for i=19:120
    outflow{i-18} = RedImages{i};
    bfout{i-18} = BFImages{i};
end

%%
dataCut = vertcat(inflow, intermission, outflow);
bfdata = vertcat(bfin, intermission, bfout);

%%
ar = bfdata(:).';    % make sure ar is a row vector
br = dataCut(:).';    % make sure br is a row vector
A = [ar;br];   % concatenate them vertically
dataFinal = cell(2,4);
dataFinal{1,1} = A(:);      % flatten the result

%%
data2 = bfopen('/Volumes/houghgrp/Microscopy/mucus/181012/181012-mucus__current_3.vsi');
%%
ListOfImages = data2{1,1};
GreenImages = ListOfImages(1:2:length(ListOfImages));
RedImages = ListOfImages(2:2:length(ListOfImages));

%%
ListOfImagesf = dataFinal{1,1};
GreenImagesf = ListOfImages(1:2:length(ListOfImagesf));
RedImagesf = ListOfImages(2:2:length(ListOfImagesf));