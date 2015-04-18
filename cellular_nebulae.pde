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

// remote stuff
int globalBrightness = 255;
boolean modeSwitching = false;
int modeC = 0;

Random rand = new Random();
int bufferSize = 1024;
float sampleRate = 44100;
static String[] args;
String song = "otod.mp3";

void setup() {
  minim = new Minim(this);

  minim.debugOn();

  // Line in
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  bpm = new BPMDetector(in);

  // MP3 in
  // size(displayWidth, displayHeight);
  // background(255);
  // minim = new Minim(this);
  // sound = minim.loadFile(song);
  // bpm = new BPMDetector(sound);

  bpm.setup();

  opc = new OPC(this, "127.0.0.1", 7890);
  field = new Field(3, 4, 500, displayHeight, displayWidth, opc);
}

void draw() {
  processUserInput();
  field.randomize();
  field.update();
  // field.draw();
  field.send();
}

void processUserInput() {
  if (keyPressed && !justPressed) {
    justPressed = true;
//    if ('a' <= key && key < 'a' + field.nPanels) {
//      field.placeCircles(key - 'a');
//    } else
    if (key == '\n') {
      
      // save the frame
      save(fname + "/arrangement_" + fileIdx + ".png");
      
      // dump the circles
      serialize();
      fileIdx += 1;
    } else if (key == '\t' || key == 'z') {
      field.newScheme();
    } else if (key == 'm') {
      field.setMode((field.mode + 1) % field.modes.length);
    } else if (key == 'd') {
      globalBrightness = constrain(globalBrightness - 5, 0, 255);
    } else if (key == 'c') {
      globalBrightness = constrain(globalBrightness + 5, 0, 255);
    } else if (key == 'j') {
      modeSwitching = !modeSwitching;
    } else if (key == 'g') {
      field.setVibeWhite();
    } else if (key == 'h') {
      field.incVibe();
    } else if (key >= '2' && key <= '9') {
      field.setMode(key - 46);
    } else if (key == '1') {
      field.incFFTMode();
    } else if (key == 'a') {
      modeC = (int) constrain(modeC + 1, 0, 3);
    } else if (key == 'b') {
      modeC = (int) constrain(modeC - 1, 0, 3);
    } else if (key == 'i') {
      field.setMode(11);
      field.setVibeWhite();
      globalBrightness = 255;
      modeSwitching = false;
      modeC = 0;
    } else if (key == 'x') {
      field.adjustDelay(10);
    } else if (key == 'y') {
      field.adjustDelay(-10);
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
