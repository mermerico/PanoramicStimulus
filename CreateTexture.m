function tex = CreateTexture(bitMap,framesPerUp,windowId)
    % this function will package the bits of the bitmap so that a
    % lightcrafter DLP 3000 will present them in the correct order

    outMap = uint8(zeros(size(bitMap,1),size(bitMap,2),4));
    
    %%%%%% THIS ONLY WORKS IF framesPerUp IS DIVISIBLE BY 3
    assert(mod(framesPerUp,3)==0)
    
    bitMap(bitMap>255) = 255;
    bitMap(bitMap<0) = 0;
    
    % no compression necessary if at framesPerUp of 3
    if framesPerUp ~= 3
        fpc = framesPerUp/3;
        % puts the bitMap into values between 0 and the bitsize
                
        nBitMap = uint8(bitMap.*255);
        nBitMap = nBitMap/uint8(255/(2^(8/fpc)-1));

        weights = repmat(uint8(2.^(0:(8/fpc):7)),[1 3]);
        weights = permute(weights,[1 3 2]);
        
        % weight the matrix so that the bits are properly shifted
        wBitMap = bsxfun(@times,nBitMap,weights);

        % now that the bits are aligned simply sum them together
        for ii = 1:3
            outMap(:,:,ii) = sum(wBitMap(:,:,((ii-1)*fpc+1):ii*fpc),3);
        end
    else
        outMap(:,:,1:3) = uint8(bitMap);
    end
    
    % add alpha values to outMap. They won't be used but they keep
    % makeTexture from converting the format, slowing down, and droping
    % frames.
    repX = ceil(size(outMap,2)/2);
    repY = size(outMap,1);
    alpha = repmat([100 200],[repY,repX]);
    outMap(:,:,4) = alpha(:,1:size(outMap,2));
    
    % put bitMap in the right order for the lightcrafter
    outMap = outMap(:,:,[2 3 1 4]);
    
    tex = Screen('MakeTexture', windowId, outMap, [], 1);
end