public class FFTBySize extends Mode {
  
  int freqThresh = 120;
  int pixelOffset = 10;
  int sizeOffset = 30;

  FFTBySize(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    int lowAmp = constrain((bpm.getBand(0) + bpm.getBand(1) + bpm.getBand(2) + bpm.getBand(3)), 0, 255);
    int midAmp = constrain((bpm.getBand(4) + bpm.getBand(5) + bpm.getBand(6)) * 4, 0, 255);
    int highAmp = constrain((bpm.getBand(7) + bpm.getBand(8) + bpm.getBand(9)) * 4, 0, 255);
    for (int i = 0; i < nPanels; i++) {
      if (lowAmp < freqThresh) panels[i].fadeBig(fadeFactor);
      else panels[i].updateBig(wheel.getColor(0, lowAmp));
        
      if (midAmp < freqThresh)
        panels[i].fadeMid(fadeFactor);
      else {
        midAmp = (int) map(midAmp, 0, 255, 0, globalBrightness);
        updateMidOnPanel(i, (int) (sizeOffset * intraloopWSF), midAmp, (int) (pixelOffset * intraloopWSF));
      }
      
      if (highAmp < freqThresh)
        panels[i].fadeSmall(fadeFactor);
      else {
        highAmp = (int) map(highAmp, 0, 255, 0, globalBrightness);
        updateSmallOnPanel(i, (int) (sizeOffset * intraloopWSF) * 2, highAmp, (int) (pixelOffset * intraloopWSF));
      }
    }
  }
  
  public void onBeat() {
    int panelOffset = bpm.getBand(2);
    wheel.turn((int) (panelOffset * interloopWSF));
  }
}
