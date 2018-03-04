function [index, map] = myrgb2ind(filename)

img = imread(filename);
[y,x,z] = size(img);

full_map = zeros(x*y, 3, 'uint8');

for i = (1:x)
    for j = (1:y)
        row = x*i+j;
        R = img(j,i,1);
        G = img(j,i,2);
        B = img(j,i,3);
        full_map(row,:) = [R,G,B];
    end
end

map = unique(full_map, 'rows');

index = zeros(y, x);

for i = (1:x)
    for j = (1:y)
        R = img(j,i,1);
        G = img(j,i,2);
        B = img(j,i,3);
        [tf, row] = ismember([R G B], map, 'rows');
        index(j,i) = row;
    end
end

end
