function pred = makePredLinSearch(inputImgHist, trainImgsHist, trainLbls)
    %MAKEPREDLINSEARCH Summary of this function goes here
    %   Detailed explanation goes here
    
    trainImgsSz = size(trainImgsHist);
    distVec = zeros(trainImgsSz(1), 1);
    minVal = -1;
    minIdx = 0;
    for k = 1:trainImgsSz(1)
        distVec(k) = ws_distance(double(inputImgHist), double(squeeze(trainImgsHist(k, :))), 1);
        if minVal < 0 || distVec(k) < minVal
            minVal = distVec(k);
            minIdx = k;
        end
    end
    pred = extractTrainValName(trainLbls(minIdx));
end

