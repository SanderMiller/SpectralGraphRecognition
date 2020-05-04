function pred = makePred(inputImgHist, trainImgsHist, trainLbls, ...
    searchType)
    %MAKEPRED Summary of this function goes here
    %   Detailed explanation goes here
    
    trainImgsSz = size(trainImgsHist);
    
    switch searchType
        case 'linear'
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
        
        case 'simanneal'
            % TODO
            error("Simulated annealing search not yet implemented");
        
        otherwise
            error("Passed value of " + searchType + ...
                " for argument `searchType` was not valid");
    end
end

