public class StarTrek extends Mode {
  
  StarTrek(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    
  }
  
  public void update() {
    fadeAllIn(fadeFactor);
    turnOnPixels(rand.nextInt(10), 0, 1);
    super.update();
    refreshColors();
    wheel.turn(1);
  }
  
  public void onBeat() {
  }
  
  public void turnOnPixels(int nOn, int wheelOffset, int brightness) {
    for (int n = 0; n < nOn; n++) {
      int i = rand.nextInt(nPixels);
      if (panels[i / 9].brightVals[i % 9] == 0) {
        panels[i / 9].targetColors[i % 9] = wheel.getColor(wheelOffset, 255);
        panels[i / 9].brightVals[i % 9] = brightness;
      }
    } 
  }
  
  public void fadeAllIn(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllIn(factor, 255);
    }
  }
  
  public void refreshColors() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].refreshColors();
    }
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(chance) == 0) {
      fadeFactor = 1.01 + rand.nextInt(50) / 100.0;
    }
  }
}