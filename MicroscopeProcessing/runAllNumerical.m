for n=1:length(folders)
    disp('loading')
    r = load(['/Volumes/houghgrp/Processed Images/20' folders{n} '/results.mat']);
    disp('loaded')
    data{n}.greenImage = r.GreenImages{2};
    data{n}.redImage = r.RedImages{2};
    disp(n);
end
%%
for n=1:1%length(folders)
    tic
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
    refMask = wholeMask-bleachMask;
    ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    image2 = image-ref;
    %imagesc(image2)
    
    [cosArray2, sinArray2, rmax2] = calculateCoeffs(image2, wholeMask, 10, 10);
%     data{n}.cosArray = cosArray;
%     data{n}.sinArray = sinArray;
%     data{n}.rmax = rmax;
    disp(n)
    toc
end
%%
for n=2:43%length(folders)
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
%     refMask = wholeMask-bleachMask;
%     ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    %image2 = image-ref;
    %imagesc(image2)
    %if exist(['data{' num2str(n) '}.D'])
    recoveryCurve=simulateData(image,bleachMask,data{n}.cosArray,...
        data{n}.sinArray,data{n}.rmax,data{n}.time,data{n}.D(1));
    data{n}.recoveryCurve = recoveryCurve;
    %end

    disp(n)
end
%%
for n=1:1%length(data)
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
%     refMask = wholeMask-bleachMask;
%     ref = sum(sum(image.*refMask))/sum(sum(refMask));
    
    %image2 = image-ref;
    %imagesc(image2)
    
    [initialDistribution2] = calcInitDist(image, wholeMask, cosArray2, sinArray2);

    %data{n}.initialDistribution = initialDistribution;
    disp(n)
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
for n=12:43
    [fitString,fitresult,gof] = numericalBesselFit(data{n});
    data{n}.fitstring = fitString;
    data{n}.numFit = fitresult;
    data{n}.numGOF = gof;
    disp(n);
end

%% show all results
for n=12:43
    test = data{n}.norm(1,:)-data{n}.norm(1,2);
    test = test/test(end);
    test = test(2:end);
    rec = data{n}.recoveryCurve-data{n}.recoveryCurve(1);
    rec = rec/rec(end);
    
    figure
    hold on
    plot(data{n}.time(2:end),test,'o');
    plot(data{n}.time,rec);
    str = ['Exp ' num2str(n) ', old D = ' num2str(data{n}.D(1)) ];
    annotation('textbox',[.2 .5 .3 .3],'String',str,'FitBoxToText','on');
    [~,fitresult,~] = numericalBesselFit(data{n}, data{n}.fitstring);
    str = ['Exp ' num2str(n) ', fit D = ' num2str(fitresult.D) ];
    annotation('textbox',[.2 .5 .3 .3],'String',str,'FitBoxToText','on');
    hold off
end

%%
for n=1:51
    rec = data2{n}.initialDistribution/max(max(data2{n}.initialDistribution));
    image = double(data{n}.greenImage);
    wholeMask = data{n}.gelMask;
    bleachMask = data{n}.bleachSpot;
    refMask = wholeMask-bleachMask;
    ref = sum(sum(image.*refMask))/sum(sum(refMask));
    image2 = image-ref;
    image2 = image2/max(max(image2));
    
    err(n) = sum(sum((rec-image2).^2));
    
    figure
    subplot(1,2,1)
    imagesc(image2.*wholeMask);
    subplot(1,2,2)
    imagesc(rec)
end
%%
semilogy(err,'o');

%%
for n=1:length(data)
[data{n}.x,data{n}.y] = findCenter(data{n}.gelMask);
disp([num2str(n) ' ' num2str(data{n}.x) ' ' num2str(data{n}.y)]);
figure
imshow(data{n}.gelMask);
viscircles([data{n}.x,data{n}.y],5);
end

%%
for n=1:10
    N = size(data{n}.greenImage,1);
    M = size(data{n}.greenImage,2);
    r = zeros(N,M);
%     x= 1.58*[-fliplr(1:data{n}.y) 0 1:(N-floor(data{n}.y)-1)];
%     y= 1.58*[-fliplr(1:data{n}.x) 0 1:(M-floor(data{n}.x)-1)];
    y= 1.58*[-fliplr(1:data{n}.y) 0 1:(N-floor(data{n}.y)-1)];
    x= 1.58*[-fliplr(1:data{n}.x) 0 1:(M-floor(data{n}.x)-1)];

    for i = 1:length(y)
        r(i,:) = sqrt(y(i)^2+x.^2);   
    end
    figure
%     imagesc(r.*data{n}.gelMask)
    imshow((r.*data{n}.gelMask)/max(max(r)));
    viscircles([data{n}.x,data{n}.y],5);
end

