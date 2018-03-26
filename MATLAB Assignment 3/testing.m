% subplot(2,3,1)
% imshow(brain)
% subplot(2,3,4)
% imshow(preprocess(brain))
% 
% subplot(2,3,2)
% imshow(brain2)
% subplot(2,3,5)
% imshow(preprocess(brain2))
% 
% subplot(2,3,3)
% imshow(brain3)
% subplot(2,3,6)
% imshow(preprocess(brain3))
% 

% clf
% 
% subplot(3,1,1)
% imhist(preprocess(brain))
% xlim([2, 255])
% ylim([0, 3000])
% subplot(3,1,2)
% imhist(preprocess(brain2))
% xlim([2, 255])
% ylim([0, 3000])
% subplot(3,1,3)
% imhist(preprocess(brain3))
% xlim([2, 255])
% ylim([0, 3000])

% clf
% 
% subplot(2,3,1)
% imshow(preprocess(brain))
% 
% subplot(2,3,4)
% imshow(double_thresholding(preprocess(brain)))
% 
% subplot(2,3,2)
% imshow(preprocess(brain2))
% 
% subplot(2,3,5)
% imshow(double_thresholding(preprocess(brain2)))
% 
% subplot(2,3,3)
% imshow(preprocess(brain3))
% 
% subplot(2,3,6)
% imshow(double_thresholding(preprocess(brain3)))

brain = imread('brain1.jpg');
brain2 = imread('brain2.jpg');
brain3 = imread('brain3.jpg');



% subplot(1,3,1)
% imshow(preprocess(brain))
% 
% subplot(1,3,1)
% imshow(double_thresholding(preprocess(brain)))
% 
% subplot(1,3,2)
% imshow(preprocess(brain2))
% 
% subplot(1,3,2)
% imshow(double_thresholding(preprocess(brain2)))
% 
% subplot(1,3,3)
% imshow(preprocess(brain3))

% subplot(1,3,3)
% imshow(double_thresholding(preprocess(brain3)))

subplot(1,3,1)
imshow(region_growing(preprocess(brain)))

subplot(1,3,2)
imshow(region_growing(preprocess(brain2)))

subplot(1,3,3)
imshow(region_growing(preprocess(brain3)))

% a = 'test 1'
% tic
% b = double_thresholding(preprocess(brain3));
% toc
% a = 'test 2'
% tic
% b = region_growing(preprocess(brain3));
% toc
