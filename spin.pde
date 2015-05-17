public class Spin extends Algebra {
  
  int pixelOffset = 3;
  int brightness = 255;
  int index;
  boolean speedingUp = true;
  boolean spinUp = true;
  int speed;
  int maxSpeed = 9;
  
  Spin(Panel[] panels, ColorWheel wheel, float fadeFactor, int chance) {
    super(panels, wheel, fadeFactor, chance);
    delayable = true;
    index = rand.nextInt(nPixels);
    speed = 1;
  }
  
  public void update() {
    fadeAll(fadeFactor);
    spin();
    super.update();
  }
  
  public void onBeat() {
    
  }
  
  public void randomize() {
    super.randomize();
    if (rand.nextInt(chance) == 0) {
      if (!speedingUp) {
        if (speed > 1) {
          loopsPerUpdate--;
        } else {
          speedingUp = false;
        }
      } else {
        if (speed < maxSpeed) {
          speed++;
        } else {
          speedingUp = true;
        }
      }
    }
    if (rand.nextInt(chance * 10) == 0) {
      spinUp = !spinUp;
    }
    if (rand.nextInt(chance) == 0) {
      fadeFactor = 0.9 + rand.nextInt(10) / 100;
    }
  }
  
  private void spin() {
    if (spinUp) {
      index = (index + nPixels + speed) % nPixels;
    } else {
      index = (index + nPixels - speed) % nPixels;
    }
    updateByIndex(wheel.getColor(0, brightness), index);
    wheel.turn(pixelOffset);
  }   
}
