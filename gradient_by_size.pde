public class GradientBySize extends Mode {

  GradientBySize(Panel[] panels, ColorWheel wheel) {
    super(panels, wheel);
  }

  void onBeat(int wheelPos, int schemeNo) {
    int sizeOffset = bpm.getBand(0);
    int panelOffset = bpm.getBand(2);
    int brightness = 255;
    for (int i = 0; i < panels.length; i++) {
      panels[i].updateBig(wheel.getColor(schemeNo, wheelPos % 255, brightness));
      panels[i].updateMid(wheel.getColor(schemeNo, (wheelPos + sizeOffset) % 255, brightness));
      panels[i].updateSmall(wheel.getColor(schemeNo, (wheelPos + sizeOffset * 2) % 255, brightness));
      wheelPos = (wheelPos + panelOffset) % 255;
    }      
  }

}
