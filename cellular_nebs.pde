public class Field {
  
  class Panel {
    
    int[][] circles = new int[9][4];
    int[][] colors = new int[9][3];
    int x, y, diam, placeMin, placeMax;
    int r, g, b;
    Random rand = new Random();
    int nCircles = 9;
    int dim, squareSide, xOff, yOff;
    
    Panel(int squareSide, int xOff, int yOff) {
      this.dim = squareSide / 18;
      this.squareSide = squareSide;
      this.xOff = xOff;
      this.yOff = yOff;
      
      for (int i = 0; i < nCircles; i++) {
        for (int j = 0; j < 3; j++) {
          colors[i][j] = 0;
        }
      }
      placeCircles();
      
      fill(0);
      stroke(255);
      strokeWeight(2);
      rect(xOff, yOff, squareSide, squareSide);

    }
    
    public void updateAll(int[] c) {
      updateBig(c);
      updateMid(c);
      updateSmall(c);
    }
    
    public void updateBig(int[] c) {
      colors[0] = c;
    }
 
    public void updateMid(int[] c) {
      for (int i = 1; i < 4; i++) {
        colors[i] = c;
      }
    }
    
    public void updateSmall(int[] c) {
      for (int i = 4; i < 9; i++) {
        colors[i] = c;
      }
    }
    
    public void placeCircles() {
      for (int i = 0; i < nCircles; i++) {
        if (i == 0) {
          diam = 6 * dim;
          placeMin = diam / 2;
          placeMax = 18 * dim - diam / 2;
        } else if (i < 4) {
          diam = 4 * dim;
          placeMin = diam / 2;
          placeMax = 18 * dim - diam / 2;
        } else {
          diam = 3 * dim;
          placeMin = diam / 2;
          placeMax = 18 * dim - diam / 2;
        }
        while(true) {
          x = randInt(placeMin, placeMax) + xOff;
          y = randInt(placeMin, placeMax) + yOff;
          if (overlapsAny(x, y, diam / 2, i)) {
            continue;
          } else {
            circles[i][0] = x;
            circles[i][1] = y;
            circles[i][2] = diam;
            distFromCenter = cartesianDistance(x, y, 9 * dim, 9 * dim);
            if (distFromCenter < tallBound) {
              circles[i][3] = 4;
            } else if (distFromCenter < midBound) {
              circles[i][3] = 3;
            } else {
              circles[i][3] = 2;
            }
            break;
          }
        }
      }
    }
    
    protected void draw() {
      for (int i = 0; i < nCircles; i++) {
        //println(i);
        
        noStroke();
        fill(colors[i][0], colors[i][1], colors[i][2]);
        ellipse(circles[i][0], circles[i][1], circles[i][2], circles[i][2]);
      }
    }
    
    private int randInt(int min, int max) {
      int randomNum = rand.nextInt((max - min) + 1) + min;
      return randomNum;
    }
  
    private boolean overlapsAny(int x, int y, int rad, int upper) {
      for (int i = 0; i < upper; i++) {
        if (cartesianDistance(x, y, circles[i][0], circles[i][1]) < (rad + circles[i][2] / 2)) {
          return true;
        }
      }
      return false;
    }
  
    private double cartesianDistance(int x1, int y1, int x2, int y2) {
      return Math.sqrt(Math.pow((x1 - x2), 2) + Math.pow((y1 - y2), 2));
    }
  }
 
  Panel[] panels;
  ColorWheel wheel = new ColorWheel();
  int wheelPos = 0;
  int schemeNo = 0;
  int nModes = 1;
  int mode = 0;
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
  Random rand = new Random();

  Field(int yDim, int xDim, int chanceFactor, int displayHeight, int displayWidth) {
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
      panels[i] = new Panel(squareSide, tmpX, tmpY);
    }
    chance = chanceFactor;
  }
  
  public void update() {
    switch(mode) {
      case 0: gradientBySize();
              break;
      default: println("FUCK A GOAT WITH THAT!!"); 
    }
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      schemeNo = rand.nextInt(wheel.nSchemes());
    }
    
    if (rand.nextInt(chance) == 0) {
      mode = rand.nextInt(nModes);
    }
    
    if (rand.nextInt(chance) == 0) {
      delayMultiplier = rand.nextInt(9);
    }
  }
    
  private void gradientBySize() {
    int sizeOffset = bpm.getBand(0);
    int panelOffset = bpm.getBand(2);
    for (int i = 0; i < panels.length; i++) {
      panels[i].updateBig(wheel.getColor(schemeNo, wheelPos % 255));
      panels[i].updateMid(wheel.getColor(schemeNo, (wheelPos + sizeOffset) % 255));
      panels[i].updateSmall(wheel.getColor(schemeNo, (wheelPos + sizeOffset * 2) % 255));
      wheelPos = (wheelPos + panelOffset) % 255;
    }      
  }
  
  public void draw() {
    for (int i = 0; i < nPanels; i++) {
      panels[i].draw();
    }
  }

  private int delay() {
    return (int) (beatInterval * multipliers[delayMultiplier]);
  }  
}
