
Game101 g = new Game101();

void setup() {
  // window
  size(640, 480);

  // Arduinoの初期化を行う
  class_Arduino.arduinoSetup();

  // game
  g.GmaeInit();
}

void draw() {
  g.GameMain();
}