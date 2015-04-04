public class Field {
 
  Panel[] panels;
  ColorWheel wheel;

  Mode[] modes = new Mode[12];
  int nModes = modes.length;
  int mode = 10;
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
  int[] modeChances = {5000, 1000, 500, 100};

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
      panels[i] = new Panel(squareSide, tmpX, tmpY, opc, wheel);
    }
    placeCircles();
    chance = chanceFactor;

    this.opc = opc;
    opc.setPixelCount(nPanels * panels[0].nCircles);

    wheel = new ColorWheel();

    modes[0] = new FFTBySize(panels, wheel, 0.93, chance);
    modes[1] = new FFTByPanel(panels, wheel, 0.9, chance);
    modes[2] = new FFTByPixel(panels, wheel, 0.98, chance);
    modes[3] = new FFTByRandomPixel(panels, wheel, 0.999, chance);
    modes[4] = new Popcorn(panels, wheel, 0.95, chance);
    modes[5] = new Chase(panels, wheel, 0.95, chance);
    //modes[5] = new RandomFade(panels, wheel, 0.9, chance);
    modes[6] = new SpreadByIndex(panels, wheel, 0.9, chance);
    modes[7] = new Algebra(panels, wheel, 0.99, chance);
    modes[8] = new Spin(panels, wheel, 0.95, chance);
    modes[9] = new StarTrek(panels, wheel, 1.1, chance);
    modes[10] = new Breathe(panels, wheel, 0.97, 1.07, chance);
    modes[11] = new GradientWipe(panels, wheel, 0.9, 1.07, chance);
  }

  public void update() {
    modes[mode].advance();
  }
  
  public void randomize() {
    if (rand.nextInt(modeChances[modeC]) == 0 && modeSwitching) {
      setMode(rand.nextInt(nModes));
    }
  }
    
  public void draw() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].draw();
    }
  }

  public void send() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].ship(i * panels[0].nCircles);
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
  
  public void setVibeWhite() {
    wheel.vibe = 3;
    wheel.newScheme();
  }
  
  public void incVibe() {
    if (wheel.vibe == 3) wheel.vibe = 0;
    else wheel.vibe = (wheel.vibe + 1) % 3;
    wheel.newScheme();
  }
  
  public void setMode(int m) {
    mode = m;
    modes[mode].justEntered = true;
  }
  
  public void incFFTMode() {
    if (mode > 3) mode = 0;
    else mode = (mode + 1) % 4;
  }

  public void adjustDelay(int step) {
    modes[mode].adjustDelay(step);
  }
}
