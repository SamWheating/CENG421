function Predictions = HypersphereTesting(training_data, k)

% apply k-fold validation to assess accuracy of hypersphere classifier
% given by HypersphereTraining(training_data)

% k fold validation: 
% randomize training data order

order = randperm(size(training_data, 1));

training_data = training_data(order, :);

test_size = floor(size(training_data, 1) / k);

classifications = [];

for i = 1:k
    
    % split data into test and train
    
    upper_bound = 1 + (i-1)*test_size;
    lower_bound = (i*test_size);
    
    tf = false(size(training_data, 1),1);    % create logical index vector
    tf(upper_bound:lower_bound, 1) = true;
    
    test = training_data(tf,:); 
    train = training_data(~tf,:);

    disp('training model...');
    spheres = HypersphereTraining(train);
    
    for j = 1:size(test,1);    % for every point in testing set
       min_distance = 100;
       for s = 1:size(spheres, 1)   % take distance to the surface of every sphere.
            difference = test(j, 2:size(test, 2)) - spheres(s, 3:size(spheres,2));  % distance = (distance between point and center) - radius
            distance = (norm(difference) - spheres(s, 2)); 
            if distance < min_distance;
                min_distance = distance; 
                classification = spheres(s, 1);               
            end           
       end
       classifications = [classifications; test(j, 1) classification];
    end
    
end
    
    confusion = confusionmat(classifications(:, 1), classifications(:,2))
    accuracy = sum(diag(confusion)) / size(classifications, 1)


end