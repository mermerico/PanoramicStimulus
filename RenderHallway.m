function RenderHallway(windowId, textureHandles, repeatLength, screenCenterLoc, screenSize)

    global GL
  
    % each time, we've got to draw the background
    Screen('Fillrect',windowId,[0;0;0]);

    Screen('BeginOpenGL', windowId);

    % Setup all textures
    for ii = 1:5
        [gltexs(ii), gltextarget] = Screen('GetOpenGLTexture', windowId, textureHandles(ii));
        % Enable texture mapping for this type of textures...
        glEnable(gltextarget);

        % Bind our texture, so it gets applied to all following objects:
        glBindTexture(gltextarget, gltexs(ii));

        % Clamping behaviour shall be a cyclic repeat:
        glTexParameteri(gltextarget, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);

        % Set up minification and magnification filters.
        % use nearest neighbor filtering because we will be designing stimuli
        % on the pixel scale
        glGenerateMipmapEXT(GL.TEXTURE_2D);
        glTexParameteri(gltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
        glTexParameteri(gltextarget, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
    end

    % Set projection matrix: This defines a perspective projection,
    % corresponding to the model of a pin-hole camera - which is a good
    % approximation of the human eye and of standard real world cameras --
    % well, the best aproximation one can do with 3 lines of code ;-)
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    
    % Field of view is calculated in the y direciton. Aspect ratio is
    % calculated in x/y
    % all our distance units are in mm
    fov = 2*atand((screenSize(2)/2)/screenCenterLoc(3));
    aspectRatio = screenSize(1)/screenSize(2);
    gluPerspective(fov,aspectRatio,0.1,200000);

    % Setup modelview matrix: This defines the position, orientation and
    % looking direction of the virtual camera:
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;

    % Cam is located at 3D position (0,0,0), points upright (0,1,0) and fixates
    % at screen center:
    gluLookAt(0,0,0,screenCenterLoc(1),screenCenterLoc(2),screenCenterLoc(3),0,1,0);

    % Set background color to 'black' (shouldn't ever be seen):
    glClearColor(0,0,0,0);

    % Clear out the backbuffer:
    glClear;
    
    % Draw the hallway!
    hallParams.Width = 40;
    hallParams.Height = 40;
    hallParams.FloorHeight = -10;
    hallParams.Length = 100000;
    hallParams.Start = 0;
    
    drawHallway(hallParams, repeatLength, gltexs)

    
    Screen('EndOpenGL', windowId);
    Screen('Close', textureHandles);
    Screen('DrawingFinished', windowId);
end

function drawHallway(hallParams, repeatStartPos, textures)

    xNeg = -hallParams.Width/2;
    xPos =  hallParams.Width/2;
    yNeg = hallParams.FloorHeight;
    yPos = hallParams.FloorHeight + hallParams.Height;
    zNeg = hallParams.Start;
    zPos = hallParams.Length + hallParams.Start;
    cornerPositions=[ xNeg yNeg zNeg;
                      xPos yNeg zNeg;
                      xPos yPos zNeg;
                      xNeg yPos zNeg;
                      xNeg yNeg zPos;
                      xPos yNeg zPos;
                      xPos yPos zPos;
                      xNeg yPos zPos];
                  
    textureExtent = hallParams.Length/repeatStartPos;

    cubeface(cornerPositions([ 5 6 7 8 ],:), [1 1            ], textures(1)); %Front
    cubeface(cornerPositions([ 1 2 6 5 ],:), [1 textureExtent], textures(2)); %Bottom
    cubeface(cornerPositions([ 3 4 8 7 ],:), [1 textureExtent], textures(3)); %Top
    cubeface(cornerPositions([ 2 3 7 6 ],:), [1 textureExtent], textures(4)); %Left
    cubeface(cornerPositions([ 4 1 5 8 ],:), [1 textureExtent], textures(5)); %Right
    
end

% Subroutine for drawing of one face of a textured cube:
% Draw a quadrilateral polygon, defined by indices in vector 'idxs' and apply
% the texture image 'tx' to it:
function cubeface(vertexes, textureExtents, tx)

    % We want to access OpenGL constants. They are defined in the global
    % variable GL. GLU constants and AGL constants are also available in the
    % variables GLU and AGL...
    global GL

   
    % Bind (Select) texture 'tx' for drawing:
    glBindTexture(GL.TEXTURE_2D,tx); %TODO: this assumes GL.TEXTURE_2D, which is almost certainly right

    % Begin drawing of a new quad:
    glBegin(GL.QUADS);

    % Define vertex 1 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(0, 0);
    glVertex3f(vertexes(1,1),vertexes(1,2),vertexes(1,3));
    % Define vertex 2 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(textureExtents(1), 0);
    glVertex3f(vertexes(2,1),vertexes(2,2),vertexes(2,3));
    % Define vertex 3 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(textureExtents(1),textureExtents(2));
    glVertex3f(vertexes(3,1),vertexes(3,2),vertexes(3,3));
    % Define vertex 4 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(0, textureExtents(2));
    glVertex3f(vertexes(4,1),vertexes(4,2),vertexes(4,3));
    % Done with this polygon:
    glEnd;

end