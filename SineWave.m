function [texStr,stimData] = SineWave(parameters,framesSinceEpochChange,stimData,windowId)
    % basic sinewave stimulus. Can produce rotation and translation where
    % the opposite eye is the first eye's mirror image

    % read in parameters
    if parameters.numDeg == 0
        sizeX = 1;
    else
        sizeX = round(360/parameters.numDeg);
    end

    mlum = parameters.lum;
    c = parameters.contrast;
    vel = parameters.temporalFrequency*parameters.lambda*pi/180;
    lambda = parameters.lambda*pi/180; %wavelength in radians
    
    %% left eye
    if framesSinceEpochChange == 0 && ~isfield(stimData,'sinPhase')
        stimData.sinPhase = 0;
    end

    theta = (0:sizeX-1)/sizeX*2*pi; %theta in radians
    bitMap = zeros(1,sizeX,3);

    stimData.sinPhase = stimData.sinPhase + vel/(60*3);
    
    for cc = 1:3
        bitMap(1,:,cc) = c*sin(2*pi*(theta-stimData.sinPhase)/lambda);
    end

    bitMap = 255*mlum*(1 + bitMap);

    %% right eye
    if parameters.twoEyes
        leftEyeInd = 1:floor(size(bitMap,2)/2);
        rightEyeInd = 1:ceil(size(bitMap,2)/2);
        
        bitMap = [bitMap(:,leftEyeInd,:) fliplr(bitMap(:,rightEyeInd,:))];
    end

    %always include this line in a stim function to make the texture from the
    %bitmap

    texStr = Screen('MakeTexture', windowId, bitMap, [], 1);
end