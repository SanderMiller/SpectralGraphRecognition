function [grph, points] = image2Graph(grayImage, maxNodes, distanceThreshold)

[theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);

[shiftedTheta, shiftedRho, thetaShift] = houghPeakNormalization(theta, rho);

rhoSpan = max(shiftedRho)-min(shiftedRho);
normalizedTheta = (rhoSpan/2).*(shiftedTheta./90);

points = [normalizedTheta',shiftedRho'];
D = pdist(points);
Dist = squareform(D);
Adjacency = Dist.^-1;
Adjacency(Adjacency<(1/distanceThreshold)) = 0;
Adjacency(Adjacency==Inf) = 0;

grph = graph(Adjacency);