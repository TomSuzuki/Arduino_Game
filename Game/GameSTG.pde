/*
 * 注意事項
 * 
 */

// STG
class STG extends gameMaster {

  // 変数とか
  private int time, gameFlg;
  private ArrayList<Player> player = new ArrayList<Player>();
  private ArrayList<Enemy> enemy = new ArrayList<Enemy>();
  private ArrayList<Effect> effect = new ArrayList<Effect>();

  // ゲームの状態
  private final static int FLG_START = 3;
  private final static int FLG_GAME = 7;
  private final static int FLG_RESULT = 9;

  // 敵のタイプ
  private final static int ENEMY_001 = 0;
  private final static int ENEMY_DUMMY = 99;

  // 弾のタイプ
  private final static int BULLET_ZERO = 0;
  private final static int BULLET_PLAYER = 128;

  // エフェクトのタイプ
  private final static int EFFECT_NORMAL = 21;
  private final static int EFFECT_MINI = 22;
  private final static int EFFECT_BACKGROUND_A = 32;
  private final static int EFFECT_BACKGROUND_B = 33;
  
  // ゲーム進行管理クラス
  private class GmaeFunctions {
  }

  // 弾丸のクラス
  private class Bullet {
    // 変数とか
    private float x, y, r, ang, speed;
    private int type;

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
        for (int i = 0; i < 6; i++) effect.add(new Effect(x, y, EFFECT_NORMAL));
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

    // エフェクトに置き換える
    void toEffect() {
      for (int i = 0; i < 6; i++) effect.add(new Effect(x, y, EFFECT_MINI));
    }

    // 描画
    void display() {
      switch(type) {
      case BULLET_ZERO:
        fill(0, 0, 0, 255);
        stroke(255);
        ellipse(x, y, r, r);
        break;
      case BULLET_PLAYER:
        fill(0, 0, 0, 255);
        stroke(255);
        ellipse(x, y, r/2, r*4);
        break;
      }
    }
  }

  // プレイヤーのクラス
  private class Player {

    // 変数とか
    private int x, y, score, id, hp;
    private double xAdd, yAdd;
    private ArrayList<Bullet> playerBullet = new ArrayList<Bullet>();

    // コンストラクタ
    Player(int id) {
      this.id = id;	
      x = 320;
      y = 400;
      score = 0;
      hp = 300;
    };

    // 移動関数
    void move() {
      // プレイヤーの弾の処理
      for (int i = 0; i < playerBullet.size(); i++) if (playerBullet.get(i).move()) playerBullet.remove(i);

      // 移動
      xAdd = constraind((xAdd + controller.getAngleX(id)/3)/2, -18, 18);
      yAdd = constraind((yAdd + controller.getAngleY(id)/3)/2, -18, 18);
      if (abs((int)xAdd) < 1) xAdd = 0;
      if (abs((int)yAdd) < 1) yAdd = 0;
      x = constrain(x+(int)(xAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 0, 640);
      y = constrain(y+(int)(yAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 0, 480);

      // 攻撃　
      if (controller.getButtonL(id) == 1) {
        if (time%2 == 0) for (int i=0; i<2; i++) playerBullet.add(new Bullet(x-12+24*i, y, 6, 180, 16, BULLET_PLAYER));
      }

      // プレイヤーの弾が敵に接触しているかを判定する
      for (int i = 0; i < playerBullet.size(); i++) 
        for (Enemy e : enemy)
          if (playerBullet.get(i).hitChk(e.x, e.y, 18)) {
            addScore(12);
            if (e.hit()) addScore(1200);
          }
    };

    // 描画関数
    void display() {
      // 弾の描画
      for (Bullet b : playerBullet) b.display();

      // プレイヤーの描画
      fill(255);
      ellipse(x, y, 32, 32);
    };

    // 加点関数
    void addScore(int score) {
      this.score += score;
    }
  }

  // 敵のクラス
  private class Enemy {
    // 変数とか
    private int x, y, flg, time, type;
    private int hp = 12;
    private ArrayList<Bullet> enemyBullet = new ArrayList<Bullet>();

    // 内部フラグ管理用
    private final static int FLG_IN = 0;
    private final static int FLG_ATK = 1;
    private final static int FLG_OUT = 2;

    // コンストラクタ
    Enemy() {
      x = int(random(0, 640));
      y = -64;
      flg = FLG_IN;
      type = ENEMY_001;
    }

    // タイプ指定のコンストラクタ
    Enemy(int tpye) {
      x = int(random(0, 640));
      y = -64;
      flg = FLG_IN;
      this.type = type;
    }

    // 処理
    boolean move() {
      // 敵の弾の処理
      for (int i = 0; i < enemyBullet.size(); i++) if (enemyBullet.get(i).move()) enemyBullet.remove(i);

      // 当たり判定（自分の弾がプレイヤーと接触しているかを判定する）

      // 敵本体の処理
      switch(type) {
      case ENEMY_001:
        switch(flg) {
        case FLG_IN:
          y+=3;
          if (time == 60) flg = FLG_ATK;
          break;
        case FLG_ATK:
          if (time%2 == 0) for (int i=0; i<4; i++) enemyBullet.add(new Bullet(x, y, 6, i*360/4 + time, 4, BULLET_ZERO));
          if (time == 90) flg = FLG_OUT;
          break;
        case FLG_OUT:
          y+=1;
          if (x<320) x-=2;
          else x+=2;
          break;
        }
        break;
      case ENEMY_DUMMY:
        if (enemyBullet.size() == 0) return true;
        return false;
      }
      time++;

      // 画面外＆体力ゼロを削除
      if (constrain(x, -64, 664) != x || constrain(y, -256, 544) != y || hp <= 0) {
        if (hp > 0) {
          type = ENEMY_DUMMY;
          return false;
        }
        del_enemy();
        return true;
      }

      return false;
    }

    // 表示
    void display() {
      // 弾の描画
      for (Bullet b : enemyBullet) b.display();

      // 敵の描画
      switch(type) {
      case ENEMY_001:
        fill(255);
        noStroke();
        rotateRect(x, y, 48, 48, time*2);
        fill(128);
        rotateRect(x, y, 36, 36, -time*2);
        break;
      }
    }

    // 被弾判定があった時に呼ぶ
    boolean hit() {
      hp-=1;
      return hp<=0;
    }

    // 削除直前に呼ぶ（デストラクタないん？）
    void del_enemy() {
      // 所持する弾を全てエフェクトに置き換える（削除は敵オブジェクト行うのでエフェクトの生成のみ行う）
      for (Bullet b : enemyBullet) b.toEffect();
    }
  }

  // エフェクトのクラス
  private class Effect {
    // 変数とか
    private float x, y, time, speed, ang;
    private int type;
    private PImage img;

    // コンストラクタ
    Effect(float x, float y, int type) {
      this.x = x;
      this.y = y;
      this.type = type;
      time = 0;
      ang = random(0, 360);
      switch(type) {
      case EFFECT_BACKGROUND_A:
        img = loadImage("st01_001.png");
        speed = 4;
        break;
      case EFFECT_BACKGROUND_B:
        img = loadImage("st01_002.png");
        speed = 6;
        break;
      case EFFECT_NORMAL:
        time = 60;
        speed = random(2, 4);
        break;
      case EFFECT_MINI:
        time = 30;
        speed = random(1, 2);
        break;
      }
    }

    // 処理
    boolean move() {
      switch(type) {
      case EFFECT_BACKGROUND_A:
      case EFFECT_BACKGROUND_B:
        time+=speed;
        time=time%1280;
        break;
      default:
        x = sin(radians(ang))*speed + x;
        y = cos(radians(ang))*speed + y;
        time--;
        if (time < 0) return true;
        break;
      }
      return false;
    }

    // 描画
    void display() {
      switch(type) {
      case EFFECT_BACKGROUND_A:
      case EFFECT_BACKGROUND_B:
        image(img, 0, time-1280);
        image(img, 0, time);
        break;
      case EFFECT_NORMAL:
        noStroke();
        fill(255, 255, 255, 24);
        ellipse(x, y, 12, 12);
        break;
      case EFFECT_MINI:
        noStroke();
        fill(255, 255, 255, 24);
        ellipse(x, y, 8, 8);
        break;
      }
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
    gameFlg = FLG_START;

    // オブジェクトの初期化
    player.add(new Player(0));
    effect.add(new Effect(0, 0, EFFECT_BACKGROUND_A));
    effect.add(new Effect(0, 0, EFFECT_BACKGROUND_B));
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
    //msg("SCORE: "+score, 12, y+=add, LEFT, TOP, #FFFFFF);
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

    // 敵の出現（あとでゲーム進行クラスに置き換える）
    if (frameCount%120 == 0) enemy.add(new Enemy());

    // プレイヤーの処理
    for (Player p : player) p.move();

    // 敵の処理
    for (int i = 0; i < enemy.size(); i++) if (enemy.get(i).move()) enemy.remove(i);

    // エフェクトの処理
    for (int i = 0; i < effect.size(); i++) if (effect.get(i).move()) effect.remove(i);

    // 描画関数の実行
    background(0);

    // エフェクトの描画
    for (Effect e : effect) e.display();

    // 敵の描画
    for (Enemy e : enemy) e.display();

    // プレイヤーの描画
    for (Player p : player) p.display();
    displayUserInterface();
  }

  // UI
  void displayUserInterface() {
    textFont(font);
    textSize(14);
    //msg("SCORE : "+String.format("%,09d", score), 320, 8, CENTER, TOP, #FFFFFF);
  }
}
