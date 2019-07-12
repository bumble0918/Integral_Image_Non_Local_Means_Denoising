function [result] = nonLocalMeansIntegral(imageOff, sigma, h, patchSize, searchWindowSize)

r = patchSize;
m = searchWindowSize;
[x,y,z] = size(imageOff);
% extract the size of the original image 
image = imageOff(m+r+1:x-m-r,m+r+1:y-m-r,:);
[X,Y,Z] = size(image);
result = zeros(size(image));
% Compute integral images for all possible offsets in the search window
ii = zeros(X+2*r,Y+2*r,(2*m+1)^2);
k = 0;
for offR = -m : m
    for offC = -m : m
        k = k + 1; % the total number of offset
        % the distance matrix for all pixels in the image
        % and extend with the radius of patch on each side
        d = imageOff(m+1:m+r+X+r,m+1:m+r+Y+r,:) - ...
            imageOff(m+1+offR : m+r+X+r+offR, m+1+offC : m+r+Y+r+offC,:);
        d = d.^2; % Squared distances
        % Add the distances in each channel(R,G and B) together
        D = sum(d,3); 
        % Compute the integral images for the distance matrix
        % and store all images in one 3D matrix for faster computation
        ii(:,:,k) = computeIntegralImage(D);    
    end
end
K = (2*m+1)^2;
% Extend the integral image with the radis of search window on each side
ii = [zeros(m,Y+2*(m+r),K);...
      zeros(X+2*r,m,K), ii(:,:,:), zeros(X+2*r,m,K);...
      zeros(m,Y+2*(m+r),K)];

% Loop and compute the new pixel value for the whole image
for row = 1:X
    for col = 1:Y
        % Calculate the sum of squared distances in each template using integral image 
        distances = evaluateIntegralImage(ii, row+m+r, col+m+r, ...
                                          patchSize, searchWindowSize);
        % Normalise the distances, divide it by 3 (RGB channels) and the
        % total pixel number in one patch
        distances = distances / (3*(2*r+1)^2);
        % Calculate weight depending on the distance value
        w = computeWeighting(distances, h, sigma, patchSize, searchWindowSize);
        % Calculte distributions of the new pixel value in RGB channels
        % seperately using the product of its neighbour pixels inside the
        % search window and their weight
        weightedP(:,:,1) = imageOff(m+r+row-m : m+r+row+m, ...
                    m+r+col-m : m+r+col+m, 1) .* w; 
        weightedP(:,:,2) = imageOff(m+r+row-m : m+r+row+m, ...
                    m+r+col-m : m+r+col+m, 2) .* w;
        weightedP(:,:,3) = imageOff(m+r+row-m : m+r+row+m, ...
                    m+r+col-m : m+r+col+m, 3) .* w;
        % Calculte the new pixel value in RGB channels seperately by 
        % dividing the sum of all distributions by the sum of all weights        
        result(row,col,1) =  sum(sum(weightedP(:,:,1)))/ sum(w(:));
        result(row,col,2) =  sum(sum(weightedP(:,:,2)))/ sum(w(:));
        result(row,col,3) =  sum(sum(weightedP(:,:,3)))/ sum(w(:));
    end
end

end