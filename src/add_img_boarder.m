function img = add_img_boarder(img, boarder_sz, fill_value)
    %ADD_IMG_BOARDER Summary of this function goes here
    %   Detailed explanation goes here
    im_dims = size(img);
    new_sz = [2*boarder_sz + im_dims(1), 2*boarder_sz + im_dims(2)];
    tmp = ones(new_sz, 'uint8').*fill_value;
    tmp(boarder_sz + 1:boarder_sz + im_dims(1), boarder_sz + ...
        1:boarder_sz + im_dims(2)) = img;
    img = tmp;
end

