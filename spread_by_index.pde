public class SpreadByIndex extends Mode {
  
  int indexHigh, indexLow;

  SpreadByIndex(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    resetIndices();
  }
  
  void update() {
    fadeAll(fadeFactor);
    super.update();
    int brightness = 255;
    boolean needsReset = true;
    if (indexHigh < nPanels * 9) {
      updateByIndex(wheel.getColor(0, brightness), indexHigh);
      indexHigh++;
      needsReset = false;
    }
    if (indexLow > -1) {
      updateByIndex(wheel.getColor(0, brightness), indexLow);
      indexLow--;
      needsReset = false;
    }
    if (needsReset) resetIndices();
  }

  public void onBeat() {
    int wheelStep = bpm.getBand(2);
    wheel.turn(wheelStep);
    if (rand.nextInt(10) == 0) resetIndices();
  }
  
  private void resetIndices() {
    indexHigh = rand.nextInt(nPanels * 9);
    indexLow = indexHigh;
  }
}
