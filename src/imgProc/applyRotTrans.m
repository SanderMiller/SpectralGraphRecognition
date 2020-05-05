function imgOut = applyRotTrans(img, transVec, rotMat, fillValue)
    %APPLYROTTRANS Summary of this function goes here
    %   Detailed explanation goes here
    a2dtform = affine2d(rotMat);
    centerOutput = affineOutputView(size(img), a2dtform, 'BoundsStyle', ...
        'CenterOutput');
    if any(transVec)
        imgOut = imtranslate(imwarp(img, a2dtform, 'bilinear', ...
            'OutputView', centerOutput, 'FillValues', fillValue), ...
            transVec, 'FillValues', fillValue);
    else
        imgOut = imwarp(img, a2dtform, 'bilinear', 'OutputView', ...
            centerOutput, 'FillValues', fillValue);
    end
end