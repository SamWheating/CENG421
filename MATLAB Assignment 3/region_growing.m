function segmented = region_growing(image)

segments = zeros([size(image, 1), size(image, 2)], 'uint8');
image = image(:,:,1);

BW = imbinarize(image, 0);

similarity = 10;

% generate seed map

for i = 2:size(image, 1)-1
    for j = 2:size(image,2)-1
        if image(i,j) == 65 % >= 64 && image(i,j) <= 66
            segments(i,j) = 80;
        end
        if image(i,j) == 117 % >= 116 && image(i,j) <= 118
            segments(i,j) = 160;
        end
        if image(i,j) == 145 %>= 144 && image(i,j) <= 146 
            segments(i,j) = 240;
        end
    end
end

complete = false;



while not(complete)
    
    previous = segments;
    
    for i = 2:size(image, 1)-1
        for j = 2:size(image,2)-1


            if previous(i,j) ~= 0
                for k = 1:3          
                    for l = 1:3

                    if abs(image(i+k-2, j+l-2) - image(i, j)) <= similarity
                        if segments(i+k-2, j+l-2) == 0 && image(i+k-2, j+l-2) ~= 0
                            segments(i+k-2, j+l-2) = segments(i,j);
                        end
                    end

                    end
                end

            end


        end
    end
        
    if segments == previous
        complete = true;
    end
    
   segmented = segments; 
    
end
end
