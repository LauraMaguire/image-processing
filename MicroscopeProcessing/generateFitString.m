function [fitString] = generateFitString(image, gelMask, cosArray, sinArray, rmax)

x=1.58*(-size(image,1)/2:size(image,1)/2-1);
y=1.58*(-size(image,2)/2:size(image,2)/2-1);

numTerms = size(cosArray,1);
numZeros = size(cosArray,2);

r = zeros(size(image));
theta = zeros(size(image));

fitString = '1-(0';
normalization = 0;

for i = 1:length(x)
    r(i,:) = sqrt(x(i)^2+y.^2);
end

for i=1:length(x)
    for j = 1:length(y)
        theta(i,j) = atan2(x(i),y(j))+pi;
    end
end
theta(size(image,1)/2+1,size(image,2)/2+1) = 0;


% fill in several terms so they don't have to get called so often
alpha = zeros(numTerms,numZeros);
cosine = zeros(numTerms,size(image,1),size(image,2));
sine = zeros(numTerms,size(image,1),size(image,2));
jnprimeSq = zeros(numTerms,numZeros);
for n=1:numTerms
    besselOrder = (n-1)-floor(numTerms/2);
    alpha(n,:) = besselzero(besselOrder,numZeros,1)/rmax;
    cosine(n,:,:) = cos(besselOrder.*theta);
    sine(n,:,:) = sin(besselOrder.*theta);
    for a=1:numZeros
        jnprimeSq(n,a) = (0.5*real(besselj(besselOrder-1,alpha(n,a)*rmax)...
                -besselj(besselOrder+1,alpha(n,a)*rmax)))^2;  
    end
end


jn = zeros(size(image));
%for t=1:length(time)
    for n=1:numTerms
        besselOrder = (n-1)-floor(numTerms/2);
        for a=1:numZeros
            for i = 1:length(x)
                for j = 1:length(y)
                    if gelMask(i,j)
                        jn(i,j) = real(besselj(besselOrder,alpha(n,a)*r(i,j))); 
                    end % end if statement
                end % end j
            end % end i
            termCos = sum(sum(squeeze(cosine(n,:,:)).*cosArray(n,a).*jn./jnprimeSq(n,a)));
            termSin = sum(sum(squeeze(sine(n,:,:)).*sinArray(n,a).*jn./jnprimeSq(n,a)));
            termTotStrg = num2str(termCos+termSin);
            fitString = [fitString '+(' termTotStrg ')*exp(-D*' ...
                num2str(alpha(n,a)^2) '*t)'];
            normalization = normalization + (termCos+termSin);
            disp(['Finished zero number ' num2str(a) ' of ' num2str(numZeros)]);
        end %end a
        disp(['Finished ' num2str(n) ' of ' num2str(numTerms) ' terms.']);
        disp(['Finished Bessel order ' num2str((n-1)-numTerms/2) '.']);
    end % end n
%end %end t
fitString = [fitString ')/' num2str(normalization)];
end