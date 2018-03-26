function vein_stats = VenationData(name)

% extract venation data from image
% assumes image is a single channel

folder = strcat('Images/', name, '/');

a = dir(folder)

c = length(a);

num_features = 8
plant_data = zeros(c-2, num_features, 'double');

clf         % just in case

for i = 3:c     % The first 2 items in a list of files are '.' and '..'
    
    % PREPROCESSING --------------------------------------
    
    filename = strcat('Images/', name, '/', a(i).name);
    base = rgb2gray(preprocess_colour(filename));       % returns a binary-masked, vertically oriented colour image

    % GENEARTE METRICS -------------------------------------------
    
    outer = edge(base, 'Canny', [0.3, 0.7]);
    inner = edge(base, 'Canny', [0.05, 0.2]);
    veins = inner - outer;
    
    veins = logical(imdilate(veins, strel('disk', 2)));
    %veins = imerode(veins, strel('disk', 3));
   
    veins = bwareafilt(veins, 1);
    veins =  imerode(veins, strel('disk', 4));
    
    veins =  imdilate(veins, strel('disk', 7));
    
    veins =  imerode(veins, strel('disk', 6));
    
    subplot(2,2,1)    
    imshow(base);
    subplot(2,2,2)
    imshow(veins)
    subplot(2,2,3)    
    imshow(inner);
    subplot(2,2,4)
    imshow(outer)
    

end

end