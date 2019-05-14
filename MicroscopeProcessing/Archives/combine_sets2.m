%%
for n=1:12
finalGreen = im2double(a.results{n}.GreenImages{1,end});
finalGreen = imadjust(finalGreen,a.results{n}.grnScale);

finalRed = im2double(a.results{n}.RedImages{1,2});
finalRed = imadjust(finalRed,a.results{n}.redScale);

composite = imfuse(finalGreen, finalRed, 'falsecolor');
imshow(composite)

[~, ~,bleachSpot, ~, ~] = roipoly(composite);
a.results{n}.bleachSpot = bleachSpot;
imshow(bleachSpot);
save([a.results{n}.sav 'bleachSpot'],'bleachSpot');
close all
end
%%
for n=1:12
bleachRecovery = zeros(2,n);

for t=1:length(a.results{n}.time)
    bleachRecovery(1,t) = sum(sum(imadjust(im2double(a.results{n}.GreenImages{1,t}),a.results{n}.grnScale).*a.results{n}.bleachSpot));
    bleachRecovery(2,t) = sum(sum(imadjust(im2double(a.results{n}.RedImages{1,t}),a.results{n}.redScale).*a.results{n}.bleachSpot));
    
    disp(t);
end

save([a.results{n}.sav 'bleachRecovery'],'bleachRecovery');
a.results{n}.bleachRecovery = bleachRecovery;
end

%%
for n=1:12
norm2 = (a.results{n}.bleachRecovery./a.results{n}.wholeGel)/a.results{n}.bleachWholeRatio;
save([a.results{n}.sav 'norm2'],'norm2');
a.results{n}.norm2 = norm2;
end

%%
for n=1:12
    try
    [fitresult, ~] = FRAPfitBessel(a.results{n}.time(2:end), a.results{n}.norm2(1,2:end));
    a.a(n,1) = fitresult.a;
    a.c(n,1) = fitresult.c;
    a.tau(n,1) = fitresult.tau;
    a.ci{n,1} = confint(fitresult);
    catch
    end
    try
    [fitresult, ~] = FRAPfitBessel(a.results{n}.time(2:end), a.results{n}.norm2(2,(2:end)));
    a.a(n,2) = fitresult.a;
    a.c(n,2) = fitresult.c;
    a.tau(n,2) = fitresult.tau;
    a.ci{n,2} = confint(fitresult);
    catch
    end
end

%%
a.w = zeros(12,1);
% %t12 = zeros(num,2);
a.D = zeros(12,2);
for n=1:12
    a.w(n) = (1.58)*sqrt(sum(sum(a.results{n}.bleachSpot))/pi);
    %t12 = -log(0.5).*tau;
    a.D(n,:) = a.w(n)^2./a.tau(n,:);
    %D(:,n) = 0.88.*w(n)^2./(4.*t12(:,n));
    %D(n,:) = w(n)^2./t12(n,:);
end

%%
a.dBound = (a.D(:,1)-(1-a.bProb).*a.D(:,2))./a.bProb;

%%
%%
s=;
n=2;
[fitresult, ~] = FRAPfitBessel(time{n}(s:end), norm{n}(1,s:end)); 
amp(n,1) = fitresult.a;
offset(n,1) = fitresult.c;
tau(n,1) = fitresult.tau;
ci = confint(fitresult);
%%
s=1;
n=5;
[fitresult, ~] = FRAPfitBessel(results{n}.time(s:end), results{n}.norm2(1,s:end)); 
amp(n,1) = fitresult.a;
offset(n,1) = fitresult.c;
tau(n,1) = fitresult.tau;
ci = confint(fitresult);

%%
plot(results{n}.time(s:end),results{n}.norm2(1,s:end),'o')



