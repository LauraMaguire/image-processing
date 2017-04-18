%% PLOT MAXIMUM INTENSITY
% LKM 1/26/16

% This script uses a saved workspace and plots the maximum intensity within
% the gel over time.  Make sure the profiles have the inlet on the left
% before running.  Input: An estimation of the boundary between inlet and
% gel, in um (to avoid cases where the inlet is the max intensity).

%% USER INPUT

% Estimate the position (in um) of the boundary between inlet and gel.
% Inlet must be on left!
edge = 500;

%% Make vector of max intensity

% Convert from position in um to index along position vector
index = floor(edge/xscale);

% Find the non-normalized maximum
rawMaxG = max(kymo_green(:,index:end),[],2);
rawMaxR = max(kymo_red(:,index:end),[],2);

% Normalize continuously to the inlet
maxG = rawMaxG./transpose(inlet(1,:));
maxR = rawMaxR./transpose(inlet(2,:));

%% Plot of max intensity vs. time:
figure
plot(time(1:220), maxG(1:220),'g-')
hold all
plot(time(1:220), maxR(1:220),'r-')
title(['Max intensity vs time (', gelNotes, ')'])
legend('Alexa488','mCherry','Location','east')
xlabel('Time (minutes)')
ylabel('Max intensity (normalized cont. to inlet)')
%ylabel('Intensity normalized to initial inlet')
annotation('textbox', [0.2,0.5,0.1,0.1],'String', {date, note1, note2})

%% Tidy the workspace
clear rawMaxG rawMaxR maxG maxR edge index