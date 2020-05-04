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
[~, lblsUnique] = loadImgsLblsStdSz(dataFolder, {'*.png', '*.jpg'}, [200, 200]);
numOrigImgs = length(lblsUnique);

origLblsMap = containers.Map();
origLbls = cell(length(lblsUnique), 1);
for k = 1:numOrigImgs
    fileNoExtension = removeFileExtension(lblsUnique{k});
    origLbls{k} = fileNoExtension;
    origLblsMap(fileNoExtension) = k;
end

% generate confusion matrix
confuseMtx = uint32(zeros(numOrigImgs, numOrigImgs));
for l = 1:validImgsSz(1)
    pred = makePred(squeeze(histMatrixValid(l, :)), histMatrixTrain, ...
        trainLbls, 'linear');
    predIdx = origLblsMap(pred);
    validLblName = extractTrainValName(validLbls(l));
    disp("Truth: " + validLblName + " -> Pred: " + pred);
    lIdx = origLblsMap(validLblName);
    confuseMtx(lIdx, predIdx) = confuseMtx(lIdx, predIdx) + 1;
end

% plot confusion matrix
figure('Name', 'Confusion Matrix');
cm = confusionchart(confuseMtx, origLbls, 'RowSummary', 'row-normalized', ...
    'ColumnSummary','column-normalized');
title('Confusion Matrix');
sortClasses(cm,'descending-diagonal')
