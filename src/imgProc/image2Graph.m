function [grph, origPoints] = image2Graph(grayImage, maxNodes, distanceThreshold)
    %IMAGE2GRAPH Summary of this function goes here
    %   Detailed explanation goes here
    
    [theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);
    origPoints = [theta', rho'];
    shiftedTheta = theta - 90;
    wrappedPoints = ones(1, length(shiftedTheta)); 
    wrappedPoints = wrappedPoints - (2.*((shiftedTheta()<-90))); 
    shiftedTheta(shiftedTheta < -90) = shiftedTheta(shiftedTheta < -90) + 180; 
    shiftedRho = rho.*wrappedPoints;
    shiftedPoints = [shiftedTheta', shiftedRho'];
    dist1 = squareform(pdist(origPoints, 'cityblock'));
    dist2 = squareform(pdist(shiftedPoints, 'cityblock'));
    shortestDist = min(dist1, dist2);
    grph = graph((shortestDist < distanceThreshold) - ...
        eye(length(shiftedPoints)));

end
