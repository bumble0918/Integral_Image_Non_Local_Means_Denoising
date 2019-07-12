close all;
clc;

row = 100;% location of the template
col = 100;
patchSize = 2;
searchWindowSize = 8;

%% Implementation of basic section-------------------

% Load Image
image = imread('images/debug/alleyNoisy_sigma20.png');
% Test with the grayscale version
image = rgb2gray(image);
% Convert uint8 data to double for calculation
image = double(image);

% Fill out this function
% Compute the integral image for the original image 
% to test the computeIntegralImage function
image_ii = computeIntegralImage(image);

% Display the normalised Integral Image
figure('name', 'Normalised Integral Image');
imshow(image_ii,[]);

% Extend the image with the total radius of patch and search window
% on each side to fill the pixels for all offsets
[X,Y,Z] = size(image);
r = patchSize;
m = searchWindowSize;
imageOff = [zeros(m+r,Y+2*(m+r),Z);...
            zeros(X,m+r,Z), image(:,:,:), zeros(X,m+r,Z);...
            zeros(m+r,Y+2*(m+r),Z)];

% Template matching for naive SSD (just loop and sum)
% the input image, row and column are after extended
% so the original row and coloumn can be used in the function
[offsetsRows_naive, offsetsCols_naive, distances_naive] = templateMatchingNaive(row+m+r, col+m+r,...
    imageOff, patchSize, searchWindowSize);

% Template matching using integral images
% the input image, row and column are after extended
% so the original row and coloumn can be used in the function
[offsetsRows_ii, offsetsCols_ii, distances_ii] = templateMatchingIntegralImage(row+m+r, col+m+r,...
    imageOff, X, Y, patchSize, searchWindowSize);

%% Print out results--------------------------------------------
% The naive and the integral image method have the same results
for i=1:length(offsetsRows_naive)
    disp(['offset rows: ', num2str(offsetsRows_naive(i)), '; offset cols: ',...
        num2str(offsetsCols_naive(i)), '; Naive Distance = ', num2str(distances_naive(i),10),...
        '; Integral Im Distance = ', num2str(distances_ii(i),10)]);
end