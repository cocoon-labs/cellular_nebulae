public class Breathe extends Mode {
  
  boolean isFadingIn;
  float fadeInFactor;
  float minBrightness = 0.1;
  
  Breathe(Panel[] panels, ColorWheel wheel, float fadeFactor, float fadeInFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    this.fadeInFactor = fadeInFactor;
    isFadingIn = true;
    turnOnAll(0, 1);
  }
  
  public void update() {
    super.update();
    float brightness = panels[0].brightVals[0];
    if (isFadingIn) {
      if (brightness < 255) {
        fadeAllIn(fadeInFactor);
      } else {
        isFadingIn = false;
      }
    } else {
      if (brightness > minBrightness) {
        fadeAllOut(fadeFactor);
      } else {
        isFadingIn = true;
        turnOnAll(0, 1);
      }
    }
    refreshColors();
    wheel.turn(1);
  }
  
  public void onBeat() {
    
  }
  
  public void turnOnAll(int wheelOffset, int brightness) {
    for (int i = 0; i < nPixels; i++) {
      panels[i / 9].targetColors[i % 9] = wheel.getColor(wheelOffset, 255);
      panels[i / 9].brightVals[i % 9] = brightness;
    } 
  }
  
  public void fadeAllIn(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllIn(factor);
    }
  }
  
  public void fadeAllOut(float factor) {
    for (int i = 0; i < nPanels; i++) {
      panels[i].fadeAllOut(factor);
    }
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(chance) == 0) {
      //fadeFactor = 1.01 + rand.nextInt(50) / 100.0;
    }
  }
}
