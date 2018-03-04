apple = imread('apple.jpg')
orange = imread('city1.jpg')

subplot(1,3,1)
imshow(apple)
subplot(1,3,2)
imshow(orange)
subplot(1,3,3)
imshow(myblend(apple, orange, 6, 0.4))