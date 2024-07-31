clc, clear , close all;

I = imread("DRIVE-DataSet\Test\images\01_test.tif");
mask = imread("DRIVE-DataSet\Test\mask\01_test_mask.gif");
manual = imread("DRIVE-DataSet\Test\1st_manual\01_manual1.gif");

manual = imbinarize(manual);


mask = imbinarize(mask);
image = I .* uint8(mask);


% extracting the green channel of the image because its show the blood vessel
% better
green = image(:,:,2);
gray_image= green;

double_image = im2double(gray_image);

% enhance the image brightness level using adaptive histogram equalization 
% the below function divides the image into 8x8 segment and enhance the
% brightness level based on the local histogram
enhanced_image = adapthisteq(double_image,'numTiles',[8,8],'nBins',512,'Distribution','uniform');




%% using linear structuring element enhance the linear object like vessels

% this block of code is minimizing the unlinear objects using open
% morphology operation and that enhance the linear objects like the vessels
tetha = linspace(0,180,13);
tetha(end) = [];
structuring_element = strel('line',7,tetha(1));
highlighted_image = imopen(enhanced_image,structuring_element);
for i= 2:numel(tetha)
    structuring_element = strel('line',7,tetha(i));
    temp = imopen(enhanced_image, structuring_element);
    highlighted_image = max(highlighted_image, temp);
end 


%% the below block of code extract the vessels (with noise)
% first its get the enhances blood vessel objects and then blur out the
% image, by bluring out the image the images the vessels get more spread to
% its nighbors so when substracticting the blured image by the smoothed
% image we get the bounderies of the objects (blood vessels more because we
% enhanced them before)
smoothed_image= highlighted_image;
average_filter = fspecial('average',[9,9]);
averaged_image = imfilter(highlighted_image, average_filter);
final_image = imsubtract(averaged_image, smoothed_image);

% remove the ring around the image using the mask
% I did erosin on the image mask so it get smaller and when masking again
% the ring inside the circle will be removed
SE = strel('disk', 4);
mask = imerode(mask, SE);
final_image = final_image.*double(mask);
% binarize the image
final_image = imbinarize(final_image, 0.01);


%% remove the noise, and filling the gaps
removed_noise = remove_noise(final_image, 100);
% imshow(opened_image)
result_image = bwmorph(removed_noise,'majority');

%% thicking the vessels using morphology dilatation
SE = strel('disk', 1);
result_image = imdilate(result_image, SE);
result_image = remove_noise(result_image, 100);


%% calculating the sensitivity, specificity and accuracy, and showing the final results
verify(manual, result_image);




imshow(result_image)
