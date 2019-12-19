
class Game001 {

  int x[] = {0};
  int y[] = {0};

  Game001() {
  }

  // 初期化関数（ゲーム起動前に1回必ず呼ばれる）
  void GameInit() {
    x[0] = width/2;
    y[0] = height/2;
  }

  // メイン関数（毎回呼ばれる、終了時は必ずtrueを返す）
  boolean GameMain() {
    // 処理
    x[0] = constrain(x[0]+class_Arduino.getAngleX(0), 0, width);
    y[0] = constrain(y[0]+class_Arduino.getAngleY(0), 0, height);

    // 描画
    background(255);
    fill(#FF0000);
    ellipse(x[0], y[0], 32, 32);

    return false;
  }
}