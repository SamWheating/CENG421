function spheres = HypersphereTraining(training_data)

% encoding:

% INPUT:
% training data is un-annotated (regular array)
% first column denotes class label.
% all further columns are features.

% OUTPUT:
% first column is class
% second column is radius of hypersphere
% the following n columns are coordinates in the n-dimensional feature space.



num_classes = size(unique(training_data(:, 1)), 1);
class_labels = unique(training_data(:, 1));

% make arrays of data from each class

classes  = {}

for i = 1:num_classes
   classes{i} = training_data(training_data(:,1) == class_labels(i), 2:size(training_data, 2));   % drop the labels
end

% form spheres for each class

spheres = []

for i = 1:size(classes,2)
    
    class = classes{i}
    other_classes = []
    
    for j = 1:size(classes,2)
        if j ~= i
            other_classes = [other_classes; classes{j}(:, :)]
        end
    end
    
    % while samples still exist in the class
    while size(class, 1) > 0 

        % 2) Find the median of the points of S.
        if size(class > 1)
            M = median(class);
        else
            M = class
        end
        
        
        % 3) Select the closest point Py to that median as the initial center of a hypersphere K.
        distances = sqrt(sum(bsxfun(@minus, M, class).^2,2));  % distance from every point to median
        [min_within, min_index] = min(distances);
        center = class(min_index, :)
        
        % 4) Find the nearest point Pz of a different class from the center, and let D1 be the distance between Py and Pz.
        distances_out = sqrt(sum(bsxfun(@minus, center, other_classes).^2,2));
        [D1, min_out_index] = min(distances_out);
        
        % 5) Find the farthest point of the same class inside the hypersphere of radius D1 to the center. Let D2 be the distance from the center to that farthest point.
        distances_in = sqrt(sum(bsxfun(@minus, center, class).^2,2));
        D2 = max(distances_in(distances_in(:,1) < D1));
        
        % 6)Set the radius of hypersphere K as (D1 + D2)/2.
        radius = (D1 + D2)/2;
        
        
        % 7) Search among the nearest E points of the same class C that are in the negative direction with respect to the direction of Pz–Py. 
        % The purpose is to move the center to the new point to enlarge the hypersphere. 
        % The point, which has the most negative direction, is selected to replace Py as the new center.
        % (do this later: optimal but not essential)

        % 8) If there is no point in the negative direction that we can move to, the hypersphere K has been completed, else repeat steps 5–7

        % 9) Remove the points encompassed by that hypersphere K from S.
        class = horzcat(distances_in, class);
        class = class(class(:,1) > radius, :);  % only keep points outside radius
        class = class(: , 2:size(class, 2))
        
        sphere = [i, radius, center];
        spheres = [spheres; sphere]

        % 10) Set K = K + 1. If S is not empty repeat steps 2–9, else set C = C + 1, and operate on the new class by running steps 1–9.

        
        
        
    end
    
    
    
end

end