// ゲームの生成
Game001 g = new Game001();

void setup() {
  // 画面などの設定
  size(640, 480);

  // Arduinoの初期化を行う
  class_Arduino.arduinoSetup();

  // ゲームの初期化を行う
  g.GameInit();
}

void draw() {
  g.GameMain();
}
