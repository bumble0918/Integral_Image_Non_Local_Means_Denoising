function [patchSum] = evaluateIntegralImage(iiOff, row, col, patchSize, searchWindowSize)
% This function calculates the sum over the patch centred at row, col
% of size patchSize of the integral image ii

r = patchSize;
m = searchWindowSize;
% Calculate the sum value of the current template centerend at (row,col)
% using the values from integral image 
pS = iiOff(row-r-1, col-r-1,:) + iiOff(row+r, col+r,:) ...
    - iiOff(row-r-1, col+r,:) - iiOff(row+r, col-r-1,:);
patchSum = pS(:,:); % reshape the data
end