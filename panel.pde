class Panel {
    
  int[][] circles = new int[9][4];
  int[][] colors = new int[9][3];
  int[][] targetColors = new int[9][3];
  float[] brightVals = new float[9];
  int x, y, diam, placeMin, placeMax;
  int r, g, b;
  int nCircles = 9;
  int dim, tallBound, midBound;
  int squareSide, xOff, yOff;
  OPC opc;
    
  Panel(int squareSide, int xOff, int yOff, OPC opc) {
    this.dim = squareSide / 18;
    this.tallBound = 4 * dim;
    this.midBound = 7 * dim;
    this.squareSide = squareSide;
    this.xOff = xOff;
    this.yOff = yOff;
      
    for (int i = 0; i < nCircles; i++) {
      for (int j = 0; j < 3; j++) {
        colors[i][j] = 0;
        targetColors[i][j] = 0;
      }
      brightVals[i] = 0;
    }
    this.opc = opc;
  }
        
  // brightness between 0 and 255
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
  
  public void updateOne(int[] c, int index) {
    colors[index] = c;
  }
  
  public int[] getOne(int index) {
    return colors[index];
  }
  
  public int[] getMidAverage() {
    int[] average = new int[3];
    for (int i = 0; i < 3; i++) {
      average[i] = (colors[1][i] + colors[2][i] + colors[3][i]) / 3;
    }
    return average;
  }
  
  public int[] getSmallAverage() {
    int[] average = new int[3];
    for (int i = 0; i < 3; i++) {
      average[i] = (colors[4][i] + colors[5][i] + colors[6][i] + colors[7][i] + colors[8][i]) / 5;
    }
    return average;
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
          double distFromCenter = cartesianDistance(x, y, 9 * dim, 9 * dim);
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

  public void dumpCircles(PrintWriter writer, int index) {
    writer.println("=======================");
    writer.println("Panel " + index);
    writer.println("=======================");

    String prefix = "\"Big";
    int counter = 0;
    for (int i = 0; i < nCircles; i++) {
      if (i == 1) {
        counter = 0;
        prefix = "\"Mid";
      } else if (i == 4) {
        counter = 0;
        prefix = "\"Small";
      }

      float x = (circles[i][0] - xOff) / (dim * 1.0);
      float y = (circles[i][1] - yOff) / (dim * 1.0);
      diam = circles[i][2] / dim;
      height = circles[i][3];
      writer.println(prefix + counter + " X\"= " + x);
      writer.println(prefix + counter + " Y\"= " + y);
      writer.println(prefix + counter + " D\"= " + diam);
      writer.println(prefix + counter + " H\"= " + height);
    }
    writer.println();
  }
  
  public void fadeAll(float factor) {
    fadeBig(factor);
    fadeMid(factor);
    fadeSmall(factor);
  }
  
  public void fadeBig(float factor) {
    fadeOne(factor, 0);
  }
  
  public void fadeMid(float factor) {
    for (int i = 1; i < 4; i++) {
      fadeOne(factor, i);
    }
  }
  
  public void fadeSmall(float factor) {
    for (int i = 4; i < nCircles; i++) {
      fadeOne(factor, i);
    }
  }
  
  public void fadeOne(float factor, int index) {
    colors[index][0] = int(colors[index][0] * factor);
    colors[index][1] = int(colors[index][1] * factor);
    colors[index][2] = int(colors[index][2] * factor);
  }
    
  public void draw() {
    fill(0);
    stroke(255);
    strokeWeight(2);
    rect(xOff, yOff, squareSide, squareSide);

    for (int i = 0; i < nCircles; i++) {
      //println(i);
        
      noStroke();
      fill(colors[i][0], colors[i][1], colors[i][2]);
      ellipse(circles[i][0], circles[i][1], circles[i][2], circles[i][2]);
    }
  }

  public void ship(int idxOffset) {
    for (int i = 0; i < nCircles; i++) {
      opc.setPixel(idxOffset + i, colors[i][0] << 16 | colors[i][1] << 8 | colors[i][2]);
    }
    opc.writePixels();
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
  
  public void fadeAllIn(float factor) {
    for (int i = 0; i < nCircles; i++) {
      brightVals[i] = constrain(factor * brightVals[i], 0, 255);
    }
  }
  
  public void fadeAllIn(float factor, int maxBrightness) {
    for (int i = 0; i < nCircles; i++) {
      brightVals[i] = factor * brightVals[i];
      if (brightVals[i] > maxBrightness)
        brightVals[i] = 0;
    }
  }
  
  public void fadeAllOut(float factor) {
    for (int i = 0; i < nCircles; i++) {
      brightVals[i] = factor * brightVals[i];
    }
  }
  
  public void refreshColors() {
    for (int i = 0; i < nCircles; i++) {
      colors[i][0] = int(map(brightVals[i], 0, 255, 0, targetColors[i][0]));
      colors[i][1] = int(map(brightVals[i], 0, 255, 0, targetColors[i][1]));
      colors[i][2] = int(map(brightVals[i], 0, 255, 0, targetColors[i][2]));
    }
  }
}
