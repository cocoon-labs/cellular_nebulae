public class Breathe extends Mode {
  
  float fadeInFactor;
  int loopCounter = 0;
  int sinLength = 100;
  boolean fadingIn = false;
  int fadeCounter = 0;
  
  Breathe(Panel[] panels, ColorWheel wheel, float fadeFactor, float fadeInFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    this.fadeInFactor = fadeInFactor;
    delayable = true;
    turnOnAll(0, 1);
  }
  
  public void update() {
    if (justEntered) {
      fadeOnAll(0,2);
      refreshColors();
      justEntered = false;
      fadeCounter = 0;
      fadingIn = true;
      super.update();
      loopCounter = sinLength / 4;
    } else if (fadingIn) {
      fadeAllIn(fadeInFactor);
      for (int i = 0; i < nPixels; i++) {  
        panels[i / 9].targetColors[i % 9] = wheel.getColor(0, 255);
      }
      refreshColors();
      if (fadeCounter < 73)
        fadeCounter++;
      else
        fadingIn = false;
      super.update();
    } else {
      super.update();
      float sinFactor = 2.0 * PI / sinLength;
      int brightness = (int) map(sin(sinFactor * loopCounter), -1, 1, 0, 255);
      turnOnAll(0, brightness);
      refreshColors();
      loopCounter = (loopCounter + 1) % (sinLength + 1);
    }
  }
  
  public void onBeat() {
    if (!justEntered && !fadingIn) wheel.turn((int) (3 * interloopWSF));
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(1) == 0 &&
         ((loopCounter == (sinLength / 4)) ||
           (loopCounter == (3 * sinLength / 4)))) {
      sinLength = 50 + rand.nextInt(150);
    }
  }
  
  public void fadeOnAll(int wheelOffset, int brightness) {
    for (int i = 0; i < nPixels; i++) {
      int pixelAmp = panels[i / 9].getPixelAmp(i % 9);
      if (pixelAmp == 0) {
        panels[i / 9].targetColors[i % 9] = wheel.getColor(wheelOffset, 255);
        panels[i / 9].brightVals[i % 9] = brightness;
      } else {
        panels[i / 9].targetColors[i % 9] = wheel.getColor(wheelOffset, 255);
        panels[i / 9].brightVals[i % 9] = pixelAmp;
      }
    } 
  }
}
