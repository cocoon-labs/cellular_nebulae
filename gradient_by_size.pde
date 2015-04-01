public class GradientBySize extends Mode {
  
  int sizeOffset = bpm.getBand(0);
  int panelOffset = bpm.getBand(2);
  int brightness = 255;

  GradientBySize(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }

  public void onBeat() {

    for (int i = 0; i < nPanels; i++) {
      panels[i].updateBig(wheel.getColor(0, brightness));
      panels[i].updateMid(wheel.getColor(sizeOffset, brightness));
      panels[i].updateSmall(wheel.getColor(sizeOffset * 2, brightness));
      wheel.turn(panelOffset);
    }      
  }

}
