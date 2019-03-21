%% Make and plot initial concentration profile from Mortensen paper

% Make a vector of zeros of J0.  This determines how many terms are used
% in the solution.
j0z=besselzero(0,100,1);

% Set other parameters arbitrarily.
time=0; %this section only recreates the concentration profile at t=0.
radius=1:101; % position vector
a=100; %gel radius
D=1;
c0 = 0.2;

% initialize several arrays
numerator = zeros(length(j0z),length(radius));
denominator = zeros(length(j0z),length(radius));
decayingExp = zeros(length(j0z),1);

% termToSum stores every term for every position in the 'radius' vector
termToSum = zeros(length(j0z),length(radius));

for n=1:100
    numerator(n,:) = besselj(0,j0z(n).*radius./a);
    denominator(n,:) = j0z(n).*besselj(1,j0z(n));
    decayingExp(n) = exp(-(j0z(n))^2.*D.*time./a^2);
    
    termToSum(n,:) = numerator(n,:).*decayingExp(n)./denominator(n,:);
end

% Sum over the terms, leaving the position dependence in.
c = c0*(1-2*sum(termToSum));

% Display the initial distribution
plot(c);

%% Make and plot initial profile in my situation using Carlslaw
% Same idea, but dealing with an inner bleached circle of initial
% concentration c1 and radius b.

j0z=besselzero(0,1000,1);

time=0;
radius=1:700;
a=600;
b=205;
D=1;
c0 = 1;
c1 = 0.8;
c2 = 1;

numerator = zeros(length(j0z),1);
denominator = zeros(length(j0z),1);
decayingExp = zeros(length(j0z),1);

% defined this so the code is easier to read
eta = zeros(length(j0z),1);

rDependence = zeros(length(j0z),length(radius));
termToSum = zeros(length(j0z),length(radius));

for n=1:length(j0z)
    eta(n)=b*besselj(1,b*j0z(n)/a);
    numerator(n) = (c1-c0)*eta(n) +(c2-c0)*(a*besselj(1,j0z(n))-eta(n));
    
    denominator(n) = j0z(n).*(besselj(1,j0z(n)))^2;
    decayingExp(n) = exp(-(j0z(n))^2.*D.*time./a^2);
    
    rDependence(n,:) = besselj(0,radius.*j0z(n)./a);
    
    termToSum(n,:) = decayingExp(n).*rDependence(n,:).*numerator(n)./denominator(n);
end

c =(2/a)*sum(termToSum)+c0; % the solution in Carlslaw assumes c=0 at the gel 
% boundary, so I shifted all the concentrations while solving.  Add c0 at
% the end to put the concentrations back to the correct values.

plot(c);
xlabel('Position ($\mu$m)');


%% Make and plot time-dependent profile in my situation using Carlslaw

j0z=besselzero(0,100,1);

time=1:50;
radius=1:101;
a=100;
b=10;
D=1;
c0 = 0.5;
c1 = 0.1;
c2 = 0.2;

% initialize a profile vector for all positions and times
profile = zeros(length(time),length(radius));


% add an outer loop over all times to fill in the vector.  The inner loop
% is basically just the one from the section above
for t=1:length(time)

    numerator = zeros(length(j0z),1);
    denominator = zeros(length(j0z),1);
    decayingExp = zeros(length(j0z),1);

    eta = zeros(length(j0z),1);

    rDependence = zeros(length(j0z),length(radius));
    termToSum = zeros(length(j0z),length(radius));

    for n=1:length(j0z)
        eta(n)=b*besselj(1,b*j0z(n)/a);
        numerator(n) = (c1-c0)*eta(n) +(c2-c0)*(a*besselj(1,j0z(n))-eta(n));
    
        denominator(n) = j0z(n).*(besselj(1,j0z(n)))^2;
        decayingExp(n) = exp(-(j0z(n))^2.*D.*t./a^2);
    
        rDependence(n,:) = besselj(0,radius.*j0z(n)./a);
    
        termToSum(n,:) = decayingExp(n).*rDependence(n,:).*numerator(n)./denominator(n);
    end

    c =(2/a)*sum(termToSum)+c0;
    profile(t,:) = c;
end

plot(radius,profile);
%% Create a model FRAP recovery curve - this section doesn't work yet.
% I want to create the curve by feeding in one time vector, not
% individually summing over all times, because I'll need this form for
% curve fitting.

j0z=besselzero(0,100,1);

% am I using the wrong time scale here?
time=1e-6*(1:50);
% put the parameters in a structure this time because it's hard to keep
% track of otherwise
p.a=100;
p.b=10;
p.D=0.1;
p.c0 = 0.5;
p.c1 = 0.1;
p.c2 = 0.2;

% initialize the curve - should only depend on time
FRAPcurve = zeros(length(time),1);

% To do this, I took the average value of the concentration in the bleached
% region and divided by the average value in the gel as a whole.  I think I
% can do this by replacing the 'rDependence' term with a constant found by
% integrating over the ROI.  I might be making a math error here.

for t=1:length(time)

    numerator = zeros(length(j0z),1);
    denominator = zeros(length(j0z),1);

    eta = zeros(length(j0z),1);
    avgFactor = zeros(length(j0z),1);
    
    avgBleachSpotIntensity = zeros(length(j0z),length(time));
    avgGelIntensity = zeros(length(j0z),length(time));
    
    decayRate = zeros(length(j0z),1);
    
    for n=1:length(j0z)
        % Calculate average bleach spot intensity at time t for all terms
        eta(n)=p.b*besselj(1,p.b*j0z(n)/p.a);
        numerator(n) = (p.c1-p.c0)*eta(n) +(p.c2-p.c0)*(p.a*besselj(1,j0z(n))-eta(n));
        denominator(n) = j0z(n).*(besselj(1,j0z(n)))^2;
        % This is the 'averaging' factor for the bleach spot
        avgFactor(n) = ((2*p.a)/(j0z(n)*p.b))*besselj(1,p.b*j0z(n)/p.a);
        % avgBleachSpotIntensity is really only part of the full solution
        % but I didn't know what else to call it.
        avgBleachSpotIntensity(n) = avgFactor(n,:)*numerator(n)/denominator(n);
        
        % Calculate average gel intensity at time t for all terms 
        % This is the average factor for the whole gel
        avgFactor(n,:) = (2/j0z(n))*besselj(1,j0z(n));
        avgGelIntensity(n,:) = avgFactor(n)*numerator(n)/denominator(n);
        
        % Calculate the decay rate for each term
        decayRate(n) = (j0z(n))^2*p.D/p.a^2;
    end
    
    % This does not look right when I plot it.  Maybe my made-up input
    % parameters are the problem, or maybe it's not right
    % in principle should be the mean bleach spot intensity divided by the
    % mean gel intensity
    FRAPcurve(t) = ((2/p.a)*sum(exp(-decayRate*time(t)).*avgBleachSpotIntensity(:,t))+p.c0)./...
        ((2/p.a)*sum(exp(-decayRate*time(t)).*avgGelIntensity(:,t))+p.c0);

end

clear eta numerator denominator avgFactor n t

%%
plot(time,FRAPcurve,'o')
