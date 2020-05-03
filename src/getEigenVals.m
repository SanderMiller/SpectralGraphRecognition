function [eigenValues] = getEigenVals(G)
    %GETEIGENVALS Summary of this function goes here
    %   Detailed explanation goes here

    D = diag(degree(G).^(-.5));
    Lnorm = D*full(laplacian(G))*D;
    Lnorm(isnan(Lnorm)) = 0;
    eigenValues = eig(Lnorm);
    eigenValues(abs(eigenValues) < 0.0001) = 0;
    eigenValues(abs(eigenValues - 2) < 0.0001) = 0; 
end
