import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import controlP5.*;

Capture cam;
OpenCV opencv;
ControlP5  cp5;

ArrayList<Contour> contours;

int blobSizeMin = 20;
float contrast = 1.5;
int blur = 0;
int threshold = 80;
int sphereSize = 10;

boolean use_invert = false;
boolean center_points = false;
boolean cam_background = true;


PImage opencv_original, filtrada, threshold_img, nueva;
boolean controls_visibles = false;



void setup() {
  
  String[] cameras = Capture.list();
  
  size(displayWidth, displayHeight);
  cam = new Capture(this, displayWidth, displayHeight,cameras[0]);
  opencv = new OpenCV(this, displayWidth, displayHeight);
  
  //size(720, 404);
  //cam = new Capture(this, 720, 404,cameras[0]);
  //opencv = new OpenCV(this, 720, 404);
  
  cp5 = new ControlP5 (this);
  
  opencv.startBackgroundSubtraction(5, 3, 0.2);
  cam.start();
  initControls();

}

void draw() {
  


                                 /***filters***/
  opencv.gray();
  opencv.contrast(contrast);
  opencv.blur(blur);
  opencv.dilate();
  opencv.erode();
  filtrada  = opencv.getSnapshot();
  
                            /***imagen invertida***/
  if (use_invert){
  opencv.invert();
  }
  opencv.threshold(threshold);
  threshold_img = opencv.getSnapshot();
  

                   /***encontrar los contornos de la ultima imagen ***/
  
  if (controls_visibles == true){
  
    pushMatrix ();
    scale (0.5);
    image (cam,0,0);  
    image (filtrada, width, 0);
    image (threshold_img, 0, height);
    //image (cam, width, height); //not necesary already included in drawMovement
    translate (width, height); // invertir el orden de las imagenes 
    drawMovement();  //dibujar contornos en movimiento sobre imagen 
    popMatrix (); 
    cp5.show();

  }else{
    drawMovement();
    cp5.hide();
   } 
   
}

                 /*******functions*******/


void captureEvent(Capture c) {
  c.read();
}

void keyReleased (){
  
  if (key == 'c'){
    if (controls_visibles == true){
      controls_visibles = false;
  }else {
    controls_visibles = true;
     }
  }
}
   
void drawMovement (){
 
 opencv.loadImage(cam);
 opencv.updateBackground();
 opencv.threshold(threshold);
 
 opencv.contrast(contrast);
 opencv.blur(blur);
 opencv.dilate();
 opencv.erode();
  
  if (use_invert){
  opencv.invert();
  }
 contours = opencv.findContours (true,true);
 if (cam_background){
 image (cam,0,0);
 }
    
for (int i=0; i<contours.size (); i++){
  Contour contour = contours.get(i);
  Rectangle r = contour.getBoundingBox();
  noFill ();
  stroke (0,255,0);
  contour.draw();
  
  if (r.width >blobSizeMin||r.height>blobSizeMin) {
    stroke (255,0,0);
    fill(187,5,255,63);
    rect (r.x,r.y, r.width, r.height);
   
 if (center_points){
     
   pushMatrix();
    translate (r.width/2, r.height/2); // invertir el orden de las imagenes 
    fill(252,182,2);
    ellipse (r.x,r.y, sphereSize, sphereSize);
    print("center points:");
    print(r.x);
    print (" ,");
    println (r.y);   
   popMatrix();
   
         }

  }
 }
}   


void initControls () {

  cp5.addSlider ("contrast")
    .setLabel("contrast")
    .setPosition(width/2+20,20)
    .setRange (0.0, 5.0)
    .setSize (80,10)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
   cp5.addSlider ("blur")
    .setLabel("blur")
    .setPosition(width/2+20,40)
    .setRange (1, 30)
    .setSize (80,10)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
  
   cp5.addSlider ("threshold")
    .setLabel("threshold")
    .setPosition(20, width/2+20)
    .setRange (0, 255)
    .setSize (80,10)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
  cp5.addToggle ("use_invert")
    .setLabel ("invert")
    .setPosition(20, height/2+20)
    .setSize (20,20)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
   cp5.addSlider ("blobSizeMin")
    .setLabel("blobSizeMin")
    .setPosition(width/2+20,height/2+20 )
    .setRange (0, 150)
    .setSize (80,10)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
  cp5.addSlider ("sphereSize")
    .setLabel("sphereSize")
    .setPosition(width/2+20,height/2+40 )
    .setRange (10, 60)
    .setSize (80,10)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
   cp5.addToggle ("center_points")
    .setLabel ("center points")
    .setPosition(width/2+20,height/2+60 )
    .setSize (20,20)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
    
  cp5.addToggle ("cam_background")
    .setLabel ("cam background")
    .setPosition(width/2+20,height/2+100 )
    .setSize (20,20)
    .setColorBackground (color (155,155,155))
    .setColorForeground (color(252,182,2))
    .setColorActive (color (155,255,0))
    .setColorValue (color(0,0,0));
}
