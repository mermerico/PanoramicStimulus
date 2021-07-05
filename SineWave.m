function [texStrs,stimData] = SineWave(parameters,framesSinceEpochChange,currMousePosition,stimData,windowId)
    % basic sinewave stimulus. Shows sine wave on all surfaces

    % read in parameters
    sizeX = parameters.ppmm * parameters.repeatlength; % texture size is pixels per mm * length before repeat

    mlum = parameters.lum;
    c = parameters.contrast;
    lambda = parameters.lambda; %wavelength in mm

    x = (0:sizeX-1)*parameters.repeatlength/sizeX; %create a map from pixels to position in mm
    bitMap = zeros(1,sizeX,3);
    
    for cc = 1:3
        bitMap(1,:,cc) = c*sin(2*pi*(x+currMousePosition)/lambda);
    end

    bitMap = 255*mlum*(1 + bitMap);

    % Now we will create textures on the graphics card that will be mapped
    % onto the walls of the hallways. These are arranged in order: front,
    % bottom, top, left, right. In this case, we will use the same texture
    % for all surfaces.
    for ii = 1:5
        texStrs(ii) = Screen('MakeTexture', windowId, bitMap, [], 1);
    end
end