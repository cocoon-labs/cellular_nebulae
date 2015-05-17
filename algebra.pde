public class Algebra extends Mode {
  
  int updateCounter = 0;
  int loopsPerUpdate = 3;
  int addCounter = 0;
  int addLength = 1;
  int opIndex = 0;
  int nOps = 5;
  int opChance = 50;
  int wheelStep = 10;
  
  
  Algebra(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    delayable = true;
    randomize();
  }
  
  public void update() {
    super.update();
    if (updateCounter == 0) {
      randomOperation(1);
      fadeAll(fadeFactor);
    }
    updateCounter = (updateCounter + 1) % loopsPerUpdate;
  }
  
  public void onBeat() {
    if (addCounter == 0) updateByIndex(wheel.getColor(0, 255), rand.nextInt(nPixels));
    
    wheel.turn((int) (wheelStep * interloopWSF));
    addCounter = (addCounter + 1) % addLength;
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(chance) == 0) {
      opIndex = rand.nextInt(nOps);
    }
    if (rand.nextInt(chance) == 0) {
      wheelStep = 1 + rand.nextInt(30);
    }
    if (rand.nextInt(chance) == 0) {
      loopsPerUpdate = 1 + rand.nextInt(4);
    }
  }
  
  // Operations
  
  private void randomOperation(int x) {
    if (rand.nextInt(opChance) == 0) {
      opIndex = rand.nextInt(nOps);
    }
    switch(opIndex) {
      case(0):
        addToIndexBy(x);
        break;
      case(1):
        subtractFromIndexBy(x);
        break;
      case(2):
        shiftIn(rand.nextInt(nPanels));
        break;
      case(3):
        shiftUp();
        break;
      case(4):
        shiftDown();
        break;
      case(5):
        pulseBigs(2, 80);
        break;
    }
  }
  
  private void addToIndexBy(int x) {
    int[] lastColor = panels[nPanels - 1].getOne(8);
    for (int i = nPixels - 1; i > 0; i--) {
      int newI = (i + nPixels - x) % nPixels;
      int[] c = panels[newI / 9].getOne(newI % 9);
      panels[i / 9].updateOne(c, i % 9);
    }
    panels[0].updateOne(lastColor, 0);
  }
  
  private void subtractFromIndexBy(int x) {
    int[] firstColor = panels[0].getOne(0);
    for (int i = 0; i < nPixels - 1; i++) {
      int newI = (i + x) % nPixels;
      int[] c = panels[newI / 9].getOne(newI % 9);
      panels[i / 9].updateOne(c, i % 9);
    }
    panels[nPanels - 1].updateOne(firstColor, 8);
  }
  
  private void shiftIn(int p) {
    for (int i = 0; i < nPanels; i++) {
      int[] bigColor = panels[i].getOne(0);
      int[] midColor = panels[i].getMidAverage();
      int[] smallColor = panels[i].getSmallAverage();
      if (i == p) 
        panels[i].updateOne(wheel.getColor(0,255), 0);
      else
        panels[i].updateOne(smallColor, 0);
      panels[i].updateMid(bigColor);
      panels[i].updateSmall(midColor);
    }
  }
  
  private void shiftUp() {
    for (int i = 0; i < nPanels; i++) {
      int[] bigColor = panels[i].getOne(0);
      int[] midColor = panels[i].getMidAverage();
      int[] smallColor = panels[i].getSmallAverage();
      panels[i].updateOne(midColor, 0);
      panels[i].updateMid(smallColor);
      panels[i].updateSmall(bigColor);
    }
  }
  
  private void shiftDown() {
    for (int i = 0; i < nPanels; i++) {
      int[] bigColor = panels[i].getOne(0);
      int[] midColor = panels[i].getMidAverage();
      int[] smallColor = panels[i].getSmallAverage();
      panels[i].updateOne(smallColor, 0);
      panels[i].updateMid(bigColor);
      panels[i].updateSmall(midColor);
    }
  }
}
