import java.util.Random;
import java.lang.Math;
import java.util.Date;
import java.awt.Color;
import ddf.minim.analysis.*;
import ddf.minim.*;

boolean justPressed = false;
Field field;

// files and crap
int fileIdx = 1;
String fname = 
  "/Users/oren/Documents/Processing/ds_circles/arrangements/" +
  (new Date()).toString();
boolean created = new File(fname).mkdir();

// audio crap
BPMDetector bpm;
Minim minim;
AudioPlayer sound;
AudioInput in;
OPC opc;

Random rand = new Random();
int bufferSize = 1024;
float sampleRate = 44100;
static String[] args;
String song = "sio.mp3";

void setup() {
  minim = new Minim(this);

  minim.debugOn();

  // if (args.length > 0 && args[0] == "--prod=true") {
  //   in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  //   bpm = new BPMDetector(in);
  // } else {
    size(displayWidth, displayHeight);
    background(255);
    minim = new Minim(this);
    sound = minim.loadFile(song);
    bpm = new BPMDetector(sound);
  // }
  bpm.setup();

  opc = new OPC(this, "127.0.0.1", 7890);
  field = new Field(3, 4, 500, displayHeight, displayWidth, opc);
}

void draw() {
  processUserInput();
  field.randomize();
  field.update();
  field.draw();
  // field.send();
}

void processUserInput() {
  if (keyPressed && !justPressed) {
    justPressed = true;
    if ('a' <= key && key < 'a' + field.nPanels) {
      field.placeCircles(key - 'a');
    } else if (key == '\n') {
      
      // save the frame
      save(fname + "/arrangement_" + fileIdx + ".png");
      
      // dump the circles
      serialize();
      fileIdx += 1;
    } else if (key == '\t') {
      field.newScheme();
    } else if (key == 'm') {
      field.mode = (field.mode + 1) % field.modes.length;
    }
  } else if (!keyPressed) {
    justPressed = false;
  }
}

void serialize() {
  try {
    PrintWriter writer = new PrintWriter(fname + "/circle_data_" + fileIdx + ".txt", "UTF-8");
    field.serialize(writer);
    writer.close();
  } catch(Exception e) {
  }
}

void stop() {
  sound.close();
  minim.stop();
}

// static public void main(String[] argv) {
//   args = argv.clone();
//   PApplet.main(new String[] { "cellular_nebulae" });
// }
