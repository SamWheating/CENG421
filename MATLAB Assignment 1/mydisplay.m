function y = mydisplay(filename)

img = imread(filename);

close all % just in case

% make global histograms (full image)

subplot(3,3,2)
imhist(img(:,:,1))
title('Red Global histogram')
subplot(3,3,5)
imhist(img(:,:,2))
title("Green Global histogram")
subplot(3,3,8)
imhist(img(:,:,3))
title("Blue Global histogram")

% display image:
subplot(3,3,[1,4])
imshow(img(:,:, 1:3),'InitialMagnification',200)

fprintf('click on the image to analyze a smaller area')

while true
    
    % get mouse position (on click)
    [x,y] = ginput(1); 
    x_bound = floor(x);   
    y_bound = floor(y);
    
    % get pixel colour
    red = img(y_bound, x_bound, 1);
    green = img(y_bound, x_bound,2); 
    blue = img(y_bound, x_bound,3);
    
    % re-plot image with rectangle centered on mouse
    subplot(3,3,[1,4])
    hold on 
    imshow(img(:,:, 1:3),'InitialMagnification',200)
    title('Original Image')
    rectangle('Position',[x_bound-5, y_bound-5, 11, 11],'EdgeColor', 'y','LineWidth', 1)
    
    % make new array of local square contents
    local = img(y_bound-5:y_bound+5, x_bound-5:x_bound+5, :);
    subplot(3,3,7)
    
    % display small image magnified
    imshow(local(:,:,1:3),'InitialMagnification',2000)
    title('Local 11x11px Area (Magnified)')
    
    % plot local area histograms
    subplot(3,3,3)
    imhist(local(:,:,1))
    title('Red Local histogram')
    subplot(3,3,6)
    imhist(local(:,:,2))
    title("Green Local histogram")
    subplot(3,3,9)
    imhist(local(:,:,3))
    title("Blue Local histogram")
    
    % calculate intensity
    Y = 0.299*img(y_bound,x_bound, 1) + 0.59*img(y_bound,x_bound, 2) + 0.11*img(y_bound,x_bound, 3);
    
    % calculate intensity for all points in local
    Y_local = 0.299*local(:,:, 1) + 0.59*local(:,:, 2) + 0.11*local(:,:, 3);    
    Y_mean = mean2(Y_local);
    Y_std = std2(Y_local);
    
    % print intensity stats to console
    fprintf('\n[R,G,B] = [%i,%i,%i] \n', red, green, blue);
    fprintf('pixel intensity: %i\n', Y);
    fprintf('mean area intensity: %i\n', Y_mean)
    fprintf('area intensity std dev: %i\n\n',Y_std);
    
end
end