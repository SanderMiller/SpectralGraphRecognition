function [imgs, lbls] = load_imgs_std_sz_lbls(data_dir_name, patterns, img_dims)
    %LOAD_TEMPLATE_IMAGES Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~(exist(data_dir_name, 'dir') == 7)
        error('Cannot find directory "' + data_dir_name + '"');
    end
    
    if ~iscell(patterns)
        patterns = {patterns};
    end
    
    img_dims_sz = squeeze(size(img_dims));
    if ~(img_dims_sz == 2)
        error('`img_dims` must be a 2 element vector');
    end
    
    num_imgs = 0;
    pattern_results_partitioned = cell(length(patterns), 1);
    for p = 1:length(patterns)
        pattern_dir = dir(fullfile(data_dir_name, patterns{p}));
        pattern_results_partitioned{p} = {pattern_dir.name};
        num_imgs = num_imgs + length(pattern_results_partitioned{p});
    end
    
    img_cell_arr = cell(num_imgs, 1);
    lbls = cell(num_imgs, 1);
    
    count = uint32(1);
    for k = 1:length(pattern_results_partitioned)
        for l = 1:length(pattern_results_partitioned{k})
            lbls{count} = pattern_results_partitioned{k}{l};
            count = count + 1;
        end
    end
    
    for k = 1:num_imgs
        F = fullfile(data_dir_name, lbls{k});
        I = imread(F);
        I_dims = size(I);
        if length(I_dims) == 3
            img_cell_arr{k} = rgb2gray(I);
        elseif length(I_dims) == 2
            img_cell_arr{k} = I;
        else
            error("An image was read that has neither 2 or 3 dimensions")
        end
    end

    imgs = uint8(zeros(num_imgs, img_dims(1), img_dims(2)));

    for k = 1:num_imgs
        sz = size(img_cell_arr{k});
        if ~any(size(img_cell_arr{k}) == img_dims)
            % crop & resize image to prescribed dimensions
            irs = max(img_dims(1) / sz(1), img_dims(2) / sz(2));
            ir = floor(img_dims(1:2) ./ irs);
            imgs(k, :, :, :) = uint8(imresize(img_cell_arr{k}(1:ir(1), 1:ir(2), :), img_dims(1:2), 'nearest'));
        else
            imgs(k, :, :, :) = uint8(img_cell_arr{k});
        end
    end
end