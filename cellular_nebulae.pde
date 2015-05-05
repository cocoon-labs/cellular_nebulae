import java.util.Random;
import java.lang.Math;
import java.util.Date;
import java.awt.Color;
import ddf.minim.analysis.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;

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

// Open sound control business
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  minim = new Minim(this);

  // minim.debugOn();

  // Line in
  // in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  // bpm = new BPMDetector(in);

  // MP3 in
  // size(displayWidth, displayHeight);
  // background(255);
  sound = minim.loadFile(song);
  bpm = new BPMDetector(sound);

  bpm.setup();

  opc = new OPC(this, "127.0.0.1", 7890);
  field = new Field(3, 4, 500, displayHeight, displayWidth, opc);

  oscP5 = new OscP5(this,5001);
 
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("192.168.1.101",5001);
}

void draw() {
  processUserInput();
  field.randomize();
  field.update();
  // field.draw();
  field.send();
}

void oscEvent(OscMessage theOscMessage) 
{  
  println("gotcha");

  // get the first value as an integer
  float theValue = theOscMessage.get(0).floatValue();
  // float theValue2 = theOscMessage.get(1).floatValue();

  if (theOscMessage.addrPattern().equals("/1/mode/3/1") && theValue == 1.0) {
    field.setMode((field.mode + 1) % field.modes.length);
  } else if (theOscMessage.addrPattern().equals("/1/mode/3/2") && theValue == 1.0) {
    field.setMode(11);
    field.setVibeWhite();
    globalBrightness = 255;
    modeSwitching = false;
    modeC = 0;
  } else if (theOscMessage.addrPattern().equals("/1/mode/3/3") && theValue == 1.0) {
    field.incVibe();
  } else if (theOscMessage.addrPattern().equals("/1/mode/3/4") && theValue == 1.0) {
    field.newScheme();
  }
  // print out the message
  print("OSC Message Recieved: ");
  println("address pattern: " + theOscMessage.addrPattern());
  println("type tag: " + theOscMessage.typetag());
  // println(theValue);
  // println(theValue2);
  // println(firstValue + " " + secondValue + " " + thirdValue);
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
