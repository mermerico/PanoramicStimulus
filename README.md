In order to run this code you will need to download and install psychtoolbox 3: http://psychtoolbox.org/download

Once installed, run "RunStimulus" in Matlab

This code will generate a 60hz sine wave stimulus on your computer monitor. If you set align to True, you can move the windows that the sine wave is printed to
The parameters of this sine wave can be changed by modifying the file sin_sweep.txt which tells the program what function to call to draw the sine wave



For use with the Lightcrafter DLP
Change the variable paramFileName to “sin_sweep_lightcrafter.txt”
Change the variable windowsScreenId to the screen ID of the projector
Set the projector to monochrome green and the correct bit depth. The bit depth determines how fast the projector displays images (see dlp_manual.pdf)
sin_sweep_lightcrafter.txt generates a 180 Hz sine wave stimulus. This value in the .txt can be changed to any value of 180, 360, 720, 1440 Hz. Note that you must initialize your DLP to expect the correct corresponding bit depth of 7, 4, 2, and 1 respectively. A bit depth below 4 is not great for sine waves but will work for other types of stimuli. This DLP initialization can be performed with the DLP software provided by texus instruments or by the InitDLP function included here
CreateTexture at the bottom of SineWave_lightcrafter will correctly arrange the bitmap to display on a lightcrafter DLP even when presented at above 180hz. See the dlp_manual.pdf for an explanation of how the generated frames get compressed into the 3 frames that are sent to the DLP. In short: the DLP will always accept 3 8-bit colored frames. It will then present the bits of these frames in a specific order described in the manual. Create texture takes the sequence of images and puts them into this order.

Note: This code does not work if you try to tell the projector to go at 60Hz. Instead, in your matlab code simply generate the same image 3 times at 180 Hz
