function [imgs, lbls] = loadImgsLblsStdSz(dataDirName, patterns, desiredImgDims)
    %LOADIMGSLBLSSTDSZ Summary of this function goes here
    %   Detailed explanation goes here
    
    if ~(exist(dataDirName, 'dir') == 7)
        error('Cannot find directory "' + dataDirName + '"');
    end
    
    if ~iscell(patterns)
        patterns = {patterns};
    end
    
    imgDimsSz = squeeze(size(desiredImgDims));
    if ~(imgDimsSz == 2)
        error('`imgDims` must be a 2 element vector');
    end
    
    numImgs = 0;
    patternResPartitioned = cell(length(patterns), 1);
    for p = 1:length(patterns)
        patternDir = dir(fullfile(dataDirName, patterns{p}));
        patternResPartitioned{p} = {patternDir.name};
        numImgs = numImgs + length(patternResPartitioned{p});
    end
    
    imgCellArr = cell(numImgs, 1);
    lbls = cell(numImgs, 1);
    
    count = uint32(1);
    for k = 1:length(patternResPartitioned)
        for l = 1:length(patternResPartitioned{k})
            lbls{count} = patternResPartitioned{k}{l};
            count = count + 1;
        end
    end
    
    for k = 1:numImgs
        img = imread(fullfile(dataDirName, lbls{k}));
        IDims = size(img);
        if length(IDims) == 3
            imgCellArr{k} = rgb2gray(img);
        elseif length(IDims) == 2
            imgCellArr{k} = img;
        else
            error("An image was read that has neither 2 or 3 dimensions")
        end
    end

    imgs = uint8(zeros(numImgs, desiredImgDims(1), desiredImgDims(2)));

    for k = 1:numImgs
        sz = size(imgCellArr{k});
        if ~any(size(imgCellArr{k}) == desiredImgDims)
            % crop & resize image to prescribed dimensions
            irs = max(desiredImgDims(1) / sz(1), desiredImgDims(2) / sz(2));
            ir = floor(desiredImgDims(1:2) ./ irs);
            imgs(k, :, :, :) = uint8(imresize(imgCellArr{k}(1:ir(1), 1:ir(2), :), desiredImgDims(1:2), 'bilinear'));
        else
            imgs(k, :, :, :) = uint8(imgCellArr{k});
        end
    end
end