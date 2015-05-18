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
boolean houseLightsOn = false;
float intraloopWSF = 1.0; // WSF = wheel step factor
float interloopWSF = 1.0; // WSF = wheel step factor
int delay = 0;

Random rand = new Random();
int bufferSize = 1024;
float sampleRate = 44100;
static String[] args;
String song = "otod.mp3";

// Open sound control business
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddressList myNetAddressList = new NetAddressList();
int myListeningPort = 5001;
int myBroadcastPort = 12000;

void setup() {
  minim = new Minim(this);

  // debug mode (NO PANELS)
  size(displayWidth, displayHeight);
  background(255);

  // minim.debugOn();

  // Line in
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  bpm = new BPMDetector(in);

  // MP3 in
  // sound = minim.loadFile(song);
  // bpm = new BPMDetector(sound);

  bpm.setup();

  opc = new OPC(this, "127.0.0.1", 7890);
  field = new Field(3, 4, 500, displayHeight, displayWidth, opc);
  
  oscP5 = new OscP5(this, myListeningPort);
 
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("192.168.1.149", myListeningPort);
  
}

void draw() {
  field.randomize();
  field.update();
  field.draw();
  // field.send();
}

void oscSync()
{
  OscMessage message;
  
  oscSyncMode();
  
  message = new OscMessage("/random");
  message.add(modeSwitching ? 1.0 : 0.0);
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/house");
  message.add(houseLightsOn ? 1.0 : 0.0);
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/faders/1");
  message.add(field.getModeChanceForFader());
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/faders/2");
  message.add(map(globalBrightness, 0.0, 255.0, 0.0, 1.0));
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/faders/3");
  message.add(map(field.getDelay(), 0.0, 255.0, 0.0, 1.0));
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/faders/4");
  message.add(map(intraloopWSF, 0.0, 5.0, 0.0, 1.0));
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/faders/5");
  message.add(map(interloopWSF, 0.0, 5.0, 0.0, 1.0));
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/xy0");
  float[] vals = field.getAlgebraVals();
  message.add(vals[1]);
  message.add(vals[0]);
  oscP5.send(message, myNetAddressList);
  
  message = new OscMessage("/xy1");
  message.add(map(intraloopWSF, 0.0, 5.0, 0.0, 1.0));
  message.add(map(interloopWSF, 0.0, 5.0, 0.0, 1.0));
  oscP5.send(message, myNetAddressList);
}

void oscSyncMode() {
  OscMessage message;
  
  /*for (int y = 1; y < 4; y++) {
    for (int x = 1; x < 5; x++) {
      message = new OscMessage("/mode/" + str(y) + "/" + str(x));
      message.add(0.0);
      oscP5.send(message, myNetAddressList);
    }
  }*/
      
  message = new OscMessage("/mode/" + str(3 - field.mode / 4) + "/" + str(field.mode % 4 + 1));
  message.add(1.0);
  oscP5.send(message, myNetAddressList);
}

void oscEvent(OscMessage theOscMessage) 
{ 
  oscConnect(theOscMessage.netAddress().address());
  
  String addPatt = theOscMessage.addrPattern();
  int patLen = addPatt.length();
  float x, y;
  int a0, a1;
  
  /*if (addPatt.length() >= 3) {
    OscMessage syncMessage = new OscMessage(addPatt);
    for(int i = 0; i < theOscMessage.typetag().length(); i++) {
      syncMessage.add(theOscMessage.get(i).floatValue());
    }
    oscP5.send(syncMessage, myNetAddressList);
  }*/
  
  if (addPatt.length() < 3) {
    println("Page change");
  } else if (addPatt.equals("/xy0")) {
    y = theOscMessage.get(0).floatValue();
    x = theOscMessage.get(1).floatValue();
    field.updateAlgebra(x, y);
  } else if (addPatt.equals("/xy1")) {
    y = theOscMessage.get(0).floatValue();
    x = theOscMessage.get(1).floatValue();
    intraloopWSF = map(y, 0.0, 1.0, 0.0, 5.0);
    interloopWSF = map(x, 0.0, 1.0, 0.0, 5.0);
  } else if (patLen == 9 && addPatt.substring(0, 5).equals("/mode")) {
    if (theOscMessage.get(0).floatValue() == 1.0) {
      a0 = 3 - Integer.parseInt(addPatt.substring(6, 7));
      a1 = Integer.parseInt(addPatt.substring(8, 9)) - 1;
      field.setMode(4 * a0 + a1);
      
    }
  } else if (patLen == 9 && addPatt.substring(0,7).equals("/faders")) {
    int faderNum = Integer.parseInt(addPatt.substring(8,9));
    float faderVal = theOscMessage.get(0).floatValue();
    switch(faderNum) {
    case 1: // random speed
      field.setModeChance(faderVal);
      break;
    case 2: // brightness
      globalBrightness = (int) map(faderVal, 0.0, 1.0, 0.0, 255.0);
      // int delay = (int) map(faderVal, 0.0, 1.0, 0.0, 500.0);
      // println("Delay = " + delay + " ms");
      break;
    case 3: // delay
      field.adjustDelay((int) map(faderVal, 0.0, 1.0, 0.0, 255.0));
      break;
    case 4: // intraloop wheel step factor
      intraloopWSF = map(faderVal, 0.0, 1.0, 0.0, 5.0);
      break;
    case 5: // interloop wheel step factor
      interloopWSF = map(faderVal, 0.0, 1.0, 0.0, 5.0);
      break;
    default:
      break;
    }
  } else if (patLen == 14 && addPatt.substring(0,10).equals("/functions")) {
    if (theOscMessage.get(0).floatValue() == 1.0) {
      a0 = 2 - Integer.parseInt(addPatt.substring(11, 12));
      a1 = Integer.parseInt(addPatt.substring(13, 14)) - 1;
      int func = 2 * a0 + a1;
      println(func);
      switch(func) {
      case 0: // increment the vibe
        field.incVibe();
        break;
      case 1: // generate a new scheme within the current vibe
        field.newScheme();
        break;
      case 2: // set to rainbow scheme and set back to wide vibe
        field.setRainbow();
        break;
      case 3: // select the white vibe
        field.setVibeWhite();
        break;
      default:
        println("Not sure which function that was or how you did that...");
      }
    }
  } else if (addPatt.equals("/random")) {
    if (theOscMessage.get(0).floatValue() == 1.0) {
      modeSwitching = true;
    } else modeSwitching = false;
  } else if (addPatt.equals("/house")) {
    if (theOscMessage.get(0).floatValue() == 1.0) {
      field.setMode(11);
      field.setVibeWhite();
      globalBrightness = 255;
      modeSwitching = false;
      modeC = 0;
      houseLightsOn = true;
    } else {
      field.setRainbow();
      field.newScheme();
      houseLightsOn = false;
    }
  } else {
    print("Unexpected OSC Message Recieved: ");
    println("address pattern: " + theOscMessage.addrPattern());
    println("type tag: " + theOscMessage.typetag());
  }
  
  oscSync();
}

private void oscConnect(String theIPaddress) {
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    println("### adding " + theIPaddress + " to the list.");
    // //oscSync();
  } // else {
  //   //println("### " + theIPaddress + " is already connected.");
  // }
  // println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
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
