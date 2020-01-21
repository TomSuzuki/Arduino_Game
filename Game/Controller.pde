/*
 * コントローラー用クラス ver 1.12
 * - クラス名のcontrollerは固定（serial関連がうまく行き次第直す）
 *
 * // setup内で必ず実行
 * controller.arduinoSetup(Arduinoのリスト);
 * 
 * // その他の関数
 * 【未実装】getArduinoList();  // Arduinoのリストを取得（macのみ自動で判別可能）
 *
 * // 情報取得用関数（iはプレイヤーのID）
 * controller.getAngleX(i);
 * controller.getAngleY(i);
 * controller.getButtonL(i));
 * controller.getButtonR(i));
 * 
 * // コントローラ操作用関数（iはプレイヤーのID）
 * controller.setMotorL(i, power, ms);  // powerは0-3の4段階
 * controller.setMotorR(i, power, ms);
 * controller.setLCD(i, s);  // sはディスプレイに表示する文字列（最大32文字）
 * controller.setLCD(i, s1, s2);  // 1行ごとに別引数で送る
 * controller.setLED(i, n);  // nはコントローラーID（基本的にiと同じ）
 * controller.setZero(i);  // コントローラを初期化
 * 
 * // デバッグ用
 * controller.getArduinoName(i);  // 名前の取得
 * 
 */


// 必要なもののインポート
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// 制御用クラス生成
Controller controller = new Controller();  // 名前固定

// 送受信用定義
final int FUNCTION_TEST = 999;        // 何も行わない
final int FUNCTION_LED = 10;          // LED制御を行う（processing→arduino）
final int FUNCTION_VM_LEFT = 2;       // 左の振動モーター（processing→arduino）
final int FUNCTION_VM_RIGHT = 3;      // 右の振動モーター（processing→arduino）
final int FUNCTION_LCD = 32;          // LCDディスプレイに文字を送る（processing→arduino）
final int FUNCTION_AC_X = 7;          // xの傾き（arduino→processing）
final int FUNCTION_AC_Y = 8;          // yの傾き（arduino→processing）
final int FUNCTION_SW_LEFT = 5;       // 左のスイッチ（arduino→processing）
final int FUNCTION_SW_RIGHT = 6;      // 右のスイッチ（arduino→processing）
final int FUNCTION_RESET = 9;         // 値を初期化（processing→arduino）

// 推奨引数
final int MOTOR_OFF = 0;
final int MOTOR_LOW = 1;
final int MOTOR_MIDDLE = 2;
final int MOTOR_HIGH = 3;

// まとめようとして中途半端になったやつ
class Controller {

  // Arduinoの状態を保存するclass
  private ArrayList<ArduinoState> arduinoState = new ArrayList<ArduinoState>();

  // 内部用クラス（Arduinoの状態）
  private class ArduinoState {

    // 保存用変数
    private int AngleX = 0;
    private int AngleY = 0;
    private int ButtonL = 0;
    private int ButtonR = 0;
    private String Command = "";
    private Serial serial = null;
    private String ArduinoName = "";

    // コンストラクタ（COMなどの文字列を入れる）
    ArduinoState(String ArduinoName) {
      this.ArduinoName = ArduinoName;
      serial = makeSerial(ArduinoName);
    }
  }

  // 初期化を行う
  void arduinoSetup(String[] list) {
    for (int i= 0; i < list.length; i++) arduinoState.add(i, new ArduinoState(list[i]));  // 順番は保証されているはず...
  }

  // データの受信
  void serialEvent(Serial port) {
    while (port.available() > 0 ) {
      String data = port.readString();
      if ( data == null ) return;  // データがなければ終了
      int player = -1;
      while (port.port != arduinoState.get(++player).serial.port);  // 一致するものを探索（線形）
      if (player > arduinoState.size()) return;  // 一致するものがなければ終了（そんなことないと思うけど...）
      if (!data.equals(";")) arduinoState.get(player).Command += data; // 受信データを一時的に保存
      else {  // コマンドの実行
        // 受信データから実行
        String[] cmds = arduinoState.get(player).Command.split(",");
        switch(int(cmds[0])) {
        case FUNCTION_AC_X:  // 角度の受け取り
          if (cmds.length > 1) arduinoState.get(player).AngleX = int(cmds[1]);
          break;
        case FUNCTION_AC_Y:  // 角度の受け取り
          if (cmds.length > 1) arduinoState.get(player).AngleY = int(cmds[1]);
          break;
        case FUNCTION_SW_LEFT:  // ボタン
          if (cmds.length > 1) arduinoState.get(player).ButtonL = int(cmds[1]);
          break;          
        case FUNCTION_SW_RIGHT:  // ボタン
          if (cmds.length > 1) arduinoState.get(player).ButtonR = int(cmds[1]);
          break;
        }

        // コマンドをリセット
        arduinoState.get(player).Command = "";
      }
    }
  }

  // デバッグ用
  String getArduinoName(int player) {
    return arduinoState.get(player).ArduinoName;
  }

  // 取得用
  int getAngleX(int player) {
    return -arduinoState.get(player).AngleX;
  }

  int getAngleY(int player) {
    return arduinoState.get(player).AngleY;
  }

  int getButtonL(int player) {
    return arduinoState.get(player).ButtonL;
  }

  int getButtonR(int player) {
    return arduinoState.get(player).ButtonR;
  }

  // 送信用（内部用）
  private void sendCmd(int player, String s) {
    arduinoState.get(player).serial.write(s.substring(0, min(64, s.length())) + ";");
  }

  // 送信用
  void setLED(int n, int m) {
    sendCmd(n, ""+FUNCTION_LED+","+m);
  }

  void setMotorL(int n, int m, int l) {
    sendCmd(n, ""+FUNCTION_VM_LEFT+","+m+","+l);
  }

  void setMotorR(int n, int m, int l) {
    sendCmd(n, ""+FUNCTION_VM_RIGHT+","+m+","+l);
  }

  void setLCD(int n, String s) {
    sendCmd(n, ""+FUNCTION_LCD+","+s);
  }

  void setLCD(int n, String s, String s2) {
    s = s + "                  ";
    sendCmd(n, ""+FUNCTION_LCD+","+s.substring(0, 16)+s2);
  }

  void setZero(int n) {
    sendCmd(n, ""+FUNCTION_RESET);
  }

  // Arduinoのリストを取得する（未完成；Mac用↓）
  String[] getArduinoList() {
    String[] ss = {};
    String[] list = Arduino.list();
    for (String s : list) {
      if (s.split("cu.usbmodem").length == 2) ss = append(ss, s);
      println(s.toString());
    }
    return ss;
  }
}

// 受信があった（グローバルじゃないとうまくいかない）
void serialEvent(Serial port) {
  controller.serialEvent(port);  // 内部で受け取れたらいいんだけど...
}

// Arduinoを登録する（グローバルじゃないとうまくいかない）
Serial makeSerial(String s) {
  return new Serial(this, s, 9600);  // thisを解決すれば内部で完結
}
