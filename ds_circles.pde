import java.util.Random;
import java.lang.Math;
import java.util.Date;
import ddf.minim.analysis.*;
import ddf.minim.*;

int[][] circles = new int[9][];
int[][] colors = new int[9][3];
int x, y, diam, placeMin, placeMax;
int r, g, b;
Random rand = new Random();
int nCircles = 9;
int dim = 40;
boolean justPressed = false;
int tallBound = 4 * dim;
int midBound = 7 * dim;
Field field;

// random crap
int dir = 1;
int fileIdx = 1;
String fname = "/Users/oren/circles/" + (new Date()).toString();
boolean created = new File(fname).mkdir();
double distFromCenter;

// audio crap
BPMDetector bpm;
Minim minim;
AudioPlayer sound;

void setup() {
  size(displayWidth, displayHeight);
  background(255);
  
  field = new Field(2, 3, 100, displayHeight, displayWidth);
  minim = new Minim(this);
  //minim.debugOn();
  
  sound = minim.loadFile("Deva_Victrix.mp3");
  bpm = new BPMDetector(sound);
  bpm.setup();
}

void draw() {
  //r = r + dir;
  //b = b + dir;
  
  //if (r == 256 || r == 0) {
  //  dir = -dir;
  //} 

  /*if (keyPressed && !justPressed) {
    justPressed = true;
    if (key == 'n') {      
      background(255);
      newCircles();      
    } else if (key == 'p') {
      println("print the circles!!");
      
      // save the frame
      save(fname + "/circle_arrangement_" + fileIdx + ".png");
      
      // dump the circles
      dumpCircles();
      fileIdx += 1;
    }
  } else if (!keyPressed) {
    justPressed = false;
  }*/
  
  if (bpm.isBeat()) {
    field.randomize();
    field.update();
  }
  field.draw();
  //field.send();  
}

/*void dumpCircles() {
  try {
    PrintWriter writer = new PrintWriter(fname + "/circle_data_" + fileIdx + ".txt", "UTF-8");
    for (int i = 0; i < nCircles; i++) {
      float x = circles[i][0] / (dim*1.0);
      float y = circles[i][1] / (dim * 1.0);
      diam = circles[i][2] / dim;
      writer.println("Center: (" + x  + ", " + y + ")   Radius: " + diam + "   Height: " + circles[i][3]); 
    }
    writer.close();
  } catch(Exception e) {
  }
}*/

void stop() {
  sound.close();
  minim.stop();
}
