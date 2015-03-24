public class Chase extends Mode {

  Chase(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }
  
  public void update() {
    fadeAll(fadeFactor);
    super.update();
    for (int i = 0; i < nPanels; i++) {
      if (rand.nextInt(chance) == 0) {
        panels[i].updateOne(wheel.getColor(0, 200), rand.nextInt(9));
        wheel.turn(23);
      }
    }
  }

  public void onBeat() {
    for (int i = 0; i < nPanels; i++) {
      if (rand.nextInt(3) < 2) {
        panels[i].updateOne(wheel.getColor(0, 255), rand.nextInt(9));
        wheel.turn(23);
      }
    }
  }

}
