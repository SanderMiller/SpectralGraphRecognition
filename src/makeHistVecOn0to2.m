function [histVec] = makeHistVecOn0to2(vec, nBins)
    %MAKEHISTVECON0TO2 Histogram vector for the eigenvalues of a 
    %normalized laplacian matrix 
    %   histVec = makeHistVecOn0to2(vec, nBins) returns a vector histVec
    %   containing the number of values in vec in the corresponding bins.
    %   A bin at position k in histVec counts the values in vec on the
    %   range [k*(2/nBins), (k+1)*(2/nBins)). However, because the
    %   eigenvalues of a normalized laplacian matrix are on a range of [0,
    %   2], the range of the last bin at k=nBins is modified s.t. its range
    %   is [k*(2/nBins), (k+1)*(2/nBins)].

    assert(max(vec)<=2, "The maximum value of vec cannot exceed 2");
    assert(min(vec)>=0, "The minimum value of vec cannot be less than 0");

    histVec = zeros(nBins, 1);
    divisor = 1 / nBins;
    for k = 1:length(vec)
        idx = floor((vec(k)/2)/(divisor));
        increment = 1;
        if vec(k) == 2
            increment = 0;
        end
        histVec(idx + increment) = histVec(idx + increment) + 1;
    end
end
