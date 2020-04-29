function [normalizedTheta, shiftedRho] = houghPeakNormalization(theta, rho)
    %HOUGHPEAKNORMALIZATION Summary of this function goes here
    %   Detailed explanation goes here

    sortedTheta = sort(theta);
    difference = max(diff(sortedTheta));
    span = sortedTheta(end)- sortedTheta(1);

    if difference > 180-span %Check if the window of theta should be wrapped
        firstNode = sortedTheta(find(diff(sortedTheta) == difference)+1); %Find left most node in new window
        firstNode = firstNode(1);
        thetaShift = -90+(difference/2)-firstNode; %Calculate the delta theta value
        shiftedTheta = theta+thetaShift; %Shift the theta values

        %Generate List of out of window peaks
        wrappedPoints = ones(1,length(shiftedTheta)); 
        wrappedPoints = wrappedPoints - (2.*((shiftedTheta()<-90)+(shiftedTheta()>90))); 


        shiftedRho = rho.*wrappedPoints; %Multiply out of window rho values by -1

        %Shift out of window theta values back into -90 to 90 window
        shiftedTheta(shiftedTheta<-90) = shiftedTheta(shiftedTheta<-90)+180; 
        shiftedTheta(shiftedTheta>90) = shiftedTheta(shiftedTheta>90)-180;

        %Rotate Shifted Values
        rotationVal = ((deg2rad(abs(thetaShift))+2*pi)*shiftedTheta);
        shiftedRho = shiftedRho+rotationVal;

    else %Otherwise, simply center the points around theta = 0
        thetaShift = (span/2)-max(theta);%Calculate the delta theta value
        shiftedTheta = theta + thetaShift;%Shift the theta values
        %Rotate Shifted Values

        % unused?
        % rotationVal = ((deg2rad(abs(thetaShift))+2*pi)*shiftedTheta);

        shiftedRho = rho+0;
    end

    rhoSpan = max(shiftedRho)-min(shiftedRho);
    normalizedTheta = (rhoSpan/2).*(shiftedTheta./90);
end

