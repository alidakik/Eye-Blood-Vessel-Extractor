function filtered_image = remove_noise(final_image, pixel_threshold)

    % Label the connected components in the binary image
    [labeled_image, num_objects] = bwlabel(final_image);

    % Get the properties of the labeled regions
    stats = regionprops(labeled_image, 'Area');

    % Initialize the output image
    filtered_image = false(size(final_image));

    % Loop through each object and keep only those that thier area is
    % bigger than the threshold
    for k = 1:num_objects
        if stats(k).Area >= pixel_threshold
            filtered_image = filtered_image | (labeled_image == k);
        end
    end
end
