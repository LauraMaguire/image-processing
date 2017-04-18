%%

%% Only run this once!
dyeFraction = zeros(2, length(expFile));
tauDye = zeros(2, length(expFile));
tau = zeros(2, length(expFile));
GOF = zeros(10,length(expFile));

%%
for i=44:50
    %close all
    greenOutlet = data{i}.outlet(1,:)./data{i}.inlet(1,:);
    time = data{i}.time;
    [fitresult, gof] = createDoubleFit(time, greenOutlet);
    dyeFraction(1,i) = min(fitresult.c, 1 - fitresult.c);
    GOF(1,i) = gof.sse;
    GOF(2,i) = gof.rsquare;
    GOF(3,i) = gof.dfe;
    GOF(4,i) = gof.adjrsquare;
    GOF(5,i) = gof.rmse;
    if abs(dyeFraction(i)-fitresult.c) < 0.01
        tauDye(1,i) = fitresult.tau1;
        tau(1,i) = fitresult.tau2;
    else
        tauDye(1,i) = fitresult.tau2;
        tau(1,i) = fitresult.tau1;
    end
    saveas(gcf,[ 'Z:\Processed Images\Analysis\FSFG dataset\two-exponent-green\fig' num2str(i)],'jpg');
    display(num2str(i/length(expFile)));
end

%%
for i=44:50
    %close all
    redOutlet = data{i}.outlet(2,:)./data{i}.inlet(2,:);
    time = data{i}.time;
    [fitresult, gof] = createDoubleFit(time, redOutlet);
    dyeFraction(1,i) = min(fitresult.c, 1 - fitresult.c);
    GOF(6,i) = gof.sse;
    GOF(7,i) = gof.rsquare;
    GOF(8,i) = gof.dfe;
    GOF(9,i) = gof.adjrsquare;
    GOF(10,i) = gof.rmse;
    if abs(dyeFraction(i)-fitresult.c) < 0.01
        tauDye(1,i) = fitresult.tau1;
        tau(1,i) = fitresult.tau2;
    else
        tauDye(1,i) = fitresult.tau2;
        tau(1,i) = fitresult.tau1;
    end
    saveas(gcf,[ 'Z:\Processed Images\Analysis\FSFG dataset\two-exponent-red\fig' num2str(i)],'jpg');
    display(num2str(i/length(expFile)));
end


%%
greenOutlet = data{13}.outlet(1,:)./data{13}.inlet(1,:);
time = data{13}.time;

[fitresult, gof] = createDoubleFit(time, greenOutlet);

%%
dyeFraction(1,31) = 1-fitresult.c;
dyeTau(1,31) = fitresult.tau2;
tau(1,31) = fitresult.tau1;
    GOF(1,31) = gof.sse;
    GOF(7,31) = gof.rsquare;
    GOF(8,31) = gof.dfe;
    GOF(9,31) = gof.adjrsquare;
    GOF(10,31) = gof.rmse;

%%
plot(GOF(1,1:8), 'bo')

%%
bad = [9,11,12,13,14,18,19,20,30,31,33,34,35,36,38,39,40,41,42,43];
hopeless = [5,9,14,17,19,20,31];
good = [1,2,3,4,6,7,8,10,15,16,17,21,22,23,24,25,26,27,28,29,32,37];
dyefit = 5;
dubiousGels = [9,14,17,19,20];
fo = [15,16,23,24,25,26,28,29,31,33,34,36];

okay = [1,2,3,4,6,7,8,10,11,12,13,15,16,18,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49];
%%
close all
figure
hold on
plot(gelWidths(1,okay),tauDye(okay),'bo');
xlabel('Mean gel width (um)');
ylabel('Dye lifetime (min)');
title('Dye lifetime vs. gel width');
hold off

figure
hold on
plot(gelWidths(1,okay),tau(okay),'ro');
xlabel('Mean gel width (um)');
ylabel('Protein lifetime (min)');
title('Protein lifetime vs. gel width');
hold off


figure
hold on
plot(gelWidths(1,okay),dyeFraction(okay),'go');
xlabel('Mean gel width (um)');
ylabel('Dye fraction');
title('Dye fraction vs. gel width');
hold off

