function [eigenValues] = getEigenVals(grph)
    %GETEIGENVALS Summary of this function goes here
    %   Detailed explanation goes here

    degreeMat = diag(degree(grph).^(-.5));
    lNorm = degreeMat*full(laplacian(grph))*degreeMat;
    lNorm(isnan(lNorm)) = 0;  % normalized laplacian matrix of G
    eigenValues = eig(lNorm);
    eigenValues(abs(eigenValues) < 0.0001) = 0;
    eigenValues(abs(eigenValues - 2) < 0.0001) = 0; 
end
