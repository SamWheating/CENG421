apple = imread('city1.jpg');
orange = imread('city2.jpg');

img = imread('apple2.jpg')

tic
subplot(1,2,1)
imshow(myblend(apple, orange, 6, 0.4))
title('combined image, n=6, a=0.4', 'fontsize', 20)
subplot(1,2,2)
imshow(myblend(apple, orange, 6, 0.5))
title('combined image, n=6, a=0.5', 'fontsize', 20)
toc


% GAUSSIAN REDUCTION:
% returns an image of size (m/2)x(n/2) (rounded down)
function small_image = reduce(image, a) %-------------------------------------

% Pad image with mirror padding depth 2
image_mirror = padarray(image, [2 2], 'symmetric','both');

b = 0.25;
c = (0.25 - 0.5*a);

% form 5x5 filter
w1 = [c b a b c];
w2 = [c; b; a; b; c];
w = w2*w1;

[x, y, z] = size(image);

% small_image = zeros(floor((1+((x-1)/2))), floor((1+((y-1)/2))), 3, 'uint8');
small_image = zeros(floor(x/2), floor(y/2), 3, 'uint8');

for m = 1:size(small_image,1);
    for n = 1:size(small_image,2);
        for k = 1:5;
            for l = 1:5;
                small_image(m,n,1:3) = small_image(m,n,1:3) + w(k, l)*image_mirror((k-2+(2*m)), (l-2+(2*n)), 1:3);
            end
        end
    end
end

return
end


% GAUSSIAN EXPAND
% using interpolation to expand image 

function big_image = expand(image, a) % -------------------------------------

% Pad image with mirror padding depth 2
image_mirror = padarray(image, [3 3], 'symmetric','both');

b = 0.25;
c = (0.25 - 0.5*a);

% form 5x5 filter
w1 = [c b a b c];
w2 = [c; b; a; b; c];
w = w2*w1;

[x, y, z] = size(image);

big_image = zeros(x*2, y*2, 3, 'uint8');

for m = 1:size(big_image,1);
    for n = 1:size(big_image,2);
        % iterate across filter        
        for k = 1:5;
            for l = 1:5;
                if mod((m+k), 2) == 0;
                    if mod((n+l), 2) == 0;
                        big_image(m,n,1:3) = big_image(m,n,1:3) + 4*w(k,l)*image_mirror((m+k+4)/2, (n+l+4)/2, 1:3);
                    end
                end
            end
        end
    end
end

return

end

function combined = myblend(img1, img2, num_levels, alpha)

% Generate Laplacian and Base image for img1 (apple, left side)

disp('Generating laplacian pyramid for image 1...')

reduced1 = {num_levels+1};
reduced1{1} = img1;

expanded1 = {num_levels};
difference1 = {num_levels};

for i = 2:num_levels
   img1 = reduce(img1, alpha);
   reduced1{i} = img1;
end

base_image1 = reduce(reduced1{num_levels}, alpha);
expanded1{num_levels} = expand(base_image1, alpha);

for i = 1:num_levels-1
    expanded1{i} = expand(reduced1{i+1}, alpha);
end

for i = 1:num_levels
    difference1{i} = reduced1{i} - expanded1{i};
end

% Generate Laplacian and Base image for img2 (orange, right side)

disp('Generating laplacian pyramid for image 2...')

reduced2 = {num_levels+1};
reduced2{1} = img2;

expanded2 = {num_levels};
difference2 = {num_levels};

for i = 2:num_levels
   img2 = reduce(img2, alpha);
   reduced2{i} = img2;
end

base_image2= reduce(reduced2{num_levels}, alpha);
expanded2{num_levels} = expand(base_image2, alpha);

for i = 1:num_levels-1;
    expanded2{i} = expand(reduced2{i+1}, alpha);
end

for i = 1:num_levels;
    difference2{i} = reduced2{i} - expanded2{i};
end

% MERGE IMAGES
% Start by merging base image

disp('Combining base images...')

difference3 = {num_levels};
base_image3 = zeros(size(base_image2), 'uint8');

for i = 1:size(base_image3, 2)
    
    if i < ((size(base_image3, 2))/2)-1;
        base_image3(:, i, :) = base_image1(:, i, :);
        
    elseif i > ((size(base_image3, 2))/2)+1;
        base_image3(:, i, :) = base_image2(:, i, :);
        
    else
        base_image3(:, i, :) = ((0.5*base_image2(:, i, :)) + (0.5*base_image1(:, i, :)));
        
    end
        
end

% Now merge the laplacian pyramids in the same way
% to save time and space I'll construct difference3 on top of difference 2

disp('Combining laplacians...')

for j = 1:num_levels;
    
    difference3{j} = zeros(size(difference2{j}), 'uint8');

    for i = 1:size(difference1{j}, 2);

        if i < ((1:size(difference1{j}, 2))/2)-1;
            difference3{j}(:, i, :) = difference1{j}(:, i, :);

        elseif i > ((1:size(difference1{j}, 2))/2)+1;
            difference3{j}(:, i, :) = difference2{j}(:, i, :);

        else
            c1 = difference1{j}(:, i, :);
            c2 =  difference2{j}(:, i, :);
            difference3{j}(:, i, :) = (0.5.*c1) + (0.5*c2);

        end

    end

end    

% recover images

img = base_image3;

for i = 1:num_levels;
    img = expand(img, alpha);
    img = img + difference3{num_levels-i+1};
end

imshow(base_image3);

combined = img;

end

function output = laplacian_reconstruct(img1, num_levels, alpha)

disp('Generating laplacian pyramid for image 1...')

reduced1 = {num_levels+1};
reduced1{1} = img1;

expanded1 = {num_levels};
difference1 = {num_levels};

for i = 2:num_levels
   img1 = reduce(img1, alpha);
   reduced1{i} = img1;
end

base_image1 = reduce(reduced1{num_levels}, alpha);
expanded1{num_levels} = expand(base_image1, alpha);

for i = 1:num_levels-1
    expanded1{i} = expand(reduced1{i+1}, alpha);
end

for i = 1:num_levels
    difference1{i} = (reduced1{i} - expanded1{i});
end

% reconstruction;

img = base_image1;

for i = 1:num_levels;
    img = expand(img, alpha);
    img = img + difference1{num_levels-i+1};
end

output = img;

return

end





