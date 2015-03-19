class Panel {
    
  int[][] circles = new int[9][4];
  int[][] colors = new int[9][3];
  int x, y, diam, placeMin, placeMax;
  int r, g, b;
  Random rand = new Random();
  int nCircles = 9;
  int dim, tallBound, midBound;
  int squareSide, xOff, yOff;
    
  Panel(int squareSide, int xOff, int yOff) {
    this.dim = squareSide / 18;
    this.tallBound = 4 * dim;
    this.midBound = 7 * dim;
    this.squareSide = squareSide;
    this.xOff = xOff;
    this.yOff = yOff;
      
    for (int i = 0; i < nCircles; i++) {
      for (int j = 0; j < 3; j++) {
        colors[i][j] = 0;
      }
    }
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
    
  protected void placeCircles() {
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

  protected void dumpCircles(PrintWriter writer, int index) {
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
    
  protected void draw() {
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

  // protected void send(OPC opc, int idxOffset) {
  //     int color;
  //     for (int i = 0; i < nCircles; i++) {
  //  color = circles[i][0] << 16 || circles[i][1] << 8 || circles[i][2];
  //  opc.setPixel(idxOffset + i, color);
  //     }
  // }
      
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
