function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(row,...
    col, imageOff, X, Y, patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsX(1) = -1;
% offsetsY(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

% This time, use the integral image method!
% Use the 'computeIntegralImage' function developed earlier to
% calculate integral images
% Use the 'evaluateIntegralImage' function to calculate patch sums

% Compute the integral image for the distances of all pixels in the image
% with their corresponding pixels of each offset
r = patchSize;
m = searchWindowSize;
% Compute integral images for all possible offsets in the search window
k = 0;
ii = zeros(X+2*r,Y+2*r,(2*m+1)^2);
offsetsRows = zeros((2*m+1)^2,1);
offsetsCols = zeros((2*m+1)^2,1);
for offR = -m : m 
    for offC = -m : m
        k = k + 1; % the total number of offsets
        % the distance matrix for all pixels in the image
        % and extend with the radius of patch on each side
        d = imageOff(m+1:m+r+X+r,m+1:m+r+Y+r,:) - ...
            imageOff(m+1+offR : m+r+X+r+offR, m+1+offC : m+r+Y+r+offC,:);
        d = d.^2; % Squared distances
        % Compute the integral images for the distance matrix
        % and store all images in one 3D matrix for faster computation
        ii(:,:,k) = computeIntegralImage(d); 
    end
end
K = (2*m+1)^2;
% Extend the integral image with the radis of search window on each side
ii = [zeros(m,Y+2*(m+r),K);...
      zeros(X+2*r,m,K), ii(:,:,:), zeros(X+2*r,m,K);...
      zeros(m,Y+2*(m+r),K)];
  
% Calculate the sum of squared distances in each template using integral image  
distances = evaluateIntegralImage(ii, row, col, patchSize, searchWindowSize);

end