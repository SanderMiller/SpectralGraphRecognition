%% Generate data
% handle paths
dataFolder = "data";
addpath(genpath(fullfile(cd, "src")));

% generateTrainVal("data", {'*.jpg', '*.png'}, [386, 500], 0.8, ...
%     linspace(-pi, pi, 5), linspace(-70, 70, 5), linspace(-70, 70, 5), ...
%     0, 100, 1)

%% Load and pre-process data

% parameters
desiredImgDims = [300, 232];
numPeaks = 100;
nBins = 40;
simAnnealMaxIter = 60;
simAnnealTInit = 10;
distance_threshold = norm(desiredImgDims) / 5;

% load training and validation datasets
[validImgs, validLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'validate'), "*.png", desiredImgDims);
[trainImgs, trainLbls] = loadImgsLblsStdSz(fullfile(dataFolder, ...
    'train'), "*.png", desiredImgDims);

% load training images & labels
trainImgsSz = size(trainImgs);
histMatrixTrain = uint32(zeros(trainImgsSz(1), nBins));
for a = 1:trainImgsSz(1)
  [G, points] = image2Graph(squeeze(trainImgs(a, :, :)), numPeaks, ...
      distance_threshold);
  currHistVec = makeHistVecOn0to2(getEigenVals(G), nBins);
  histMatrixTrain(a, :) = currHistVec;
end

% load test images & labels
validImgsSz = size(validImgs);
histMatrixValid = uint32(zeros(validImgsSz(1),nBins));
for a = 1:validImgsSz(1)
  [G, points] = image2Graph(squeeze(validImgs(a, :, :)), numPeaks, ...
      distance_threshold);
  currHistVec = makeHistVecOn0to2(getEigenVals(G), nBins);
  histMatrixValid(a, :) = currHistVec;
end

% load source image labels
[~, lblsOrig] = loadImgsLblsStdSz(dataFolder, {'*.png', '*.jpg'}, ...
    desiredImgDims);
numOrigImgs = length(lblsOrig);
origLblsMap = containers.Map();
origLbls = cell(length(lblsOrig), 1);
for k = 1:numOrigImgs
    fileNoExtension = removeFileExtension(lblsOrig{k});
    origLbls{k} = fileNoExtension;
    origLblsMap(fileNoExtension) = k;
end

% create map object for the simulated annealing algorithm
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
        matchIndices = boolean(zeros(lLength, 1));

        for l = 1:lLength
            if m == 1
                lbl = validLbls{l};
            else
                lbl = trainLbls{l};
            end
            % TODO: Improve regex for robustness on filenames with matching
            % sub-strings at beginning
            match = regexp(lbl, "^(" + imgName + "(?=#ROT))", 'match');
            if ~isempty(match)
                if match{1} == imgName
                    if k == 1
                        numEach = numEach + 1;
                    end
                    matchIndices(l) = 1;  % store l value
                end
            end
        end
        matchList = find(matchIndices);
        assert(length(matchList) == numEach, ...
            sprintf("Different numbers of the same corresponding image " + ...
            "found in the validation data set: %d vs %d", numEach, ...
            length(matchList)))
        map(imgName) = matchList;
    end
    nbhMapsCell{m} = map;
end

%% Run Algorithm

% Generate confusion matrix using linear search
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
        histMatrixTrain, trainLbls, simAnnealMaxIter, simAnnealTInit, nbhMapsCell{2});
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
title("Confusion Matrix with Simulated Annealing Search");
sortClasses(cmSimAnneal, 'descending-diagonal')
