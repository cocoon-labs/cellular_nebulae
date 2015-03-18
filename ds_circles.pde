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
String fname = "/Users/oren/Documents/Processing/ds_circles/arrangements/" + (new Date()).toString();
boolean created = new File(fname).mkdir();
double distFromCenter;

// audio crap
BPMDetector bpm;
Minim minim;
AudioPlayer sound;
OPC opc;

void setup() {
    println(created);
    size(displayWidth, displayHeight);
    //size(400, 400);
    background(255);
    opc = new OPC(this, "127.0.0.1", 7890);
  
    field = new Field(3, 4, 100, displayHeight, displayWidth, opc);
    //field = new Field(1, 1, 100, 400, 400, opc);
    minim = new Minim(this);
    //minim.debugOn();
  
    sound = minim.loadFile("cywf.mp3");
    bpm = new BPMDetector(sound);
    bpm.setup();
}

void draw() {
    //r = r + dir;
    //b = b + dir;
  
    //if (r == 256 || r == 0) {
    //  dir = -dir;
    //} 

    if (keyPressed && !justPressed) {
	justPressed = true;
	if ('a' <= key && key < 'a' + field.nPanels) {
	    field.placeCircles(key - 'a');
	} else if (key == '\n') {
      
	    // save the frame
	    save(fname + "/arrangement_" + fileIdx + ".png");
      
	    // dump the circles
	    dumpCircles();
	    fileIdx += 1;
	}
    } else if (!keyPressed) {
	justPressed = false;
    }
  
    /*if (bpm.isBeat()) {
	field.randomize();
	field.update();
    }*/
    bpm.isBeat();
    field.randomize();
    field.update();
    field.draw();
    //field.send();  
}

void dumpCircles() {
  try {
      PrintWriter writer = new PrintWriter(fname + "/circle_data_" + fileIdx + ".txt", "UTF-8");
      field.dumpCircles(writer);
      writer.close();
  } catch(Exception e) {
  }
}

void stop() {
    sound.close();
    minim.stop();
}
