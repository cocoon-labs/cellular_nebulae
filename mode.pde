public class Mode {
  
  Panel[] panels;
  ColorWheel wheel;
  float fadeFactor;
  int chance;
  int nPanels, nPixels;
  int prevTime;
  boolean justEntered = false;
  boolean delayable = false;

  Mode(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    this.panels = panels;
    this.wheel = wheel;
    this.fadeFactor = fadeFactor;
    this.chance = chance;
    this.nPanels = panels.length;
    this.prevTime = millis();
    nPixels = nPanels * 9;
  }

  public void advance() {
    int time = millis();
    if (!delayable) {
      update();
    } else if (delay == 0 || (time - prevTime) > delay) {
      update();
      prevTime = time;
    }
  }

  public void update() {
    if (bpm.isBeat()) {
      onBeat();
      randomize();
    }
  }

  public void onBeat() {
    // behavior that should only happen on the beat
  }
  
  public void pulseBigs(int nBigs, int freqThresh) {
    int lowAmp = constrain((bpm.getBand(0) + bpm.getBand(1) + bpm.getBand(2) + bpm.getBand(3)), 0, 255);
    for (int n = 0; n < nBigs; n++) {
      int i = rand.nextInt(nPanels);
      if (lowAmp < freqThresh) panels[i].fadeBig(0.5);
      else panels[i].updateBig(wheel.getColor(0, lowAmp));
    }
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      wheel.newScheme();
    }
  }
  
  public void fadeAll(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAll(factor);
    }    
  }

  public void fadeBig(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeBig(factor);
    }    
  }

  public void fadeMid(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeMid(factor);
    }    
  }
  
  public void fadeSmall(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeSmall(factor);
    }    
  }
  
  public void fadeOne(float factor, int index) {
    panels[index / 9].fadeOne(factor, index % 9);
  }
  
  public void refreshColors() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].refreshColors();
    }
  }
  
  public void updateByIndex(int[] c, int index) {
    panels[index / 9].updateOne(c, index % 9);
  }
  
  public void updateBySubIndex(int[] c, int index) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].updateOne(c, index);
    }
  }
  
  public void updateBig(int[] c) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].updateBig(c);
    }
  }
  
  public void updateMid(int[] c) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].updateMid(c);
    }
  }
  
  public void updateSmall(int[] c) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].updateSmall(c);
    }
  }
  
  public void updateMidOnPanel(int iPanel, int initOffset, int brightness, int pixelOffset) {
    for (int iPixel = 1; iPixel < 4; iPixel++) {
      int offset = (initOffset + iPixel * pixelOffset) % 255;
      panels[iPanel].updateOne(wheel.getColor(offset, brightness), iPixel);
    }
  }
  
  public void updateSmallOnPanel(int iPanel, int initOffset, int brightness, int pixelOffset) {
    for (int iPixel = 4; iPixel < 9; iPixel++) {
      int offset = (initOffset + iPixel * pixelOffset) % 255;
      panels[iPanel].updateOne(wheel.getColor(offset, brightness), iPixel);
    }
  }
  
  public void fadeAllInThenDisappear(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllIn(factor, 255);
    }
  }
  
  public void fadeAllIn(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllIn(factor);
    }
  }
  
  public void turnOnAll(int wheelOffset, int brightness) {
    for (int i = 0; i < nPixels; i++) {
      panels[i / 9].targetColors[i % 9] = wheel.getColor(wheelOffset, 255);
      panels[i / 9].brightVals[i % 9] = brightness;
    } 
  }
  
  public void fadeAllOut(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllOut(factor);
    }
  }
}
