
class Game001 {

  int x[] = {0, 0};
  int y[] = {0, 0};

  Game001() {
  }

  // 初期化関数（ゲーム起動前に1回必ず呼ばれる）
  void GameInit() {
    for (int i = 0; i < 2; i++) {
      x[i] = width/2;
      y[i] = height/2;
    }
  }

  // メイン関数（毎回呼ばれる、終了時は必ずtrueを返す）
  boolean GameMain() {
    // 処理
    for (int i = 0; i < 2; i++) {
      x[i] = constrain(x[i]+class_Arduino.getAngleX(i), 0, width);
      y[i] = constrain(y[i]+class_Arduino.getAngleY(i), 0, height);
    }

    // 描画
    background(255);
    fill(#FF0000);
    ellipse(x[0], y[0], 32, 32);
    fill(#0000FF);
    ellipse(x[1], y[1], 32, 32);

    return false;
  }
}
