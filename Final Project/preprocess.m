function binary = preprocess(filename)
% takes a filename of a leaf image, returns binary mask of leaf (with stem removed?)
image = imread(filename);



image = imcomplement(image(:,:,2));

% imshow(image)

BW = imbinarize(image, 0.10);
BW = bwareaopen(BW, 500);
BW = imfill(BW, 'holes');

% extract leaf shape from image (find most central connected component)
regions = regionprops(BW, 'centroid');

middle = [ceil(size(BW, 1)/2) ceil(size(BW, 2)/2)];
distances = zeros(size(regions, 1),1);

for i = 1:size(regions);
   distances(i) = norm(regions(i).Centroid - middle);  % find closest centroid to image center
end

[~, leaf_index] = min(distances);     % Assume that leaf is the most central

components = bwconncomp(BW);

BW(:,:) = 0;   % reset binary mask

BW(components.PixelIdxList{leaf_index}) = 1;     % only include leaf

leaf_props = regionprops((BW), 'orientation');
BW = imrotate(BW, 90-leaf_props(1).Orientation);

% imshow(BW)

binary = BW;        % returns a veritcally-oriented binary image

end