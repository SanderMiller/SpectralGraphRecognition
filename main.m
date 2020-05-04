%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = "data";
addpath(fullfile(curr_dir, "src"));
[valImgs, valLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'validate'),"*.png", [100, 100]);

%% Visualizing Image Graphs and Normalized Eigen Values 
[trainImgs, trainLbls] = load_imgs_std_sz_lbls(fullfile(data_folder, 'train'),"*.png", [100, 100]);
numPeaks = 100;

% load training images & labels
trainImgsSz = size(trainImgs);
histogramMatrixTrain = uint32(zeros(trainImgsSz(1),20));
for a = 1:trainImgsSz(1)
  grayIm = squeeze(trainImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTrain(a,:) = currHistVec;
end

% load test images & labels
valImgsSz = size(valImgs);
histogramMatrixTest = uint32(zeros(valImgsSz(1),20));
for a = 1:valImgsSz(1)
  grayIm = squeeze(valImgs(a, :, :));  
  [G,points] = image2Graph(grayIm,numPeaks,20);
  currHistVec = makeHistVecOn0to2(getEigenVals(G),20);
  histogramMatrixTest(a,:) = currHistVec;
end

% load source image labels
[~, lbls_unique] = load_imgs_std_sz_lbls(data_folder, {'*.png', ...
    '*.jpg'}, [200, 200]);
num_unique = length(lbls_unique);
confuseMtx = zeros(num_unique, num_unique);

lbls_unique_no_extension = cell(length(lbls_unique), 1);
for k = 1:num_unique
    matches = regexpi(lbls_unique{k}, '(?!\.)\w*', 'match');
    if ~(length(matches) == 1)
        error("There was an error witht the filename in lbls_unique");
    end
    lbls_unique_no_extension{k} = matches{1};
end

% match source image labels to 
maps_cell = cell(2, 1);
for m = 1:2
    numEach = 0;
    map = containers.Map();
    trainMap = containers.Map();
    for k = 1:num_unique
        img_name = lbls_unique_no_extension{k};
        
        if m == 1
            l_length = valImgsSz(1);
        else
            l_length = trainImgsSz(1);
        end
        validMatchIndices = boolean(zeros(l_length, 1));
        
        for l = 1:l_length
            if m == 1
                lbl = valLbls{l};
            else
                lbl = trainLbls{l};
            end
            match = regexp(lbl, "^(?!(ROT))(" + img_name + ")", 'match');
            
            if ~isempty(match)
                if match{1} == img_name
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
        map(img_name) = validMatchList;
    end
    maps_cell{m} = map;
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


