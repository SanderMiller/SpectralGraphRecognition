function [eigenValues] = getEigenVals(G)
D = diag(degree(G)).^(-.5);
D(~isfinite(D)) = 0;
eigenValues = eig(D*full(laplacian(G))*D);
end
