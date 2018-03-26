function h = mypostprocessing(g, radius)

    % create binary mask
    mask = imerode(g, strel('disk',4));
    mask = imdilate(mask, strel('disk', 18))

    % process base image
    g = imdilate(g, strel('disk', 1));
    g = imerode(g, strel('disk', 3));
    g = imdilate(g, strel('disk', 6));
    
    % apply mask
    g = g.*mask;

    % remove noise again
    h = imopen(g, strel('disk', 1));
   
end