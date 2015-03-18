class ColorWheel {
  private int[][][] schemes = {
   { {255, 0, 0}, {177, 67, 226}, {0, 0, 255} }, // red purple blue
   { {218, 107, 44}, {240, 23, 0}, {147, 0, 131} }, // snowskirt
   { {0, 0, 0}, {128, 0, 255}, {128, 0, 128} }, // royal
   { {122, 0, 255}, {0, 0, 255}, {0, 88, 205} }, // cool
   { {0, 0, 0}, {196, 0, 255}, {209, 209, 209} }, // dork
   { {177, 0, 177}, {77, 17, 71}, {247, 77, 7} }, // sevens
   { {128, 0, 255}, {0, 0, 0}, {255, 128, 0} } // orpal
  }; 
  
  public int[] getColor(int scheme, int position, int brightness) {
    int[][] colors = schemes[scheme];
    int nColors = colors.length;
    int dist = 255 / nColors;
    int[] c = new int[3];
    
    for (int i = 0; i < nColors; i++) {
      if (position < (i + 1) * dist) {
        c = genColor(i, colors, position, dist);
        return applyBrightness(c, brightness);
      }
    }
      
    c = genColor(nColors - 1, colors, position, dist);
    return applyBrightness(c, brightness);
  }
  
  public int[] applyBrightness(int[] c, int brightness) {
    int[] newC = new int[3];
    newC[0] = int(map(brightness, 0, 255, 0, c[0]));
    newC[1] = int(map(brightness, 0, 255, 0, c[1]));
    newC[2] = int(map(brightness, 0, 255, 0, c[2]));
    return newC;
  }
  
  public int nSchemes() {
    return schemes.length;
  }
  
  private int[] genColor(int idx, int[][] colors, int position, int dist) {
    position = position - (idx * dist);
    int nColors = colors.length;
    int[] result = new int[3];
    for (int i = 0; i < 3; i++) {
      result[i] = 
        colors[idx][i] + 
          (position * 
            (colors[(idx+1) % nColors][i] - colors[idx][i]) / 
            dist);
    }
    return result;
  }
} 
