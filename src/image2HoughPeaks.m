function [theta, rho] = image2HoughPeaks(grayImage, edgeThreshold, numPeaks)
    %IMAGE2HOUGHPEAKS Summary of this function goes here
    %   Detailed explanation goes here
    
    %Conduct Edge Detection on Image
    edgeIm = edge(grayImage, 'Canny', edgeThreshold);
    %Generate Hough Transform on edge detected Image
    [H,T,R] = hough(edgeIm);

    %Calculate Peaks of Hough Transorm
    P  = houghpeaks(H, numPeaks, 'threshold', ceil(0.0*max(H(:))));

    theta = T(P(:,2)); 
    rho = R(P(:,1));
end
