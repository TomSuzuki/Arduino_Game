// STG
class STG extends gameMaster {

  // 変数とか
  private int time, score, gameFlg;
  private Player player;
  private ArrayList<Bullet> bullet = new ArrayList<Bullet>();

  // ゲームの状態
  final int FLG_START = 3;
  final int FLG_GAME = 7;
  final int FLG_RESULT = 9;

  // プレイヤーのクラス
  private class Player {

    // 変数とか
    private int x, y;
    private double xAdd, yAdd;

    // コンストラクタ
    Player() {
      x = 320;
      y = 400;
    };

    // 移動関数
    void move() {
      xAdd = constraind((xAdd + controller.getAngleX(0)/3)/2, -18, 18);
      yAdd = constraind((yAdd + controller.getAngleY(0)/3)/2, -18, 18);
      if (abs((int)xAdd) < 1) xAdd = 0;
      if (abs((int)yAdd) < 1) yAdd = 0;
      x = constrain(x+(int)(xAdd * (controller.getButtonR(0) == 1 ? 0.4 : 1)), 0, 640);
      y = constrain(y+(int)(yAdd * (controller.getButtonR(0) == 1 ? 0.4 : 1)), 0, 480);
    };

    // 描画関数
    void display() {
      fill(255);
      ellipse(x, y, 32, 32);
    };
  }

  // 弾丸のクラス
  private class Bullet {
  }

  // コンストラクタ
  STG() {
    super("STG for Debug");
  }

  // ゲームの初期化
  void gameSetup() {
    // ゲーム内変数の初期化
    time = 0;
    score = 0;
    gameFlg = FLG_START;

    // オブジェクトの初期化
    player = new Player();
  }

  // ゲームの実行
  void gameMain() {
    switch(gameFlg) {
    case FLG_START:
      gameStart();
      break;
    case FLG_GAME:
      gameRun();
      break;
    }
  }

  // スタート前の説明ページの表示
  void gameStart() {
    // 表示
    background(0);    
    textFont(font);
    textSize(12);
    int y = 0;
    int add = 16;
    msg("STG", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - このゲームは一人用です.", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - デバッグ用ゲームです.", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - 攻撃は自動で行います.", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("操作方法", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - Lボタン: 攻撃タイプの変更", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - Rボタン: 低速移動", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - 傾き: 移動", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg(" - ディスプレイ: 現在の攻撃タイプの表示", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("LボタンとRボタンを同時押しでゲームを開始します.", 12, y+=add, LEFT, TOP, #FFFFFF);

    // ボタン同時押しでゲーム画面に進む
    if (controller.getButtonL(0) == 1 && controller.getButtonR(0) == 1) {
      controller.setZero(0);
      gameFlg = FLG_GAME;
    }
  };

  // ゲーム中の処理
  void gameRun() {
    // 処理関数の実行
    player.move();
    // 弾の処理

    // 描画関数の実行
    background(0);
    player.display();
    // 弾の描画
    displayUserInterface();
  }

  // UI
  void displayUserInterface() {
    textFont(font);
    textSize(14);
    msg("SCORE : 000,000,000", 320, 8, CENTER, TOP, #FFFFFF);
  }
}