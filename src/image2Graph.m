function [grph, normalizedPoints, points] = image2Graph(grayImage, maxNodes, distanceThreshold)

[theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);
points = [theta', rho'];

[normalizedTheta, shiftedRho] = houghPeakNormalization(theta, rho);

normalizedPoints = [normalizedTheta',shiftedRho'];
D = pdist(normalizedPoints);
Dist = squareform(D);
Adjacency = Dist.^-1;
Adjacency(Adjacency<(1/distanceThreshold)) = 0;
Adjacency(Adjacency==Inf) = 0;

grph = graph(Adjacency);