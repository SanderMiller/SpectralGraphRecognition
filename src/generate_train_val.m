function generate_train_val(data_dir_name, patterns, img_dims, ...
    train_split, theta_vec, x_trans_vec, y_trans_vec, fill_value, ...
    boarder_sz)
    %GENERATE_TRAIN_VAL Summary of this function goes here
    %   Detailed explanation goes here
    
    assert(train_split < 1 && train_split > 0, '`train_split` must be < 1 and > 0');
    
    [imgs, lbls] = load_imgs_std_sz_lbls(data_dir_name, patterns, img_dims);
    imgs_sz = size(imgs);
    num_imgs = imgs_sz(1);
    
    % create train folder if needed
    train_folder = fullfile('data', 'train');
    if ~(exist(train_folder, 'dir') == 7)
        mkdir(train_folder);
    end
    
    % create validate folder if needed
    valid_folder = fullfile('data', 'validate');
    if ~(exist(valid_folder, 'dir') == 7)
        mkdir(valid_folder);
    end    
    
    keys = linspace(0, 1, length(theta_vec)*length(x_trans_vec)*...
        length(y_trans_vec));
    
    rot_mat = eye(3);
    trans_vec = [0, 0];
    for k = 1:num_imgs
        keys = keys(randperm(length(keys)));
        img = squeeze(imgs(k, :, :));
        prefix_counter = 1;
        for l = 1:length(theta_vec)
            cos_value = cos(theta_vec(l));
            sin_value = sin(theta_vec(l));
            rot_mat(1, 1) = cos_value;
            rot_mat(1, 2) = -sin_value;
            rot_mat(2, 1) = sin_value;
            rot_mat(2, 2) = cos_value;
            rot_val_str = sprintf("ROT%0.6f", theta_vec(l));
            for m = 1:length(x_trans_vec)
                trans_vec(1) = x_trans_vec(m);
                x_val_str = sprintf("X%0.6f", x_trans_vec(m));
                for n = 1:length(y_trans_vec)
                    trans_vec(2) = y_trans_vec(n);
                    y_val_str = sprintf("Y%0.6f", y_trans_vec(n));
                    
                    img_out = apply_rot_trans_img(add_img_boarder(img, ...
                        boarder_sz, fill_value), trans_vec, rot_mat, fill_value);
                    
                    img_name_pre = lbls{k};
                    matches = regexp(img_name_pre, '(?!\.)\w*', 'match');
                    img_name = matches{1};
                    
                    img_out_name = img_name + rot_val_str + x_val_str ...
                        + y_val_str;
                    img_out_name = replace(img_out_name, ".", "_") + ".png";
                    
                    if keys(prefix_counter) < train_split
                        prefix = "train";
                    else
                        prefix = "validate";
                    end
                    prefix_counter = prefix_counter + 1;
                    
                    img_out_filename = fullfile(data_dir_name, prefix, ...
                        img_out_name);
                    imwrite(img_out, img_out_filename)
                end
            end
        end
    end
end

