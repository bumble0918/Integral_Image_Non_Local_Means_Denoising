close all;
clc;
patchSize = 1;
sigma = 20; % standard deviation (different for each image!)
h = 0.55; %decay parameter
searchWindowSize = 5;
%%
% Load the noisy image and its reference image 
imageNoisy_original = imread('images/alleyNoisy_sigma20.png');
imageReference = imread('images/alleyReference.png');
% Convert the data type from unit8 to double for calculation
image = double(imageNoisy_original);

tic;
%Implement the non-local means function
% Extend the image with the total radius of patch and search window
% on each side to fill the pixels for all offsets
[X,Y,Z] = size(image);
r = patchSize;
m = searchWindowSize;
imageOff = [zeros(m+r,Y+2*(m+r),Z);...
              zeros(X,m+r,Z), image(:,:,:), zeros(X,m+r,Z);...
              zeros(m+r,Y+2*(m+r),Z)];
% Generate the denoised image using Non-Local Mean method with integral image 
filtered = nonLocalMeansIntegral(imageOff, sigma, h, patchSize, searchWindowSize);
toc

%Show the denoised image
% Convert the data type back to uint8 for display
filtered = uint8(filtered);
figure('name', 'NL-Means Denoised Image');
imshow(filtered);
% Save the denoised image of its original size
% imwrite(filtered,...
%     ['N:\image processing\cw1\IntegralImagingDenoisingCoursework\denoisedImages\',...
%      '2_alleyDenoisedIntegral_sigma20_h055_patchWidth3_windowWidth11.png']);

diff_image = abs(imageNoisy_original - filtered);
figure('name', 'Difference Image');
diff_image = double(diff_image);
imshow(diff_image./ max(max((diff_image))));

%Print some statistics ((Peak) Signal-To-Noise Ratio)
disp('For Noisy Input');
[peakSNR, SNR] = psnr(imageNoisy_original, imageReference);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);

disp('For Denoised Result');
[peakSNR, SNR] = psnr(filtered, imageReference);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);

%Feel free to use some other metrics (Root
%Mean-Square Error (RMSE), Structural Similarity Index (SSI) etc.)