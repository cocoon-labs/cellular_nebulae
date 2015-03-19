public class Mode {
  
  Panel[] panels;
  int wheelPos;
  ColorWheel wheel;

  Mode(Panel[] panels, ColorWheel wheel) {
    this.panels = panels;
    this.wheel = wheel;
  }

  void update(int wheelPos, int schemeNo) {
    if (bpm.isBeat()) {
      onBeat(wheelPos, schemeNo);
    }
  }

  void onBeat(int wheelPos, int schemeNo) {
    // behavior that should only happen on the beat
  }
}
