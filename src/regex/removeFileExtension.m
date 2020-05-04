function fileNameNoExtension = removeFileExtension(fileName)
%REMOVEFILEEXTENSION Summary of this function goes here
%   Detailed explanation goes here
    result = regexpi(fileName, '^([^\.])+', 'match');
    if ~(length(result) == 1)
        error("There was an error with the filename in lbls_unique");
    end
    fileNameNoExtension = result{1};
end

