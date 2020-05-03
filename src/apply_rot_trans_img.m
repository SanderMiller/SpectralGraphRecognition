function img_out = apply_rot_trans_img(img, trans_vec, rot_mat, fill_value)
    %APPLY_ROT_TRANS_IMG Summary of this function goes here
    %   Detailed explanation goes here
    a2dtform = affine2d(rot_mat);
    centerOutput = affineOutputView(size(img), a2dtform, 'BoundsStyle', ...
        'CenterOutput');
    if any(trans_vec)
        img_out = imtranslate(imwarp(img, a2dtform, 'cubic', ...
            'OutputView', centerOutput, 'FillValues', fill_value), trans_vec, ...
            'FillValues', fill_value);
    else
        img_out = imwarp(img, a2dtform, 'cubic', 'OutputView', ...
            centerOutput, 'FillValues', fill_value);
    end
end