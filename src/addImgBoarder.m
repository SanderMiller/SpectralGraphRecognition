function img = addImgBoarder(img, boarderSz, fillValue)
    %ADDIMGBOARDER Summary of this function goes here
    %   Detailed explanation goes here
    imDims = size(img);
    newSz = [2*boarderSz + imDims(1), 2*boarderSz + imDims(2)];
    tmp = ones(newSz, 'uint8').*fillValue;
    tmp(boarderSz + 1:boarderSz + imDims(1), boarderSz + ...
        1:boarderSz + imDims(2)) = img;
    img = tmp;
end

