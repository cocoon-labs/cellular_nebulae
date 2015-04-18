public class GradientWipe extends Mode {
  
  int loopOffset = 1;
  int loopCounter = 0;
  boolean fadingIn = false;
  float fadeInFactor;
  int fadeCounter = 0;
  
  GradientWipe(Panel[] panels, ColorWheel wheel, float fadeFactor, float fadeInFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    this.fadeInFactor = fadeInFactor;
  }
  
  public void update() {
    if (justEntered) {
      turnOnRest(0,2);
      refreshColors();
      justEntered = false;
      fadeCounter = 0;
      fadingIn = true;
      super.update();
    } else if (fadingIn) {
      fadeAllIn(fadeInFactor);
      float sinFactor = (1.875 * sin(0.0016 * loopCounter)) + 2.125;
      float colorSpread = 256.0 * sinFactor;
      float pixelStep = colorSpread / nPixels;
      for (int i = 0; i < nPixels; i++) {  
        panels[i / 9].targetColors[i % 9] = wheel.getColor((int) (pixelStep * i), 255);
      }
      wheel.turn(loopOffset);
      refreshColors();
      if (fadeCounter < 73)
        fadeCounter++;
      else
        fadingIn = false;
      super.update();
    } else {
      float sinFactor = (1.875 * sin(0.0016 * loopCounter)) + 2.125;
      float colorSpread = 256.0 * sinFactor;
      float pixelStep = colorSpread / nPixels;
      fadeAll(fadeFactor);
      super.update();
      for (int i = 0; i < nPixels; i++) {  
        updateByIndex(wheel.getColor((int) (pixelStep * i), 255), i);
      }
      wheel.turn(loopOffset);
      loopCounter = (loopCounter + 1) % 3927;
    }

    // TODO: accounts for busted pixel. this may vary depending on setup.
    updateByIndex(wheel.getColor(0, 0), 88);
  }
  
  public void onBeat() {
    
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      loopOffset = 1 + rand.nextInt(5);
    }
  }
  
  public void turnOnRest(int wheelOffset, int brightness) {
    float sinFactor = (1.875 * sin(0.0016 * loopCounter)) + 2.125;
    float colorSpread = 256.0 * sinFactor;
    float pixelStep = colorSpread / nPixels;
    for (int i = 0; i < nPixels; i++) {
      int pixelAmp = panels[i / 9].getPixelAmp(i % 9);
      if (pixelAmp == 0) {
        panels[i / 9].targetColors[i % 9] = wheel.getColor((int) (pixelStep * i), 255);
        panels[i / 9].brightVals[i % 9] = brightness;
      } else {
        panels[i / 9].targetColors[i % 9] = wheel.getColor((int) (pixelStep * i), 255);
        panels[i / 9].brightVals[i % 9] = pixelAmp;
      }
    }
  }
}
