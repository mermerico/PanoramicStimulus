function RunStimulus
    % function executes a psych toolbox stimulus for the flies on the rigs
    path = fileparts(mfilename('fullpath'));
    addpath(genpath(path));
    
    % read in the parameters for the stimulus
    paramFileName = 'sin.tsv';
    parameters = GetParamsFromPaths(fullfile(path,paramFileName));
    
   
    % number of frames to run the stimulus for (your monitor is probably at
    % 60 hz)
    Nframes = 600;
    
    % set up initial parameters
    lastFrameChange = 1;
    currEpochNum = 1;
    currParam = parameters(currEpochNum);
    stimulusData = [];
    
    % initialize OpenGL rendering
    InitializeMatlabOpenGL
    
    % set the window to display the textures on. This should be
    % changed to the monitor number when a projector is attached.
    % You can look that up in display settings or just try out a
    % few. 0 should be all displays attached, 1 the first monitor,
    % and 2 is the second, etc
    windowsScreenId = 0;
    % set the size of the window (in pixels) to display.
    panoRect = [0 0 1000 1000];
    
    % Position in XYZ of the center of the display in mm relative to mouse
    % head. This is in OpenGL coordinate system (Y is up, -Z is in front).
    screenCenterLoc = [0,0,300];
    
    % Screen width and height in mm
    screenSize = [100 100];

    windowId = PsychImaging('OpenWindow',windowsScreenId,[0 0 0],panoRect);
    Screen('Fillrect',windowId,[0;0;0]);

    %% clear the screen when it exits
    clearScreen = onCleanup(@() sca);
    
    % Use common key names when reading keyboard status
    KbName('UnifyKeyNames');
    
    % keep the flip times to check for dropped frames
    lastFlipTime = 0;
    flipTimeArray = zeros(Nframes,1);
    
    % keep track of the the mouse's position in the virtual hallways (mm)
    currMousePosition = 0;
    
    %% giant for loop for every frame
    for frameNum = 1:Nframes
        %% Stop early if escape key is pressed
        [~,~,keyCodes] = KbCheck();
        if keyCodes(KbName('Escape'))
            break;
        end
        
        %% state-machine decides on which parameter set comes next
        framesSinceEpochChange = frameNum - lastFrameChange;
        [currEpochNum,stimChanged] = StateMachine(parameters,currEpochNum,framesSinceEpochChange);

        if stimChanged
            lastFrameChange = frameNum;
            currParam = parameters(currEpochNum);
        end

        %% insert your code for measuring the rotation of the treadmill here
        % Demo using keyboard:
        if keyCodes(KbName('UpArrow'))
            currMousePosition = currMousePosition + 10;
        end
        if keyCodes(KbName('DownArrow'))
            currMousePosition = currMousePosition - 10;
        end

        %% generate stimuli
        % Generate the textures
        stimFunc = str2func(currParam.stimtype);
        [textureHandles,stimulusData] = stimFunc(currParam,framesSinceEpochChange,currMousePosition,stimulusData,windowId);

        % Draw the hallway
        RenderHallway(windowId, textureHandles, currParam.repeatlength, screenCenterLoc, screenSize);

        %% flip buffers -- v-sync, and across DLPs if possible
        flipTimeArray(frameNum) = Screen('Flip',windowId,lastFlipTime+1/120,[],[],1);
        
    end
    
    numDroppedFrames = sum(diff(flipTimeArray)>0.02);
    percentDropped = numDroppedFrames/Nframes*100;
    fprintf('\n');
    disp([num2str(percentDropped) '% of frames dropped during presentation']);
end
