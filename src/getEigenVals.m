function [eigenValues] = getEigenVals(G)
    %GETEIGENVALS Summary of this function goes here
    %   Detailed explanation goes here

    D = diag(degree(G)).^(-.5);
    D(~isfinite(D)) = 0;
    eigenValues = eig(D*full(laplacian(G))*D);
end
