dataFolder = "data";
addpath(fullfile(cd, "src"));

[valImgs, valLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'validate'),"*.png", [100, 100]);
[trainImgs, trainLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'train'),"*.png", [100, 100]);

numPeaks = 100;

% load training images & labels
trainImgsSz = size(trainImgs);
histogramMatrixTrain = uint32(zeros(trainImgsSz(1),20));
for a = 1:trainImgsSz(1)
  grayIm = squeeze(trainImgs(a, :, :));  
  [G, points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTrain(a, :) = currHistVec;
end

% load test images & labels
valImgsSz = size(valImgs);
histogramMatrixTest = uint32(zeros(valImgsSz(1),20));
for a = 1:valImgsSz(1)
  grayIm = squeeze(valImgs(a, :, :));  
  [G, points] = image2Graph(grayIm, numPeaks, 20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G), 20);
  histogramMatrixTest(a, :) = currHistVec;
end

% load source image labels
[~, lblsUnique] = loadImgsLblsStdSz(dataFolder, {'*.png', ...
    '*.jpg'}, [200, 200]);
numUnique = length(lblsUnique);
confuseMtx = zeros(numUnique, numUnique);

lblsUniqueNoExtension = cell(length(lblsUnique), 1);
for k = 1:numUnique
    matches = regexpi(lblsUnique{k}, '(?!\.)\w*', 'match');
    if ~(length(matches) == 1)
        error("There was an error witht the filename in lblsUnique");
    end
    lblsUniqueNoExtension{k} = matches{1};
end

% match source image labels to 
mapsCell = cell(2, 1);
for m = 1:2
    numEach = 0;
    map = containers.Map();
    trainMap = containers.Map();
    for k = 1:numUnique
        imgName = lblsUniqueNoExtension{k};
        
        if m == 1
            lLength = valImgsSz(1);
        else
            lLength = trainImgsSz(1);
        end
        validMatchIndices = boolean(zeros(lLength, 1));
        
        for l = 1:lLength
            if m == 1
                lbl = valLbls{l};
            else
                lbl = trainLbls{l};
            end
            match = regexp(lbl, "^(?!(ROT))(" + imgName + ")", 'match');
            
            if ~isempty(match)
                if match{1} == imgName
                    if k == 1
                        numEach = numEach + 1;
                    end
                    validMatchIndices(l) = 1;  % store l value
                end
            end
        end
        validMatchList = find(validMatchIndices);
        assert(length(validMatchList) == numEach, ...
            sprintf("Different numbers of the same corresponding image " + ...
            "found in the validation data set: %d vs %d", numEach, ...
            length(validMatchList)))
        map(imgName) = validMatchList;
    end
    mapsCell{m} = map;
end
