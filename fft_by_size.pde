public class FFTBySize extends Mode {
  
  int freqThresh = 100;

  FFTBySize(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    int sizeOffset = bpm.getBand(1);
    int lowAmp = constrain((bpm.getBand(0) + bpm.getBand(1) + bpm.getBand(2) + bpm.getBand(3)), 0, 255);
    int midAmp = constrain((bpm.getBand(4) + bpm.getBand(5) + bpm.getBand(6)) * 4, 0, 255);
    int highAmp = constrain((bpm.getBand(7) + bpm.getBand(8) + bpm.getBand(9)) * 4, 0, 255);
    for (int i = 0; i < panels.length; i++) {
      if (lowAmp < freqThresh) panels[i].fadeBig(0.5);
      else panels[i].updateBig(wheel.getColor(0, lowAmp));
      if (midAmp < freqThresh) panels[i].fadeMid(0.9);
      else panels[i].updateMid(wheel.getColor(sizeOffset, midAmp));
      if (highAmp < freqThresh) panels[i].fadeSmall(0.9);
      else panels[i].updateSmall(wheel.getColor(sizeOffset * 2, highAmp));
      //wheelPos = (wheelPos + panelOffset) % 255;
    }
  }
  
  public void onBeat() {
    int panelOffset = bpm.getBand(2);
    wheel.turn(panelOffset);
  }
}
