function cleaned  = preprocess(image)

level = graythresh(image);   % Compute threshold for skull removal
BW = imbinarize(image,level);   % build binary mask

CC = bwconncomp(BW);             
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;       % remove the largest connected component                  
BW = imcomplement(BW);              % invert binary mask

BW = bwareaopen(BW, 20000);         % remove stray pixels
BW = imfill(BW,'holes');             % fill small holes

se = strel('disk',5);       
BW = imerode(BW,se);                % slightly erode the edges of the image

BW = uint8(BW);
cleaned = image.*BW; % image masking via element-wise multiplication

end

