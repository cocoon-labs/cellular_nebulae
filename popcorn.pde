public class Popcorn extends Mode {
  
  Popcorn(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
  }
  
  void update() {
    super.update();
    fadeAll(fadeFactor);
  }
  
  void onBeat() {
    int pixelOffset = bpm.getBand(5);
    int beatOffset = bpm.getBand(2);
    int brightness = 255;
    // Choose random pixels and light up with beat
    int nPixels = panels.length * panels[0].nCircles;
    int nToLight = 1 + rand.nextInt(18);
    for (int i = 0; i < nToLight; i++) {
      int iPixel = rand.nextInt(nPixels);
      int iPanel = iPixel / panels[0].nCircles;
      panels[iPanel].updateOne(wheel.getColor(pixelOffset * i, brightness), iPixel % panels[0].nCircles);
    }
    wheel.turn(beatOffset);
  }
  
}
