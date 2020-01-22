/*
 * 注意事項
 * - final → 数値変えても大丈夫（enumに変えたい）
 * 
 */

// STG
class STG extends gameMaster {

  // 変数とか
  private int time, gameFlg;
  private float fps;
  private ArrayList<Player> player = new ArrayList<Player>();
  private ArrayList<Enemy> enemy = new ArrayList<Enemy>();
  private ArrayList<Effect> effect = new ArrayList<Effect>();
  private GameFunctions gameFunctions;

  // 画像、音声用
  private PImage Img_StartBack;
  private PImage Img_Player0 = loadImage("./player0.png");
  private PImage Img_Player1 = loadImage("./player1.png");

  // ゲームの状態
  private final static int FLG_START = 3;
  private final static int FLG_GAME = 7;
  private final static int FLG_RESULT = 9;
  private final static int FLG_SETUP_BATTLE = 123;
  private final static int FLG_SETUP_COOPERATION = 124;
  private final static int FLG_EXIT = 200;
  private final static int FLG_SETUP_RANKING = 300;
  private final static int FLG_RANKING = 301;

  // 敵のタイプ
  private final static int ENEMY_001 = 0;
  private final static int ENEMY_002 = 2;
  private final static int ENEMY_DUMMY = 99;

  // 弾のタイプ
  private final static int BULLET_ZERO = 0;
  private final static int BULLET_PLAYER1 = 1167;
  private final static int BULLET_PLAYER2 = 1168;
  private final static int BULLET_PLAYER1_NORMAL = 1200;
  private final static int BULLET_PLAYER2_NORMAL = 1201;
  private final static int BULLET_PLAYER1_DUAL = 1210;
  private final static int BULLET_PLAYER2_DUAL = 1211;
  private final static int BULLET_PLAYER1_SNIPER = 1220;
  private final static int BULLET_PLAYER2_SNIPER = 1221;
  private final static int BULLET_PLAYER1_SOAD = 1230;
  private final static int BULLET_PLAYER2_SOAD = 1231;

  // エフェクトのタイプ
  private final static int EFFECT_NORMAL = 21;
  private final static int EFFECT_MINI = 22;
  private final static int EFFECT_BACKGROUND_A = 32;
  private final static int EFFECT_BACKGROUND_B = 33;
  private final static int EFFECT_PLAYERIMG_1 = 45;
  private final static int EFFECT_PLAYERIMG_2 = 46;

  // ゲームの種類
  private final static int GAME_TYPE_BATTLE = 1;
  private final static int GAME_TYPE_COOPERATION = 2;

  // ゲーム進行管理クラス
  private class GameFunctions {
    // 変数とか
    private final int EnemyList[] = {ENEMY_001, ENEMY_002};  // ランダム出現の敵のリスト
    private int type, remainingTime;
    private PImage Img_GameFrame;

    // コンストラクタ
    GameFunctions(int type) {
      this.type = type;

      // ロード
      Img_GameFrame = loadImage("./gameFrame.png");

      // オブジェクトの初期化
      int maxHP = 60;
      if (type == GAME_TYPE_COOPERATION) maxHP = 120;
      player.add(new Player(0, maxHP));
      player.add(new Player(1, maxHP));
      effect.add(new Effect(0, 0, EFFECT_BACKGROUND_A));
      effect.add(new Effect(0, 0, EFFECT_BACKGROUND_B));

      // ゲーム初期化
      remainingTime = 60*30;
    }

    // スコア画面の描画＆処理
    void gameResult() {
      // 背景
      background(0);

      // カーソル
      for (Cursor c : cursor) {
        boolean flg = c.move();
        fill(255, 255, 255, frameCount%6 < 2 ? 128 : 96);
        noStroke();
        if (c.hitChk(320, 400, 240, 40)) {
          centerRect(320, 400, 240, 40);
		  if(flg) gameFlg = FLG_START;
        }
      }

      // 表示するもの
      String s = String.format("%,d", player.get(0).score+player.get(1).score);
      if (type == GAME_TYPE_BATTLE) {
        if (player.get(0).score == player.get(1).score) s = "引き分け";
        else if (player.get(0).score < player.get(1).score) s = "2P（青）の勝ち！";
        else s = "1P（赤）の勝ち！";
      }else if(player.get(0).hp <= 0 || player.get(1).hp <= 0) s = "GAME OVER !!";

      // テキスト
      textFont(font);
      textSize(48);
      msg("- RESULT -", 320, 80, CENTER, CENTER, #FFFFFF);
      msg(s, 320, 300, CENTER, CENTER, #DDDDDD);
      textSize(32);
      msg(String.format("%,d", player.get(0).score), 160, 200, CENTER, CENTER, #DDDDDD);
      msg(String.format("%,d", player.get(1).score), 480, 200, CENTER, CENTER, #DDDDDD);
      msg("タイトルへ戻る", 320, 400, CENTER, CENTER, #DDDDDD);

      // フォーカスの描画
      for (Cursor c : cursor) c.display();
    }

    // ゲームの進行
    void x25() {
      // 敵の出現
      if (frameCount%45 == 0) enemy.add(new Enemy(EnemyList[int(random(0, EnemyList.length))]));

      // 時間の進行
      remainingTime--;
      if (remainingTime == 0) gameFlg = FLG_RESULT;

	  // 終了判定
	  if(player.get(0).hp <= 0 || player.get(1).hp <= 0) {
		  if(player.get(0).hp <= 0) player.get(0).score = 0;
		  if(player.get(1).hp <= 0) player.get(1).score = 0;
		  gameFlg = FLG_RESULT;
	  }
    }

    // UI
    void displayUserInterface() {
      // FPS
      if (frameCount%60 == 0) fps = frameRate;
      textSize(12);
      msg("FPS "+String.format("%2.1f", fps), 8, 474, LEFT, BOTTOM, #FFFFFF);

      // プレイヤーUI
      for (Player p : player) p.displayUserInterface();

      // 表示
      String s = "対戦";
      color c = #FF2222;
      if (type == GAME_TYPE_COOPERATION) {
        s = "協力";
        c = #2222FF;
      }
      textSize(14);
      msg(s, 320, 55, CENTER, TOP, #FFFFFF, c, 1);
      textSize(26);
      msg(""+(1+remainingTime/60), 630, 474, RIGHT, BOTTOM, #FFFFFF, #222222, 1);
    }

    // ゲームのフレーム
    void displayFrame() {
      // フレーム本体
      image(Img_GameFrame, 0, 0);
    }
  }

  // 弾丸のクラス
  private class Bullet {
    // 変数とか
    private float x, y, r, ang, speed;
    private int type, time;

    // コンストラクタ
    Bullet(int x, int y, int r, int ang, int speed, int type) {
      this.x = x;
      this.y = y;
      this.r = r;
      this.ang = ang;
      this.speed = speed;
      this.type = type;
      time = 0;
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
      time++;
      x = sin(radians(ang))*speed + x;
      y = cos(radians(ang))*speed + y;

      // 画面外に行ったら削除する
      if (constrain(x, -64, 664) != x || constrain(y, -64, 544) != y) return true;

      // 弾ごとの追加処理
      switch(type) {
      case BULLET_PLAYER1_SOAD:
      case BULLET_PLAYER2_SOAD:
        if (time > 30) return true;
        break;
      case BULLET_PLAYER1_NORMAL:
      case BULLET_PLAYER2_NORMAL:
      case BULLET_PLAYER1_DUAL:
      case BULLET_PLAYER2_DUAL:
        speed-=0.52;
        if (speed <= 1) return true;
        break;
      }

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
      case BULLET_PLAYER1:
      case BULLET_PLAYER1_SNIPER:
        fill(0, 0, 255, 255);
        stroke(255);
        ellipse(x, y, r/2, r*4);
        break;
      case BULLET_PLAYER2:
      case BULLET_PLAYER2_SNIPER:
        fill(255, 0, 0, 255);
        stroke(255);
        ellipse(x, y, r/2, r*4);
        break;
      case BULLET_PLAYER1_NORMAL:
      case BULLET_PLAYER1_DUAL:
        fill(0, 0, 255, speed >= 8 ? 255 : 255*speed/8);
        stroke(speed >= 8 ? 255 : 255*speed/8);
        ellipse(x, y, r/2, r*4);
        break;
      case BULLET_PLAYER2_NORMAL:
      case BULLET_PLAYER2_DUAL:
        fill(255, 0, 0, speed >= 8 ? 255 : 255*speed/8);
        stroke(speed >= 8 ? 255 : 255*speed/8);
        ellipse(x, y, r/2, r*4);
        break;
      case BULLET_PLAYER1_SOAD:
        fill(0, 0, 255, 255*(30-time)/30);
        stroke(255, 255*(30-time)/30);
        rotateRect(int(x), int(y), int(r/2), int(r*4), int(180-ang));
        break;
      case BULLET_PLAYER2_SOAD:
        fill(255, 0, 0, 255*(30-time)/30);
        stroke(255, 255*(30-time)/30);
        rotateRect(int(x), int(y), int(r/2), int(r*4), int(180-ang));
        break;
      }
    }
  }

  // プレイヤーのクラス
  private class Player {
    // 変数とか
    private int x, y, score, id, hp, time, maxHP, typeATK, pButtonR;
    private double xAdd, yAdd;
    private ArrayList<Bullet> playerBullet = new ArrayList<Bullet>();
    private PImage[] img = new PImage[12];

    // 指定
    private final static int ATK_NORMAL = 1;
    private final static int ATK_DUAL = 2;
    private final static int ATK_SNIPER = 3;
    private final static int ATK_SOAD = 4;
    private final int AKT_List[] = {ATK_NORMAL, ATK_DUAL, ATK_SNIPER, ATK_SOAD};
    private final int IMG_NORMAL[] = {0, 1, 2, 1};
    private final int IMG_DUAL[] = {3, 4, 5, 4};
    private final int IMG_SNIPER[] = {6, 7, 8, 7};
    private final int IMG_SOAD[] = {9, 10, 11, 10};

    // コンストラクタ
    Player(int id, int maxHP) {
      this.id = id;	
      this.maxHP = maxHP;

      // 初期値の設定
      typeATK = AKT_List[0];
      x = 320;
      y = 400;
      score = 0;
      hp = maxHP;
      time = 0;

      // 画像のロード
      img[0] = loadImage(String.format("./player%d/n0.png", id));
      img[1] = loadImage(String.format("./player%d/n1.png", id));
      img[2] = loadImage(String.format("./player%d/n2.png", id));
      img[3] = loadImage(String.format("./player%d/d0.png", id));
      img[4] = loadImage(String.format("./player%d/d1.png", id));
      img[5] = loadImage(String.format("./player%d/d2.png", id));
      img[6] = loadImage(String.format("./player%d/s0.png", id));
      img[7] = loadImage(String.format("./player%d/s1.png", id));
      img[8] = loadImage(String.format("./player%d/s2.png", id));
      img[9] = loadImage(String.format("./player%d/t0.png", id));
      img[10] = loadImage(String.format("./player%d/t1.png", id));
      img[11] = loadImage(String.format("./player%d/t2.png", id));
      for (int i = 0; i < img.length; i++) img[i].resize(48, 48);
    };

    // 移動関数
    void move() {
      // 初回のみ
      if (time == 0) {
        controller.setLED(id, id);
      }

      // プレイヤーの弾の処理
      for (int i = 0; i < playerBullet.size(); i++) if (playerBullet.get(i).move()) playerBullet.remove(i);

      // 攻撃切り替え処理
      if (pButtonR == 0 && controller.getButtonR(id)== 1) {
        pButtonR = 1;

        // 切り替え本体
        typeATK+=1;
        if (typeATK > AKT_List.length) typeATK = AKT_List[0];

        // 切り替えエフェクトの出現
        effect.add(new Effect(0, 0, id == 0 ? EFFECT_PLAYERIMG_1 : EFFECT_PLAYERIMG_2));
      }
      if (controller.getButtonR(id)== 0)  pButtonR = 0;

      // 移動
      time++;
      xAdd = constraind((xAdd + controller.getAngleX(id)/3)/2, -18, 18);
      yAdd = constraind((yAdd + controller.getAngleY(id)/3)/2, -18, 18);
      if (abs((int)xAdd) < 1) xAdd = 0;
      if (abs((int)yAdd) < 1) yAdd = 0;
      x = constrain(x+(int)(xAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 20, 620);
      y = constrain(y+(int)(yAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 50, 475);

      // 攻撃　
      if (controller.getButtonL(id) == 1) {
        switch(typeATK) {
        case ATK_NORMAL:
          playerBullet.add(new Bullet(x+8, y, 6, 180, 16, id == 0 ? BULLET_PLAYER1_NORMAL : BULLET_PLAYER2_NORMAL));
          break;
        case ATK_DUAL:
          if (time%2 == 0)
            for (int i=0; i<2; i++)
              playerBullet.add(new Bullet(x-8+16*i, y, 6, 180, 16, id == 0 ? BULLET_PLAYER1_DUAL : BULLET_PLAYER2_DUAL));
          break;
        case ATK_SNIPER:
          if (time%2 == 0)
            playerBullet.add(new Bullet(x-8, y, 6, 180, 20, id == 0 ? BULLET_PLAYER1_SNIPER : BULLET_PLAYER2_SNIPER));
          break;
        case ATK_SOAD:
          playerBullet.add(new Bullet(x, y, 12, time*8, 6, id == 0 ? BULLET_PLAYER1_SOAD : BULLET_PLAYER2_SOAD));
          break;
        }
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
      switch(typeATK) {
      case ATK_NORMAL:
        image(img[IMG_NORMAL[(time/8)%IMG_NORMAL.length]], x-24, y-24);
        break;
      case ATK_SOAD:
        image(img[IMG_SOAD[(time/8)%IMG_SOAD.length]], x-24, y-24);
        break;
      case ATK_SNIPER:
        image(img[IMG_SNIPER[(time/8)%IMG_SNIPER.length]], x-24, y-24);
        break;
      case ATK_DUAL:
        image(img[IMG_DUAL[(time/8)%IMG_DUAL.length]], x-24, y-24);
        break;
      }
    };

    // HP減少
    void damage() {
      controller.setMotorL(id, 2, 250);
      controller.setMotorR(id, 2, 250);
      hp -= 1;
    }

    // 加点関数
    void addScore(int score) {
      this.score += score;
    }

    // UI表示
    void displayUserInterface() {
      int x = id*320;
      noStroke();
      fill(255, 255, 255, 172);
      rect(5+x, 5, 310, 40);
      textAlign(LEFT, TOP);
      textSize(16);
      stroke(#0000FF);
      if (id == 1) stroke(#FF0000);
      strokeWeight(3);
      fill(#222222);
      rect(x+5, 5, 40, 40);  // キャラクターアイコンに置き換える？
      strokeWeight(1);
      text("PLAYER "+(id+1), x+55, 10);
      textAlign(RIGHT, TOP);
      text(String.format("%,d", score), x+310, 10);
      fill(#222222);
      stroke(#444444);
      rect(x+49, 35, 261, 3);
      fill(#00FF00);
      noStroke();
      rect(x+50, 36, 260*hp/maxHP, 2);
    }
  }

  // 敵のクラス（時間があれば各IDごと子クラスに）
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
    Enemy(int type) {
      x = int(random(40, 600));
      y = -48;
      flg = FLG_IN;
      this.type = type;
    }

    // 処理
    boolean move() {
      // 敵の弾の処理
      for (int i = 0; i < enemyBullet.size(); i++) if (enemyBullet.get(i).move()) enemyBullet.remove(i);

      // 当たり判定（自分の弾がプレイヤーと接触しているかを判定する）
      for (Player p : player)
        for (int i = 0; i < enemyBullet.size(); i++) 
          if (enemyBullet.get(i).hitChk(p.x, p.y, 12)) {
            p.damage();
            enemyBullet.remove(i);
          }

      // 敵本体の処理
      switch(type) {
      case ENEMY_002:
      case ENEMY_001:
        switch(flg) {
        case FLG_IN:
          y+=3;
          if (time == 60) flg = FLG_ATK;
          break;
        case FLG_ATK:
          if (time%2 == 0) for (int i=0; i<8; i++) {
            if (type == ENEMY_001) enemyBullet.add(new Bullet(x, y, 6, i*360/8 + time, 4, BULLET_ZERO));
            if (type == ENEMY_002) enemyBullet.add(new Bullet(x, y, 6, i*360/8 - time, 4, BULLET_ZERO));
          }
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
      case ENEMY_002:
        fill(255);
        noStroke();
        rotateRect(x, y, 48, 48, time*2);
        fill(128, 128, 0);
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
      case EFFECT_PLAYERIMG_1:
        this.x = 20;
        this.y = 80;
        break;
      case EFFECT_PLAYERIMG_2:
        this.x = 620-212;
        this.y = 80;
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
      case EFFECT_PLAYERIMG_1:
      case EFFECT_PLAYERIMG_2:
        time++;
        y++;
        if (time > 80) return true;
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
      case EFFECT_PLAYERIMG_1:
        tint(255.0, 255*(60-time)/40);
        image(Img_Player0, x, y);
        noTint();
        break;
      }
    }
  }

  // コンストラクタ
  STG() {
    super("STG for Debug");
    gameStart_init();
  }

  // ゲームの初期化
  void gameSetup() {
    // ゲーム内変数の初期化
    time = 0;
    gameFlg = FLG_START;
    controller.setZero(0);
    controller.setZero(1);
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
      gameFunctions.gameResult();
      break;
    case FLG_SETUP_BATTLE:
      gameFunctions = new GameFunctions(GAME_TYPE_BATTLE);
      gameFlg = FLG_GAME;
      break;
    case FLG_SETUP_COOPERATION:
      gameFunctions = new GameFunctions(GAME_TYPE_COOPERATION);
      gameFlg = FLG_GAME;
      break;
    case FLG_EXIT:
      exit();
    default:
      println("【EXIT】gameFlg = "+gameFlg);
      exit();
    }

    time++;

    // デバッグ用の情報
    if (modeDebug) {
      int y = 5-12;
      textSize(12);
      msg("modeDebug = TRUE", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("[STG]", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("gameFlg = "+gameFlg, 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("time= "+time, 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("[GameFunctions]", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("player.size() = "+player.size(), 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("effect.size() = "+effect.size(), 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("enemy.size() = "+enemy.size(), 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("ALL_objects = "+(player.size()+effect.size()+enemy.size()), 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("[Processing]", 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("frameCount = "+frameCount, 5, y+=15, LEFT, TOP, #FFFFFF);
      msg("frameRate = "+frameRate, 5, y+=15, LEFT, TOP, #FFFFFF);
    }
  }

  // スタートページ用カーソルクラス
  private class Cursor {
    private int id, time, x, y, pButton = 1;
    private double xAdd, yAdd;

    Cursor(int id) {
      this.id = id;
      time = 0;
      x = 320;
      y = 240;
    }

    boolean move() {
      time++;
      xAdd = constraind((xAdd + controller.getAngleX(id)/3)/2, -18, 18);
      yAdd = constraind((yAdd + controller.getAngleY(id)/3)/2, -18, 18);
      if (abs((int)xAdd) < 1) xAdd = 0;
      if (abs((int)yAdd) < 1) yAdd = 0;
      x = constrain(x+(int)(xAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 0, 640);
      y = constrain(y+(int)(yAdd * (controller.getButtonR(id) == 1 ? 0.4 : 1)), 0, 480);
      if (controller.getButtonL(id) == 1 && pButton == 0) {
		  pButton = 1;
		  return true;
	  }
	  pButton = controller.getButtonL(id);
      return false;
    }

    void display() {
      stroke(#0000FF);
      if (id == 1) stroke(#FF0000);
      strokeWeight(4);
      noFill();
      ellipse(x, y, 32, 32);
      noStroke();
      fill(#0000FF);
      if (id == 1) fill(#FF0000);
      rotateRect(x, y, 46, 4, time);
      rotateRect(x, y, 46, 4, time+90);
      strokeWeight(1);
    }

    // 中心座標からの四角形で当たり判定を行う
    boolean hitChk(int x, int y, int w, int h) {
      if (this.x > x-w/2 && this.x < x+w/2 && this.y > y-h/2 && this.y < y+h/2) return true;
      return false;
    }
  }

  // スタートページ準備関数
  void gameStart_init() {
    // 画像のロード
    Img_StartBack = loadImage("./data/title.png");

    // カーソルの生成
    cursor[0] = new Cursor(0);
    cursor[1] = new Cursor(1);
  }

  // スタート前の説明ページの表示
  private Cursor[] cursor = new Cursor[2];
  void gameStart() {
    // 表示
    background(0);
    image(Img_StartBack, 0, 0);

    // フォーカスの処理
    for (Cursor c : cursor) {
      boolean flg = c.move();
      fill(255, 255, 255, frameCount%6 < 2 ? 128 : 96);
      noStroke();
      if (c.hitChk(160, 240, 180, 40)) {
        centerRect(160, 240, 180, 40);
        if (flg) gameFlg = FLG_SETUP_COOPERATION;
      }
      if (c.hitChk(480, 240, 180, 40)) {
        centerRect(480, 240, 180, 40);
        if (flg) gameFlg = FLG_SETUP_BATTLE;
      }
      /*if (c.hitChk(320, 340, 220, 40)) {
        centerRect(320, 340, 220, 40);
        if (flg) gameFlg = FLG_SETUP_RANKING;
      }*/
      if (c.hitChk(320, 400, 120, 40)) {
        centerRect(320, 400, 120, 40);
        if (flg) gameFlg = FLG_EXIT;
      }
      if (flg) controller.setZero(0);
    };

    // テキスト
    textFont(font);
    textSize(64);
    msg("Gyro STG", 320, 100, CENTER, CENTER, #FFFFFF);
    textSize(32);
    msg("協力モード", 160, 240, CENTER, CENTER, #DDDDDD);
    msg("対戦モード", 480, 240, CENTER, CENTER, #DDDDDD);
    //msg("スコアを見る", 320, 340, CENTER, CENTER, #DDDDDD);
    msg("終了", 320, 400, CENTER, CENTER, #DDDDDD);

    // フォーカスの描画
    for (Cursor c : cursor) c.display();
  };

  // ゲーム中の処理
  void gameRun() {

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

    // UI関連
    gameFunctions.displayFrame();
    gameFunctions.displayUserInterface();

    // ゲーム進行クラス
    gameFunctions.x25();
  }
}
