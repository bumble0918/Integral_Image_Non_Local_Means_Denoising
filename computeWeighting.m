function [result] = computeWeighting(d, h, sigma, patchSize, searchWindowSize)
    %Implement weighting function
    
    r = patchSize;
    m = searchWindowSize;
    % width of search window
    R = 2 * m + 1;
    % compute weight parameter to constrain which pixel to keep
    result = exp( - max(d - 2 * sigma^2,0) / h^2);
    % reshape the weight parameter to the search window shape
    result = transpose(reshape(result,[R,R]));
end