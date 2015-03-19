public class FFTBySize extends Mode {

  FFTBySize(Panel[]panels, ColorWheel wheel) {
    super(panels, wheel);
  }

  void update(int wheelPos, int schemeNo) {
    super.update(wheelPos, schemeNo);
    int sizeOffset = 85;
    int panelOffset = bpm.getBand(2);
    // Amplitude values between 0 and 255
    int lowAmp = constrain((bpm.getBand(0) + bpm.getBand(1) + bpm.getBand(2) + bpm.getBand(3)), 0, 255);
    int midAmp = constrain((bpm.getBand(4) + bpm.getBand(5) + bpm.getBand(6)) * 4, 0, 255);
    int highAmp = constrain((bpm.getBand(7) + bpm.getBand(8) + bpm.getBand(9)) * 4, 0, 255);
    for (int i = 0; i < panels.length; i++) {
      panels[i].updateBig(wheel.getColor(schemeNo, wheelPos % 255, lowAmp));
      panels[i].updateMid(wheel.getColor(schemeNo, (wheelPos + sizeOffset) % 255, midAmp));
      panels[i].updateSmall(wheel.getColor(schemeNo, (wheelPos + sizeOffset * 2) % 255, highAmp));
      wheelPos = (wheelPos + panelOffset) % 255;
    }
  }
}
