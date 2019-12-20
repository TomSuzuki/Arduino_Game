// クラス
getKeys keys = new getKeys();
class getKeys {

  // キーをまとめる
  public getKey KeyClass[] = new getKey[256];

  // 初期化
  getKeys() {
    for (int i = 0; i < KeyClass.length; i++) KeyClass[i] = new getKey(i);
  }

  // 押したキーが送られてくる
  public void set_push(int k) {
    for (int i = 0; i < KeyClass.length; i++) if (KeyClass[i].isCode(k)) {
      KeyClass[i].set_push();
      break;
    }
  }

  // 離したキーが送られてくる
  public void set_releas(int k) {
    for (int i = 0; i < KeyClass.length; i++) if (KeyClass[i].isCode(k)) {
      KeyClass[i].set_releas();
      break;
    }
  }

  // キーのためのクラス
  class getKey {

    // 使う変数
    private int code = 0;
    private boolean isPush = false;
    private boolean nowPush = false;

    // コンストラクタ
    getKey(int code) {
      this.code = code;
    }

    // 押されたときのこれを呼ぶ
    public void set_push() {
      isPush = true;
      nowPush = true;
    }

    // 離されたときにこれを呼ぶ
    public void set_releas() {
      isPush = false;
      nowPush = false;
    }

    // コードか
    public boolean isCode(int code) {
      return code == this.code;
    }

    // コードを取得
    public int get_code() {
      return code;
    }

    // 押されている間true
    public boolean get_isPush() {
      return isPush;
    }

    // 1度だけtrueを返す
    public boolean get_nowPush() {
      boolean temp = nowPush;
      this.nowPush = false;
      return temp;
    }
  }
}

// 押した
void keyPressed() {
  keys.set_push(keyCode);
}

// 離した
void keyReleased() {
  keys.set_releas(keyCode);
}
