function [grph, normalizedPoints, points] = image2Graph(grayImage, maxNodes, distanceThreshold)
[theta, rho] = image2HoughPeaks(grayImage, 0.4, maxNodes);
points = [theta', rho'];
[normalizedTheta, shiftedRho] = houghPeakNormalization(theta, rho);
normalizedPoints = [normalizedTheta',shiftedRho'];
Adjacency = squareform(pdist(normalizedPoints)) < distanceThreshold;
grph = graph(Adjacency);