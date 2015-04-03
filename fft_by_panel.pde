public class FFTByPanel extends Mode {
  
  int[] panelBands = new int[nPanels];
  int freqThresh = 100;
  int ampFactor = 20;
  int beatOffset = 11;

  FFTByPanel(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    assignBands();
  }

  public void update() {
    fadeAll(fadeFactor);
    super.update();
    for (int i = 0; i < nPanels; i++) {
      int iAmp = constrain(bpm.getBand(panelBands[i]) * ampFactor, 0, 255);
      if (iAmp < freqThresh) {
        panels[i].fadeBig(fadeFactor);
      } else { 
        panels[i].updateBig(wheel.getColor(0, iAmp));
      }
    }
  }
  
  public void onBeat() {
    wheel.turn(beatOffset);
    if (rand.nextInt(64) == 0) {
      assignOneBand(rand.nextInt(nPanels));
    }
    if (rand.nextInt(128) == 0) {
      ampFactor = 10 + rand.nextInt(20);
    }
    for (int i = 0; i < nPanels; i++) {
      panels[i].updateSmall(panels[i].colors[1]);
      panels[i].updateMid(panels[i].colors[0]);
    }
  }
  
  private void assignBands() {
    for (int i = 0; i < nPanels; i++) {
      panelBands[i] = rand.nextInt(10);
    }
  }
  
  private void assignOneBand(int index) {
    panelBands[index] = rand.nextInt(10);
  }
}
