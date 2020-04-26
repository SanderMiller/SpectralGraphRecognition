function [imgs, lbls] = load_imgs_std_sz_lbls(img_dir, pattern, img_dims)
%LOAD_TEMPLATE_IMAGES Summary of this function goes here
%   Detailed explanation goes here
pattern = dir(fullfile(img_dir, pattern));
num_imgs = numel(pattern);
img_dims_arr = zeros(num_imgs, 3);
img_cell_arr = cell(num_imgs, 1);

for k = 1:num_imgs
    F = fullfile(img_dir, pattern(k).name);
    I = imread(F);
    img_cell_arr{k} = I;
    img_dims_arr(k, :) = size(I)';
end

if length(size(img_dims)) == 2
    img_dims = [img_dims(1), img_dims(2), 3];
end

imgs = uint8(zeros(num_imgs, img_dims(1), img_dims(2), img_dims(3)));
lbls = cell(num_imgs, 1) ;

for k = 1:num_imgs
    sz = size(img_cell_arr{k});
    if any(size(img_cell_arr{k}) == img_dims)
        irs = max(img_dims(1) / sz(1), img_dims(2) / sz(2));
        ir = floor(img_dims(1:2) ./ irs);
        imgs(k, :, :, :) = uint8(imresize(img_cell_arr{k}(1:ir(1), 1:ir(2), :), img_dims(1:2), 'nearest'));
    else
        imgs(k, :, :, :) = uint8(img_cell_arr{k});
    end
    lbls{k} = pattern(k).name;
end
end

