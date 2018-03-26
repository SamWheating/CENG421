function plant_data = PlantDataExtraction(name)

folder = strcat('Images/', name, '/');

a = dir(folder)

c = length(a);

num_features = 8
plant_data = zeros(c-2, num_features, 'double');

clf         % just in case

for i = 3:c     % The first 2 items in a list of files are '.' and '..'
    
    % PREPROCESSING --------------------------------------
    
    filename = strcat('Images/', name, '/', a(i).name);
    BW = preprocess(filename);

    % GENEARTE METRICS -------------------------------------------
    
    % ASPECT RATIO
    leaf_props = regionprops(BW, 'BoundingBox', 'Area', 'ConvexImage', 'Perimeter');
    box = leaf_props(1).BoundingBox;
        
    imshow(BW)
    hold on
    rectangle('Position', box, 'EdgeColor', 'r')

    
    aspect_ratio = max(box(3), box(4)) / min(box(3), box(4));
    
    % RECTANGULARITY
    leaf_size = leaf_props(1).Area;
    rectangularity = leaf_size/(box(3)*box(4));
    
    % RATIO OF CONVEX HULL
    convex_image = leaf_props(1).ConvexImage;
    convex_props = regionprops(convex_image, 'Area', 'Perimeter');
    convex_area = convex_props(1).Area;
    convex_ratio = leaf_size / convex_area;
    
    % PERIMETER RATIO (LEAF:CONVEX HULL)
    perimeter_ratio = leaf_props(1).Perimeter / convex_props(1).Perimeter;
    
    % SPHERICITY (INNER/OUTER Circle Radius)
    % find max distance transform (inner circle) radius
    perimeter_image = bwperim(BW);
    D = bwdist(perimeter_image);
    D = D.*BW;
%     [max_dist, idx] = max(D); 
%     
%     % find the center of minimum inscriber circle
%     [inner_radius, center_x] = max(max_dist);
%     [center_y, ~] = max(idx);

    [inner_radius, I] = max(D(:));
    [center_y, center_x] = ind2sub(size(D),I);


    % find the radius of minimum excircle
    [perimeter_rows, perimeter_cols] = find(perimeter_image);
    outer_radius = 0;
    for j = 1:size(perimeter_rows);
        distance_to_edge = norm([perimeter_rows(j)-center_y, perimeter_cols(j)-center_x]);
        if distance_to_edge > outer_radius;
            outer_radius = distance_to_edge;
        end
    end
    
    outer_radius = ceil(outer_radius);
    
    % plot it 
    inner_circle_pos = [(center_x-inner_radius) (center_y-inner_radius) 2*inner_radius 2*inner_radius];
    outer_circle_pos = [(center_x-outer_radius) (center_y-outer_radius) 2*outer_radius 2*outer_radius];
    rectangle('Position', inner_circle_pos, 'Curvature', [1 1], 'EdgeColor', 'g');
    rectangle('Position', outer_circle_pos, 'Curvature', [1 1], 'EdgeColor', 'g');
    hold off
    
    sphericity = inner_radius/outer_radius;
    
    dbstop if error
    
    % CIRCULARITY (Mean distance / Std Deviation of distances)
    centroid = regionprops(BW, 'Centroid');
    centroid = centroid(1).Centroid;
    distances_to_edge = zeros(size(perimeter_rows));
    
    for j = 1:size(perimeter_rows);
        distances_to_edge(j) = norm([perimeter_rows(j)-centroid(1), perimeter_cols(j)-centroid(2)]);
    end
    
    mu_R = mean(distances_to_edge);
    sigma_R = std(distances_to_edge);
    circularity = mu_R / sigma_R;
    
    % ECCENTRICTY 
    eccentricity = regionprops(BW, 'Eccentricity');
    eccentricity = eccentricity(1).Eccentricity;
    
    % FORM FACTOR
    form_factor = (4*pi*leaf_size)/ (leaf_props(1).Perimeter)^2;
    
    row =  [aspect_ratio, rectangularity, convex_ratio, perimeter_ratio, sphericity, circularity, eccentricity, form_factor];      
    plant_data(i-2, :) = row;      
    
end

end

% TO IMPLEMENT
% aspect ratio (Minimum bounding rectangle)  DONE
% rectangularity  (bounding box coverage)    DONE
% Area ratio of convex hull                  DONE
% Perimiter ratio of convex hull             DONE
% Sphericity                                 DONE
% Circularity                                DONE
% Eccentricity                               DONE
% Form Factor                                DONE

