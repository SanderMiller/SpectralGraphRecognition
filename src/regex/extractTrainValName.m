function fileName = extractTrainValName(fileNameWithInfo)
    %MATCHLBLTOIMGNAME Summary of this function goes here
    %   Detailed explanation goes here
    result = regexp(fileNameWithInfo, '^([^(#ROT)])+', 'match');
    if length(result) > 1
        error("More than one result was returned");
    end
    fileName = result{1}{1};  % TODO: understand why the result needs to
    % be indexed twice
end