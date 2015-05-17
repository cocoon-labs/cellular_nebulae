public class SpreadByIndex extends Mode {
  
  int indexHigh, indexLow;
  int pixelOffset = 10;
  int updateCounter = 0;
  int loopsPerUpdate = 2;
  int brightness = 255;

  SpreadByIndex(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    delayable = true;
    resetIndices();
  }
  
  void update() {
    fadeAll(fadeFactor);
    super.update();
    if (updateCounter == 0) {
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
      wheel.turn((int) (pixelOffset * interloopWSF));
    }
    updateCounter = (updateCounter + 1) % loopsPerUpdate;
  }

  public void onBeat() {
    //int wheelStep = bpm.getBand(2);
    if (rand.nextInt(10) == 0) resetIndices();
  }
  
  private void resetIndices() {
    indexHigh = rand.nextInt(nPanels * 9);
    indexLow = indexHigh;
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(chance) == 0) {
      loopsPerUpdate = 1 + rand.nextInt(4);
    }
  }
}
