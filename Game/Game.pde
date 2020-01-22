// デバッグ用フラグ
final boolean modeDebug = true;

// デフォルトフォント（これ以外を使いたい場合はメモリの状況を確認する）
PFont font;

// ゲームの生成
STG g1;

void setup() {
  // ウィンドウ関連
  size(640, 480);
  surface.setTitle("Gyro STG - version 0.7 beta");
  font = loadFont("./data/rounded-l-mplus-1c-black-48.vlw");

  // ゲームの生成
  g1 = new STG();

  // Arduinoの初期化
  //controller.arduinoSetup(new String[] {"COM6"});  // windows用（COMの番号を書き換える！）
  controller.arduinoSetup(controller.getArduinoList());  // mac用（自動で判別）
  delay(100);

  // ゲームの初期化
  g1.gameSetup();
}

void draw() {
  g1.gameMain();
}
