function segmented = double_thresholding(image)

thresholds = multithresh(image, 3);

% threshold 1 is used for background subtraction
% threshold 2 and 3 are the double thresholds

segmented = zeros([size(image, 1), size(image,2)], 'uint8');

for i = 1:size(image, 1)
    for j = 1:size(image,2)
        
        if image(i,j) < thresholds(1)
            segmented(i,j) = 0;
        end
        
        if image(i,j) >= thresholds(1)
            if image(i,j) < thresholds(2)
                segmented(i,j) = 80;
            end
        end
        
        if image(i,j) >= thresholds(2)
            if image(i,j) < thresholds(3)
                segmented(i,j) = 160;
            end
        end
        
        if image(i,j) >= thresholds(3)
            segmented(i,j) = 240;
        end
        
        
    end
end

end