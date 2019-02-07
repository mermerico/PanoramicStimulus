function [texStr,stimData] = SineWave_lightcrafter(parameters,framesSinceEpochChange,stimData,windowId)
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
    
    % number of frames to generate per 60 Hz update
    assert(mod(parameters.projectorFreq,60)==0)
    framesPerUp = parameters.projectorFreq/60;
    
    % update rate of the stimulus
    
    
    %% left eye
    if framesSinceEpochChange == 0 && ~isfield(stimData,'sinPhase')
        stimData.sinPhase = 0;
    end

    theta = (0:sizeX-1)/sizeX*2*pi; %theta in radians
    bitMap = zeros(1,sizeX,framesPerUp);
    
    for cc = 1:framesPerUp
        stimData.sinPhase = stimData.sinPhase + vel/(60*framesPerUp);
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

    texStr = CreateTexture(bitMap,framesPerUp,windowId);
end