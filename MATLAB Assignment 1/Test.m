image = imread('me.tif');
image = rgb2gray(image(:,:,1:3));

BW = edge(image, 'Canny', 0.15)
image = image + (30*BW)
imshow(image)