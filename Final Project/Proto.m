image = imread('maple.jpg');
image = edge(image(:,:,1), 'Canny', 0.09);
imshow(image);
image = imcomplement(image)

CC = bwconncomp(image)

numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);

image(CC.PixelIdxList{idx}) = 1;

image = imcomplement(image)

imshow(image)

