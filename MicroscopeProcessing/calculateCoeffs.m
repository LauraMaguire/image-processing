function [cosArray, sinArray, rmax] = calculateCoeffs(image, mask, numTerms, numZeros)
tic
x=1.58*(-size(image,1)/2:size(image,1)/2-1);
y=1.58*(-size(image,2)/2:size(image,2)/2-1);

r = zeros(size(image));
theta = zeros(size(image));
rmax = zeros(length(x),1);

for i = 1:length(x)
    rmax(i) = nnz(mask(i,:));
    r(i,:) = sqrt(x(i)^2+y.^2);
    %theta(i,:) = atan(y./x(i))+pi/2;
end

for i=1:length(x)
    for j = 1:length(y)
        theta(i,j) = atan2(x(i),y(j))+pi;
    end
end
theta(size(image,1)/2+1,size(image,2)/2+1) = 0;

rmax = 1.58*max(rmax)/2;

%jn = zeros(size(image));

cosArray = zeros(numTerms,numZeros);
sinArray = zeros(numTerms,numZeros);

% fill in several terms so they don't have to get called so often
alpha = zeros(numTerms,numZeros);
cosine = zeros(numTerms,size(image,1),size(image,2));
sine = zeros(numTerms,size(image,1),size(image,2));
for n=1:numTerms
    besselOrder = (n-1)-floor(numTerms/2);
    alpha(n,:) = besselzero(besselOrder,numZeros,1)/rmax;
    cosine(n,:,:) = cos(besselOrder.*theta);
    sine(n,:,:) = sin(besselOrder.*theta);
end

parfor n=1:numTerms
    besselOrder = (n-1)-floor(numTerms/2);
    
    for a=1:numZeros
        jn = (besselj(besselOrder,alpha(n,a).*r));
%         for i = 1:length(x)
%             for j = 1:length(y)
% %                 if besselOrder<0; jn(i,j) = (-1)^besselOrder*...
% %                         real(besselj(abs(besselOrder),alpha(a)*r(i,j)));
% %                 else; jn(i,j) = besselj(besselOrder,alpha(a)*r(i,j));
% %                 end
%                 %jn(i,j) = real(besselj(besselOrder,alpha(n,a)*r(i,j)));
%             end        
%         end
       
        integrandCos = mask.*image.*jn.*squeeze(cosine(n,:,:)).*r;
        integrandSin = mask.*image.*jn.*squeeze(sine(n,:,:)).*r;
        
%         integrandCos(size(image,1)/2+1,size(image,2)/2+1) = 0;
%         integrandSin(size(image,1)/2+1,size(image,2)/2+1) = 0;

        cosArray(n,a) = sum(sum(integrandCos));
        sinArray(n,a) = sum(sum(integrandSin));
        
        disp(['Finished zero number ' num2str(a) ' of ' num2str(numZeros)]);
    end
    disp(['Finished ' num2str(n) ' of ' num2str(numTerms) ' terms.']);
    disp(['Finished Bessel order ' num2str((n-1)-numTerms/2) '.']);
end

toc
end