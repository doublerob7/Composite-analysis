%% ME 4210 Composites - HW #4 - Robert Ressler

clc
clear all
format compact

%% Import the image
image = imread(which('SEM.tif'));

% Plot the histogram
figure(1)
imgHist = histogram(image);
hold on

%% Determine Threshold value

% Define manual histogram threshold values
hist_x_min = 115;
hist_x_max = 150;

% Define x array for polyfitting the dip between histogram peaks
thresh_fit_x = hist_x_min:hist_x_max;

% Fit a ploynomial to the dip, and calculate values for it with polyval
thresh_fit = polyfit(thresh_fit_x,imgHist.Values(thresh_fit_x),3);
thresh_func = polyval(thresh_fit,thresh_fit_x);

% Find the minimum of the poly fit and it's corresponding location in the
% histogram.
[minvalue,minlocation] = min(thresh_func);
threshold = minlocation + hist_x_min;

% Plot the polynomial values over the histogram
plot(thresh_fit_x,thresh_func);

%% Maximize contrast
% Define image dimensions
[height,width] = size(image);
% Preallocate memory for the processed image
proc_image = image;
% Define high and low threshold values
highthreshold = 150;
lowthreshold = 125;

% Loop over each pixel to maximize contrast.
for x = 1:width
    for y = 1:height
        %If the pixel is above the high threshold value...
        if image(y,x) > highthreshold
            %... make the value in the processed image 255
            proc_image(y,x) = 255;
        % Otherwise if the pixel value is less than the low threshold...
        elseif image(y,x) < lowthreshold
            %... make the value in the processed image 0
            proc_image(y,x) = 0;
        end
                
    end
end

%% Determine FVF
% calculate a histogram for the processed image
proc_hist = histogram(proc_image);
% grab the number of fiber pixels from the bin that includes 255
fibers = proc_hist.Values(51);
% grab the number of matrix pixels from the bin that includes 0
matrix = proc_hist.Values(1);

% Calculate fiber volume fraction. This does not include the pixels between
% the low and high thresholds, as the assumption is made that they are are
% equally ambiguous and thus equally represented in the missing data.
% Therefore they should not affect the FVF calulation.
FiberVolumeFraction = fibers/(fibers+matrix)

%% Display image with original image
% Create a new figure
figure(3)
% Create subplots and put each image into one of the slots
subplot(1,2,1), subimage(image)
subplot(1,2,2), subimage(proc_image)


