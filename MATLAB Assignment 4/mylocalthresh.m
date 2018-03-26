function g = mylocalthresh(f, nhood, a, b, meantype)

if meantype == "global"
    mean = ones([size(f, 1), size(f,2)], 'uint8') * floor(mean2(f));
else
    mean = mylocalmean(f, nhood);
end

dev = stdfilt(f, nhood);

g = zeros([size(f, 1), size(f,2)]);

for i = 1:size(f, 1)
    for j = 1:size(f, 2)
       if (f(i, j) > a*dev(i, j)) & (f(i, j) > b*mean(i, j))
          g(i,j) = 1; 
       end   
    end
end

% display_dev = ones([size(f, 1), size(f,2)], 'uint8') .* uint8(floor(dev)) * a;
% 
% subplot(1,4,1)
% imshow(f)
% title('original image')
% subplot(1,4,2)
% imshow(mean)
% title('mean')
% subplot(1,4,3)
% imshow(display_dev)
% title('std dev * a')
% subplot(1,4,4)
% imshow(g)
% title('segmented image')

end