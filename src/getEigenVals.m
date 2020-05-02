function [eigenValues] = getEigenVals(G)
    %GETEIGENVALS Summary of this function goes here
    %   Detailed explanation goes here

    D_vec = degree(G).^(-.5);
    D = diag(D_vec);
    eigenValues = eig(D*full(laplacian(G))*D);
end
