# USBmicroscope_openCV
This is a Processing sketch to be used with an USB microscope to do computer vision analysis. 

This program was writen in the third Digital Naturalism Conferece in Batticaloa, Sri Lanka. 
The main intention of the program is to reconigze movement under a USB microscope with the 
computer vision library openCV. By default it does some backgroundsubstraction on the image 
to draw the contours of beings moving under the microscope.The backgroudsubstraction allows to
draw just the contour of things moving. 

If you press the 'c' key you can acces to a backend, where you can adjust the parameters for 
your microscopic setting:

contrast, threshold, blur, blob size and sphere size. 
You can also draw center points in the middle of the contour and read the coordenates.
If you stop updating the backgroud, the movement will be draw permanently. 

Next step for this program is to send the cordenates of the counturs per OSC 
and make a pin-pon game for humans and non-human players. 

Thanks to Monica Rikic, Leonie Branberger and Andrew Quitmeyer for helping me with the software. 

Rodolfo Acosta Castro
