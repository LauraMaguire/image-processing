function [fitString,fitresult, gof] = numericalBesselFit(data, inputFitString)

% time = data.time(2:end);
% y = data.norm(1,2:end) - data.norm(1,2);
% y = y/y(end);
time = data.time(2:end);
y = data.norm(1,2:end);

if nargin==2
    disp('Fit string passed in as argument');
    fitString = inputFitString;
else
    fitString = generateFitString(data.greenImage, data.bleachSpot, ...
        data.cosArray, data.sinArray, data.rmax, data.x, data.y);
end

[xData, yData] = prepareCurveData( time, y );

% Set up fittype and options.
ft = fittype( fitString, 'independent', 't', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.Lower = [0]; % D only
% opts.Upper = [data.D(1)];
% opts.StartPoint =[data.D(1)]; % D only
opts.Lower = [0 -Inf -Inf]; % D c1 c2
%opts.Upper = [data.D(1)];
opts.StartPoint =[data.D(1) 1 0]; % D c1 c2
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'FRAP fit' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. time', 'FRAP fit', 'Location', 'NorthWest' );
% Label axes
xlabel time
ylabel('y')
grid on

end