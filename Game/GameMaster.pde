// ゲーム用のクラスの型
class gameMaster {

  // 変数とか
  String gameTitle =  "";

  // コンストラクタ（タイトル画面に必要なものはここで用意する）
  gameMaster(String gameTitle) {
    this.gameTitle = gameTitle;
  }

  // ゲーム開始前に１度呼ばれる
  void gameSetup() {
  }

  // ゲーム中に毎回呼ばれる
  void gameMain() {
  }

  // タイトル画面表示時に呼ばれる
  void gameTitle() {
  }
  
}
