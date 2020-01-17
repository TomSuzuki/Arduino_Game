
// デフォルトフォント（これ以外を使いたい場合はメモリの状況を確認する）
PFont font;

// ゲームの生成
STG g1 = new STG();

void setup() {
  // ウィンドウ関連
  size(640, 480);
  surface.setTitle("Game Test mk.3");
  font = loadFont("./data/rounded-l-mplus-1c-black-48.vlw");

  // Arduinoの初期化
  controller.arduinoSetup(new String[] {"COM6"});
  //controller.arduinoSetup(controller.getArduinoList());
  delay(100);

  // テスト用ゲームの初期化
  g1.gameSetup();
}

void draw() {
  g1.gameMain();
}