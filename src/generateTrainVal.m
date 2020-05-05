function generateTrainVal(dataDirName, patterns, desiredImgDims, ...
    trainSplit, thetaVec, xTransVec, yTransVec, fillValue, boarderSz, ...
    deleteExist)
    %GENERATETRAINVAL Summary of this function goes here
    %   Detailed explanation goes here
    
    assert(trainSplit < 1 && trainSplit > 0, '`trainSplit` must be < 1 and > 0');
    
    [imgs, lbls] = loadImgsLblsStdSz(dataDirName, patterns, desiredImgDims);
    imgsSz = size(imgs);
    numImgs = imgsSz(1);
    
    % create train folder if needed
    trainFolder = fullfile('data', 'train');
    if ~(exist(trainFolder, 'dir') == 7)
        mkdir(trainFolder);
    elseif deleteExist
        rmdir(trainFolder, 's');
        mkdir(trainFolder);
    end
    
    % create validate folder if needed
    validFolder = fullfile('data', 'validate');
    if ~(exist(validFolder, 'dir') == 7)
        mkdir(validFolder);
    elseif deleteExist
        rmdir(validFolder, 's');
        mkdir(validFolder);
    end
    
    keys = linspace(0, 1, length(thetaVec)*length(xTransVec)*...
        length(yTransVec));
    
    rotMat = eye(3);
    transVec = [0, 0];
    for k = 1:numImgs
        keys = keys(randperm(length(keys)));
        img = squeeze(imgs(k, :, :));
        prefixCounter = 1;
        for l = 1:length(thetaVec)
            cosValue = cos(thetaVec(l));
            sinValue = sin(thetaVec(l));
            rotMat(1, 1) = cosValue;
            rotMat(1, 2) = -sinValue;
            rotMat(2, 1) = sinValue;
            rotMat(2, 2) = cosValue;
            rotValStr = sprintf("#ROT=%0.6f", thetaVec(l));
            for m = 1:length(xTransVec)
                transVec(1) = xTransVec(m);
                xValStr = sprintf("#X=%0.6f", xTransVec(m));
                for n = 1:length(yTransVec)
                    transVec(2) = yTransVec(n);
                    yValStr = sprintf("#Y=%0.6f", yTransVec(n));
                    
                    imgOut = applyRotTrans(addImgBoarder(img, ...
                        boarderSz, fillValue), transVec, rotMat, fillValue);
                    
                    imgName = removeFileExtension(lbls{k});
                    imgOutName = imgName + rotValStr + xValStr + yValStr;
                    imgOutName = replace(imgOutName, ".", "_") + ".png";
                    
                    if keys(prefixCounter) < trainSplit
                        prefix = "train";
                    else
                        prefix = "validate";
                    end
                    prefixCounter = prefixCounter + 1;
                    
                    imgOutFilename = fullfile(dataDirName, prefix, ...
                        imgOutName);
                    imwrite(imgOut, imgOutFilename)
                end
            end
        end
    end
end

