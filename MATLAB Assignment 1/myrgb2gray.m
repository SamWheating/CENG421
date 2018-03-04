function Y = myrgb2gray(filename)
% read input image into matrix
img = imread(filename);

% convert to grayscale using formula Y = .299R + .59G + .11B
my_bw = 0.299*img(:,:, 1) + 0.59*img(:,:, 2) + 0.11*img(:,:, 3);

% return my image
Y = my_bw;
end