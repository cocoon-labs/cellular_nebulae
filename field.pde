public class Field {
 
  Panel[] panels;
  ColorWheel wheel;

  Mode[] modes = new Mode[6];
  int nModes = modes.length;
  int mode = 5;
  int beatInterval = 500;
  int delayMultiplier = 5;
  float[] multipliers = {
    1.0 / 8,
    1.0 / 4,
    1.0 / 3,
    1.0 / 2,
    3.0 / 4,
    1.0,
    2.0,
    3.0,
    4.0
  };
  int nPanels, chance;
  OPC opc;

  Field(int yDim, int xDim, int chanceFactor, int displayHeight, int displayWidth, OPC opc) {
    int xOff = 0, yOff = 0;
    int squareSide = Math.min(displayWidth / xDim, displayHeight / yDim);
    
    if (squareSide == displayWidth / xDim) {
      yOff = (displayHeight - (squareSide * yDim)) / 2;
    } else {
      xOff = (displayWidth - (squareSide * xDim)) / 2;
    }
          
    this.nPanels = xDim * yDim;
    panels = new Panel[nPanels];
    for (int i = 0; i < nPanels; i++) {
      int tmpX = xOff + (i % xDim) * squareSide;
      int tmpY = yOff + (i / xDim) * squareSide; 
      panels[i] = new Panel(squareSide, tmpX, tmpY, opc);
    }
    placeCircles();
    chance = chanceFactor;

    this.opc = opc;
    opc.setPixelCount(nPanels * panels[0].nCircles);

    wheel = new ColorWheel();

    modes[0] = new FFTBySize(panels, wheel, 0.9, 100);
    modes[1] = new Popcorn(panels, wheel, 0.9, chance);
    modes[2] = new FFTByPanel(panels, wheel, 0.9, chance);
    modes[3] = new Chase(panels, wheel, 0.98, chance);
    modes[4] = new GradientWipe(panels, wheel, 0.9, chance);
    modes[5] = new RandomFade(panels, wheel, 0.9, chance);
  }
  
  public void update() {
    modes[mode].update();
  }
  
  public void randomize() {
    // if (rand.nextInt(chance) == 0) {
    //   mode = rand.nextInt(nModes);
    // }
  }
    
  public void draw() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].draw();
    }
  }

  public void send() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].ship((i % 4) * panels[0].nCircles);
    }
  }

  public void placeCircles(int index) {
    panels[index].placeCircles();
  }

  public void placeCircles() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].placeCircles();
    }
  }

  public void serialize(PrintWriter writer) {
    println("print the circles!!");
    for (int i = 0; i < nPanels; i++) {
      panels[i].dumpCircles(writer, i);
    }
  }

  public void newScheme() {
    wheel.newScheme();
  }
}
