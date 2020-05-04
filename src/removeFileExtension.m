function fileNameNoExtension = removeFileExtension(fileName)
%REMOVEFILEEXTENSION Summary of this function goes here
%   Detailed explanation goes here
    matches = regexpi(fileName, '^([^\.])+', 'match');
    if ~(length(matches) == 1)
        error("There was an error with the filename in lbls_unique");
    end
    fileNameNoExtension = matches{1};
end

