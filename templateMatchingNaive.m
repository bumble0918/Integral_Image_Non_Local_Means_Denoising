function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(row, col,...
    imageOff,patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

r = patchSize;
m = searchWindowSize;

% Locate the patch for the current row and column
patch = imageOff(row-r : row+r, col-r : col+r,:);
offsetsRows = zeros((2*m+1)^2,1);
offsetsCols = zeros((2*m+1)^2,1);
distances = zeros(1,(2*m+1)^2);
k = 0;
for offR = -m : m
    for offC = -m : m
        k = k + 1; % the total number of offsets
        offsetsRows(k) = offR; % offset in row
        offsetsCols(k) = offC; % offset in column
        % Locate the template for the current offset
        temp = imageOff(row+offR-r : row+offR+r, col+offC-r : col+offC+r,:);
        % Calculate the squared differences
        d = (temp - patch).^2;
        % Sum of squared differences (SSD)
        distances(k) = sum(d(:));
    end
end
distances = transpose(distances); % reshape to get identical size
end