%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = "data";
addpath(fullfile(curr_dir, "src"));
[valImgs, valLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'validate'),"*.png", [100, 100]);

%% Visualizing Image Graphs and Normalized Eigen Values 
[trainImgs, trainLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'train'),"*.png", [100, 100]);
trainImgsSz = size(trainImgs);
numPeaks = 100;
histogramMatrixTrain = uint32(zeros(trainImgsSz(1),20));
for a = 1:trainImgsSz(1)
  grayIm = squeeze(trainImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTrain(a,:) = currHistVec;
end

valImgsSz = size(valImgs);
histogramMatrixTest = uint32(zeros(valImgsSz(1),20));
for a = 1:valImgsSz(1)
  grayIm = squeeze(valImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTest(a,:) = currHistVec;
end

[~, lbls_unique] = load_imgs_std_sz_lbls(data_folder, {'*.png', '*.jpg'}, [200, 200]);
num_unique = length(lbls_unique);
confuseMtx = zeros(num_unique, num_unique);

numEachTrain = 0;
numEachValidate = 0;
lbls_unique_sz = size(lbls_unique);
validMap = containers.Map();
trainMap = containers.Map();
for k = 1:lbls_unique_sz(1)
    img_name_pre = lbls_unique{k};
    matches = regexpi(img_name_pre, '(?!\.)\w*', 'match');
    img_name = matches{1};
    
    validMatchIndices = boolean(zeros(valImgsSz(1), 1));
    for l = 1:trainImgsSz(1)
        trainLbl = trainLbls{l};
        match = regexp(trainLbl, "(" + img_name + ")", 'match');
        if ~isempty(match)
            if match{1} == img_name
                if k == 1
                    numEachValidate = numEachValidate + 1;
                end
                % store l value
                validMatchIndices(l) = 1;
            end
        end
    end
    validMatchList = find(validMatchIndices);
    assert(length(validMatchList) == numEachValidate, ...
        'Different numbers of the same corresponding image found in the validation data set')
    validMap(img_name) = validMatchList;
end

% for k = 1:num_unique
%     img_name_pre = lbls_unique{k};
%     matches = regexpi(img_name_pre, '(?!\.)\w*', 'match');
%     img_name = matches{1};
%     
%     for l = 1:valImgsSz(1)
%         valLbl = valLbls{k};
%         match = regexp(trainLbl, '(' + lbl + ')', 'match');
%         if match == img_name
%             
%         end
%     end
% end


