public class Mode {
  
  Panel[] panels;
  ColorWheel wheel;
  float fadeFactor;
  int chance;

  Mode(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    this.panels = panels;
    this.wheel = wheel;
    this.fadeFactor = fadeFactor;
    this.chance = chance;
  }

  public void update() {
    if (bpm.isBeat()) {
      onBeat();
      randomize();
    }
  }

  public void onBeat() {
    // behavior that should only happen on the beat
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      wheel.newScheme();
    }
  }
  
  public void fadeAll(float factor) {
    for (int i = 0; i < panels.length; i++) {
      panels[i].fadeAll(factor);
    }    
  }
}
