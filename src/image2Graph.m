function [grph] = image2Graph(grayImage, maxNodes, distanceThreshold)
    %IMAGE2GRAPH Summary of this function goes here
    %   Detailed explanation goes here
    
    [theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);
<<<<<<< HEAD
    origPoints = [theta', rho'];
    shiftedTheta = theta-90
    wrappedPoints = ones(1,length(shiftedTheta)); 
    wrappedPoints = wrappedPoints - (2.*((shiftedTheta()<-90))); 
    shiftedTheta(shifteTheta<-90) = shiftedTheta(shiftedTheta<-90)+180; 
    shiftedRho = rho.*wrappedPoints;
    shiftedPoints = [shiftedTheta',shiftedRho']
    dist1 = squareForm(pdist(origPoints))
    dist2 = squareForm(pdist(shiftedPoints))
    shortestDist = min(dist1,dist2)
    grph = graph(shortestDist < ...
        distanceThreshold) - eye(length(normalizedPoints));
=======
    points = [theta', rho'];
    [normalizedTheta, shiftedRho] = houghPeakNormalization(theta, rho);
    normalizedPoints = [normalizedTheta',shiftedRho'];
    grph = graph((squareform(pdist(normalizedPoints)) < ...
        distanceThreshold) - eye(length(normalizedPoints)));
>>>>>>> 766d00f6393b1db5d48c72b6711da5c00a28c868
end
