for n=1:length(folders)
    disp('loading')
    r = load(['/Volumes/houghgrp/Processed Images/20' folders{n} '/results.mat']);
    disp('loaded')
    data{n}.greenImage = r.GreenImages{2};
    data{n}.redImage = r.RedImages{2};
    disp(n);
end
%%
for n=1:length(folders)
    tic
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
    refMask = wholeMask-bleachMask;
    ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    image2 = image-ref;
    %imagesc(image2)
    
    [cosArray, sinArray, rmax] = calculateCoeffs(image2, wholeMask, 10, 10);
    data{n}.cosArray = cosArray;
    data{n}.sinArray = sinArray;
    data{n}.rmax = rmax;
    disp(n)
    toc
end
%%
for n=44:length(folders)
    tic
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
%     refMask = wholeMask-bleachMask;
%     ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    %image2 = image-ref;
    %imagesc(image2)
    if exist('data{n}.D')
    [recoveryCurve]=simulateData(image,bleachMask,data{n}.cosArray,...
        data{n}.sinArray,data{n}.rmax,data{n}.time,data{n}.D(1));
    data{n}.recoveryCurve = recoveryCurve;
    end

    disp(n)
    toc
end

for n=1:length(folders)
    tic
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
%     refMask = wholeMask-bleachMask;
%     ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    %image2 = image-ref;
    %imagesc(image2)
    
    [initialDistribution] = calcInitDist(image, wholeMask, data{n}.cosArray, data{n}.sinArray);

    data{n}.initialDistribution = initialDistribution;
    disp(n)
    toc
end

%%
r = cell(1,length(data));
e = cell(1,length(data));
for n=1:length(data)
    try
    r{n} = data{n}.recoveryCurve - data{n}.recoveryCurve(1);
    r{n} = r{n}/max(r{n});
    e{n} = data{n}.norm(1,:) - data{n}.norm(1,2);
    e{n} = e{n}/(e{n}(end));
    figure
    plot(data{n}.time,r{n});
    hold on
    %figure
    plot(data{n}.time(2:end),e{n}(2:end),'o');
    hold off
    catch
    end
end
%%
for n=1:length(data)
    figure
    imagesc(data{n}.initialDistribution);
end
%%
for n=1:length(data)
    [fitString,fitresult,gof] = numericalBesselFit(data{n});
end