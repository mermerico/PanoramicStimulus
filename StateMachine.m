function [newEpoch,CH] = StateMachine(parameters,currEpochNum,framesSinceEpochChange)
    CH = (framesSinceEpochChange >= parameters(currEpochNum).duration);

    if ~CH || (length(parameters)==1)  % stay here
        newEpoch=currEpochNum;
    else
        OT = parameters(currEpochNum).ordertype;

        switch OT
            case 0 % default, random interleave
                if (currEpochNum ~= 1) % not at interleave, so go to interleave
                    newEpoch = 1;
                else     % at interleave, so go to random epoch
                    newEpoch = ceil((length(parameters)-1)*rand+1);
                end
        end
    end
end