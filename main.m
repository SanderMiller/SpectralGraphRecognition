%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = "data";
addpath(fullfile(curr_dir, "src"));
[valImgs, valLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'validate'),"*.png", [100, 100]);

%% Visualizing Image Graphs and Normalized Eigen Values 
[trainImgs, trainLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'train'),"*.png", [100, 100]);
x = size(trainImgs);
numPeaks = 100;
histogramMatrixTrain = uint32(zeros(x(1),20));
for a = 1:x(1)
  grayIm = squeeze(trainImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTrain(a,:) = currHistVec;
end

y = size(valImgs);
histogramMatrixTest = uint32(zeros(y(1),20));
for a = 1:y(1)
  grayIm = squeeze(valImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTest(a,:) = currHistVec;
end

[~, lbls_unique] = load_imgs_std_sz_lbls(data_folder, {'*.png', '*.jpg'}, [200, 200]);
num_unique = length(lbls_unique);
confuseMtx = zeros(num_unique, num_unique);

for k = 1:num_unique
    img_name_pre = lbls_unique{k};
    matches = regexpi(img_name_pre, '(?!\.)\w*', 'match');
    img_name = matches{1};
end


