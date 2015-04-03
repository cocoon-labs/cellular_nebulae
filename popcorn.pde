public class Popcorn extends Mode {
  
  int pixelOffset = 3;
  int beatOffset = 11;
  int brightness = 255;
  
  Popcorn(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }
  
  public void update() {
    fadeAll(fadeFactor);
    super.update();
    pulseBigs(1, 100);
  }
  
  public void onBeat() {
    // Choose random pixels and light up with beat
    int nToLight = 1 + rand.nextInt(18);
    for (int i = 0; i < nToLight; i++) {
      int iPixel = rand.nextInt(nPixels);
      int iPanel = iPixel / panels[0].nCircles;
      updateByIndex(wheel.getColor(pixelOffset * i, brightness), iPixel);
    }
    wheel.turn(beatOffset);
  }
}
