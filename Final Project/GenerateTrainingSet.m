function training_data = GenerateTrainingSet(plants)

% GENERATE TRAINING SET
% runs the analysis on all listed plant names
% returns a table of labelled training data.

dbstop if error

if size(plants,1) == 0
    plants = {'CatalpaSpeciosa', 'CeltisOccidentalis', 'MagnoliaStellata', 'PrunusPensylvanicia', 'QuercusMontana'};
end

filename = 'TrainingData.csv' ;


%headers = {"aspect_ratio", "rectangularity", "convex_ratio", "perimeter_ratio", "sphericity", "circularity", "eccentricity", "form_factor"};
headers = {'name', 'aspect_ratio', 'rectangularity', 'convex_ratio', 'perimeter_ratio', 'sphericity', 'circularity', 'eccentricity', 'form_factor'};

% feed data into a csv which contains labelled entries of all plants

offset = 1;         % variable for tracking position in the csv file

data = []
names = strings([1, 200*size(plants, 1)])  % preallocate assuming < 200 samples / plant.
identifiers = zeros([1, 200*size(plants, 1)])

for i = 1:size(plants, 2)
   name = plants{i};
   plant_data = PlantDataExtraction(name);
   
   for j = offset:(offset + size(plant_data,1))
       names(1,j) = name;
       identifiers(j, 1) = i
   end
   
   offset = offset + size(plant_data,1);
   
   data = [data; plant_data];
   
end

% Normalize data

data2 = zeros(size(data), 'double');

for i = 1:size(data, 2)               % for each column
    for j = 1:size(data, 1)            % for each element
        data2(j, i) = (data(j, i) - min(data(:, i))) / (max(data(:, i)) - min(data(:, i))); 
    end
end

data = data2;

% format data into strings and print to csv

output_data = arrayfun(@num2str, data, 'UniformOutput', false)

identifiers = identifiers(1:size(data2, 1), 1);
training_data = horzcat(identifiers, data2(:, 1:size(data2, 2)) );

datei = fopen(filename, 'w');
[nrows,ncols] = size(headers);
separator = ',';

for row = 1:nrows
    fprintf(datei,[sprintf(['%s' separator],headers{row,1:ncols-1}) headers{row,ncols} '\n']);
end    

[nrows,ncols] = size(output_data);

for row = 1:nrows
    fprintf(datei,[sprintf(['%s' separator], names{row}, output_data{row,1:ncols-1}) output_data{row,ncols} '\n']);
end    

% Closing file
fclose(datei);



end