function [result] = nonLocalMeansNaive(imageOff, sigma, h, patchSize, searchWindowSize)

r = patchSize;
m = searchWindowSize;
[x,y,z] = size(imageOff);
% extract the size of the original image 
image = imageOff(m+r+1:x-m-r,m+r+1:y-m-r,:);
[X,Y,Z] = size(image);
result = zeros(size(image));

% Loop and compute the new pixel value for the whole image
for row = 1:X
    for col = 1:Y
        % Calculate the sum of squared distances in each template
        [offR, offC, distances] = templateMatchingNaive(row+m+r, col+m+r,...
                                   imageOff, patchSize, searchWindowSize);
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