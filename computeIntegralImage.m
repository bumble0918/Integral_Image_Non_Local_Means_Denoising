function [ii] = computeIntegralImage(image)

% Using recurrence relation to calculate the integral image
[X,Y]=size(image);
s = zeros(X,Y);
ii = zeros(X,Y);
% calculate the column-wise cummulative sum
s(:,1) = image(:,1);
for y = 2:Y
        s(:,y) = s(:,y-1) + image(:,y);
end
% calculate the integral image 
ii(1,:) = s(1,:);
for x = 2:X
    for y = 1:Y
        ii(x,y) = ii(x-1,y) + s(x,y);
    end
end

end