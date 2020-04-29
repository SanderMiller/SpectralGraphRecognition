function [eigenValues] = getEigenVals(G)
D = diag(degree(G));
L = full(laplacian(G));
D = D.^-.5;
D(~isfinite(D)) = 0;
symL = D*L*D;
eigenValues = eig(symL);
