public class Mode {
  
  Panel[] panels;
  ColorWheel wheel;
  float fadeFactor;
  int chance;
  int nPanels;

  Mode(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    this.panels = panels;
    this.wheel = wheel;
    this.fadeFactor = fadeFactor;
    this.chance = chance;
    this.nPanels = panels.length;
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
}
