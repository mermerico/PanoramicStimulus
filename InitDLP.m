function InitDLP()
    %this script sets all the projectors to HDMI Video Input
    %then sets their video mode settings to 60 hz 8 bit and monochrome green

    list = 1:5;
    current = 1;
    bitDepth = 7;
    color = [ 3 ];
    
    if current > 1
        current = 1;
    end
    
    current = round(current*274);
    
    DLP = LightCrafter();
    
    try
        tcpObject = tcpip('192.168.1.100',21845);
        fopen(tcpObject);
    catch err
        error('rig didnt connect');
    end

    DLP.setDisplayModeHDMIVideoInput(tcpObject);
    pause(0.01);
    DLP.setVideoModeSetting(tcpObject,bitDepth,color);
    pause(0.01);
    DLP.setLEDcurrent(tcpObject,current);
    pause(0.01);
    fclose(tcpObject);
end