function [grph, origPoints] = image2Graph(grayImage, maxNodes, distanceThreshold)
    %IMAGE2GRAPH Summary of this function goes here
    %   Detailed explanation goes here
    
    % Generate the hough peaks
    [theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);
    origPoints = [theta', rho'];
    
    % Shift points with theta > 0 by -90 degrees; for points with a 
    % theta > 90 degrees: flip them about both the horizontal and vertical axes.
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
