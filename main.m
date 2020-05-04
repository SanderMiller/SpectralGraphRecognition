%% Load and pre-process data

dataFolder = "data";
addpath(genpath(fullfile(cd, "src")));

[validImgs, validLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'validate'), "*.png", [100, 100]);
[trainImgs, trainLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'train'), "*.png", [100, 100]);

numPeaks = 100;

% load training images & labels
trainImgsSz = size(trainImgs);
histMatrixTrain = uint32(zeros(trainImgsSz(1),20));
for a = 1:trainImgsSz(1)
  grayIm = squeeze(trainImgs(a, :, :));  
  [G, points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histMatrixTrain(a, :) = currHistVec;
end

% load test images & labels
validImgsSz = size(validImgs);
histMatrixValid = uint32(zeros(validImgsSz(1),20));
for a = 1:validImgsSz(1)
  grayIm = squeeze(validImgs(a, :, :));  
  [G, points] = image2Graph(grayIm, numPeaks, 20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G), 20);
  histMatrixValid(a, :) = currHistVec;
end

% load source image labels
[~, lblsOrig] = loadImgsLblsStdSz(dataFolder, {'*.png', '*.jpg'}, [200, 200]);
numOrigImgs = length(lblsOrig);

origLblsMap = containers.Map();
origLbls = cell(length(lblsOrig), 1);
for k = 1:numOrigImgs
    fileNoExtension = removeFileExtension(lblsOrig{k});
    origLbls{k} = fileNoExtension;
    origLblsMap(fileNoExtension) = k;
end

% match source image labels to 
nbhMapsCell = cell(2, 1);  % 1st -> validate; 2nd -> train
for m = 1:2
    numEach = 0;
    map = containers.Map();
    trainMap = containers.Map();
    for k = 1:numOrigImgs
        imgName = removeFileExtension(lblsOrig{k});
        
        if m == 1
            lLength = validImgsSz(1);
        else
            lLength = trainImgsSz(1);
        end
        validMatchIndices = boolean(zeros(lLength, 1));
        
        for l = 1:lLength
            if m == 1
                lbl = validLbls{l};
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
    nbhMapsCell{m} = map;
end

%% Run Algorithm


% Generate confusion matrix using linear search

% generate confusion matrix
confuseMtxLinearSearch = uint32(zeros(numOrigImgs, numOrigImgs));
for l = 1:validImgsSz(1)
    pred = makePredLinSearch(squeeze(histMatrixValid(l, :)), ... 
        histMatrixTrain, trainLbls);
    predIdx = origLblsMap(pred);
    validLblName = extractTrainValName(validLbls(l));
    disp("Truth: " + validLblName + " -> Pred: " + pred);
    lIdx = origLblsMap(validLblName);
    confuseMtxLinearSearch(lIdx, predIdx) = confuseMtxLinearSearch(...
        lIdx, predIdx) + 1;
end

figure('Name', 'Confusion Matrices');
subplot(1, 2, 1);
cmLinear = confusionchart(confuseMtxLinearSearch, origLbls, ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');
title('Confusion Matrix with Linear Search');
sortClasses(cmLinear,'descending-diagonal')


% Generate confusion matrix using simulated annealing

confuseMtxSimAnnealSearch = uint32(zeros(numOrigImgs, numOrigImgs));
for l = 1:validImgsSz(1)
    pred = makePredSimAnnealSearch(squeeze(histMatrixValid(l, :)), ... 
        histMatrixTrain, trainLbls, 60, 10, nbhMapsCell{2});
    predIdx = origLblsMap(pred);
    validLblName = extractTrainValName(validLbls(l));
    disp("Truth: " + validLblName + " -> Pred: " + pred);
    lIdx = origLblsMap(validLblName);
    confuseMtxSimAnnealSearch(lIdx, predIdx) = confuseMtxSimAnnealSearch(...
        lIdx, predIdx) + 1;
end

subplot(1, 2, 2);
cmSimAnneal = confusionchart(confuseMtxSimAnnealSearch, origLbls, ...
    'RowSummary', 'row-normalized', 'ColumnSummary', 'column-normalized');
title('Confusion Matrix with Simulated Annealing Search');
sortClasses(cmSimAnneal,'descending-diagonal')

