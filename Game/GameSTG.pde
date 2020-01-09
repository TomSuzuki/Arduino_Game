// STG
class STG extends gameMaster {

  // 変数とか
  private int time, score, gameFlg;
  private Player player;
  private ArrayList<Bullet> eBullet = new ArrayList<Bullet>();
  private ArrayList<Bullet> pBullet = new ArrayList<Bullet>();
  private ArrayList<Enemy> enemy = new ArrayList<Enemy>();
  private ArrayList<Effect> effect = new ArrayList<Effect>();

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
      // 移動
      xAdd = constraind((xAdd + controller.getAngleX(0)/3)/2, -18, 18);
      yAdd = constraind((yAdd + controller.getAngleY(0)/3)/2, -18, 18);
      if (abs((int)xAdd) < 1) xAdd = 0;
      if (abs((int)yAdd) < 1) yAdd = 0;
      x = constrain(x+(int)(xAdd * (controller.getButtonR(0) == 1 ? 0.4 : 1)), 0, 640);
      y = constrain(y+(int)(yAdd * (controller.getButtonR(0) == 1 ? 0.4 : 1)), 0, 480);

      // 攻撃　
      if (controller.getButtonL(0) == 1) {
        if (time%2 == 0) for (int i=0; i<2; i++) pBullet.add(new Bullet(x-12+24*i, y, 6, 180, 16, TYPE_PLAYER));
      }

      // 当たり判定
      for (int i = 0; i < eBullet.size(); i++) if (eBullet.get(i).hitChk(x, y, 18)) {
        gameFlg = FLG_RESULT;
      }
    };

    // 描画関数
    void display() {
      fill(255);
      ellipse(x, y, 32, 32);
    };
  }

  // 敵のクラス
  private class Enemy {
    // 変数とか
    int x, y;
    int time;
    int flg;
    int hp = 12;

    // フラグ管理用
    private final static int FLG_IN = 0;
    private final static int FLG_ATK = 1;
    private final static int FLG_OUT = 2;

    // コンストラクタ
    Enemy() {
      x = int(random(0, 640));
      y = -64;
      flg = FLG_IN;
    }

    // 処理
    boolean move() {
      switch(flg) {
      case FLG_IN:
        y+=3;
        if (time == 60) flg = FLG_ATK;
        break;
      case FLG_ATK:
        if (time%2 == 0) for (int i=0; i<4; i++) eBullet.add(new Bullet(x, y, 6, i*360/4 + time, 4, TYPE_ZERO));
        if (time == 90) flg = FLG_OUT;
        break;
      case FLG_OUT:
        y+=1;
        if (x<320) x-=2;
        else x+=2;
        break;
      }
      time++;

      // 当たり判定
      for (int i = 0; i < pBullet.size(); i++) if (pBullet.get(i).hitChk(x, y, 48)) {
        hp-=1;
        pBullet.remove(i);
      }
      if (hp <= 0) score += 1200;

      // 画面外削除
      if (constrain(x, -64, 664) != x || constrain(y, -256, 544) != y || hp <= 0) return true;

      return false;
    }

    // 表示
    void display() {
      fill(255);
      noStroke();
      rotateRect(x, y, 48, 48, time*2);
      fill(128);
      rotateRect(x, y, 36, 36, -time*2);
    }
  }

  // 弾のタイプ
  private final static int TYPE_ZERO = 0;
  private final static int TYPE_PLAYER = 1;

  // 弾丸のクラス
  private class Bullet {
    // 変数とか
    float x, y, r, ang, speed;
    int type;

    // コンストラクタ
    Bullet(int x, int y, int r, int ang, int speed, int type) {
      this.x = x;
      this.y = y;
      this.r = r;
      this.ang = ang;
      this.speed = speed;
      this.type = type;
    }

    // 当たり判定用関数
    boolean hitChk(float x, float y, float r) {
      if (Math.sqrt((this.x - x) * (this.x - x) + (this.y - y) * (this.y - y)) < r+this.r) {
        for (int i = 0; i < 6; i++) effect.add(new Effect(x, y, 60));
        score+=1;
        return true;
      }
      return false;
    }

    // 処理
    boolean move() {
      x = sin(radians(ang))*speed + x;
      y = cos(radians(ang))*speed + y;

      // 画面外に行ったら削除する
      if (constrain(x, -64, 664) != x || constrain(y, -64, 544) != y) return true;

      return false;
    }

    // 描画
    void display() {
      switch(type) {
      case TYPE_ZERO:
        fill(0, 0, 0, 255);
        stroke(255);
        ellipse(x, y, r, r);
        break;
      case TYPE_PLAYER:
        fill(0, 0, 0, 255);
        stroke(255);
        ellipse(x, y, r/2, r*4);
        break;
      }
    };
  }

  // エフェクトのクラス
  private class Effect {
    // 変数とか
    float x, y, time, speed, ang;

    // コンストラクタ
    Effect(float x, float y, float time) {
      this.x = x;
      this.y = y;
      this.time = time;
      ang = random(0, 360);
      speed = random(2, 8);
    }

    // 処理
    boolean move() {
      x = sin(radians(ang))*speed + x;
      y = cos(radians(ang))*speed + y;
      time--;
      if (time < 0) return true;
      return false;
    }

    // 描画
    void display() {
      noStroke();
      fill(255, 255, 255, 24);
      ellipse(x, y, 12, 12);
    }
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
    case FLG_RESULT:
      gameResult();
      break;
    }
  }

  // 結果画面の描画
  void gameResult() {
    // 表示
    background(0);    
    textFont(font);
    textSize(32);
    int y = 0;
    int add = 38;
    msg("GAME OVER !!", 12, y+=add, LEFT, TOP, #FFFFFF);
    msg("SCORE: "+score, 12, y+=add, LEFT, TOP, #FFFFFF);
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

    // 敵の出現
    if (frameCount%120 == 0) enemy.add(new Enemy());

    // 敵の処理
    for (int i = 0; i < enemy.size(); i++) if (enemy.get(i).move()) enemy.remove(i);

    // 弾の処理
    for (int i = 0; i < pBullet.size(); i++) if (pBullet.get(i).move()) pBullet.remove(i);
    for (int i = 0; i < eBullet.size(); i++) if (eBullet.get(i).move()) eBullet.remove(i);

    // エフェクトの処理
    for (int i = 0; i < effect.size(); i++) if (effect.get(i).move()) effect.remove(i);

    // 描画関数の実行
    background(0);

    // エフェクトの描画
    for (Effect e : effect) e.display();

    // 弾の描画
    for (Bullet b : pBullet) b.display();
    for (Bullet b : eBullet) b.display();

    // 敵の描画
    for (Enemy e : enemy) e.display();

    // プレイヤーの描画
    player.display();
    displayUserInterface();
  }

  // UI
  void displayUserInterface() {
    textFont(font);
    textSize(14);
    msg("SCORE : "+String.format("%,09d", score), 320, 8, CENTER, TOP, #FFFFFF);
  }
}
