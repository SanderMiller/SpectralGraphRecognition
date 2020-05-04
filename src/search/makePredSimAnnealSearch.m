function pred = makePredSimAnnealSearch(inputImgHist, trainImgsHist, ...
    trainLbls, maxIters, tInit, trainNbhMap)
    %MAKEPREDSIMANNEALSEARCH Summary of this function goes here
    %   Detailed explanation goes here
    
    assert(maxIters > 1, "`maxIters` must be > 1");
    assert(tInit > 1, "`tInit` must be > 1");
    
    trainImgsSz = size(trainImgsHist);
    minDist = -1;
    minIdx = 0;
    xInit = randi(trainImgsSz(1));  % randomly select initial condition
    n = NeighborFinder(trainNbhMap, xInit);
    inputImgHistDouble = double(inputImgHist);
    
    for k = 1:maxIters
        t = ((k + 1) / maxIters) * tInit;
        
        xNew = n.retNeighbor();
        xNewHist = squeeze(trainImgsHist(xNew, :));
        xNewDist = ws_distance(double(xNewHist), inputImgHistDouble, 2);
        
        if xNewDist < minDist || minDist == -1
            probability = 1;
            minIdx = n.x;
            minDist = xNewDist;
        else
            probability = exp(-(xNewDist - minDist) / t);
        end
        
        randNum = rand;
        if randNum <= probability
            n.changeX(xNew);
        end
    end
    pred = extractTrainValName(trainLbls(minIdx));
end
