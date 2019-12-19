import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

ArduinoX class_Arduino = new ArduinoX();  // 名前固定

class ArduinoX {

  // 使用する変数とか
  private Serial[] serial_arduino = {null, null};
  private String[] StringData = {"", ""};

  // 状態保存用変数
  private int AngleX[] = {0, 0};
  private int AngleY[] = {0, 0};
  private int ButtonL[] = {0, 0};
  private int ButtonR[] = {0, 0};

  // 定義
  private final int FUNCTION_TEST = 999;        // 何も行わない
  private final int FUNCTION_LED = 10;          // LED制御を行う（processing→arduino）
  private final int FUNCTION_VM_LEFT = 2;       // 左の振動モーター（processing→arduino）
  private final int FUNCTION_VM_RIGHT = 3;      // 右の振動モーター（processing→arduino）
  private final int FUNCTION_LCD = 32;          // LCDディスプレイに文字を送る（processing→arduino）
  private final int FUNCTION_AC_X = 7;          // xの傾き（arduino→processing）
  private final int FUNCTION_AC_Y = 8;          // yの傾き（arduino→processing）
  private final int FUNCTION_SW_LEFT = 5;       // 左のスイッチ（arduino→processing）
  private final int FUNCTION_SW_RIGHT = 6;      // 右のスイッチ（arduino→processing）

  // 初期化を行う
  void arduinoSetup() {
    serial_arduino[0] = makeSerial(ArduinoString[0]);
    serial_arduino[1] = makeSerial(ArduinoString[1]);
    println("接続完了！");
  }

  // Arduinoのリストを取得する
  // 未実装

  // データの受信
  void serialEvent(Serial port) {
    while (port.available() > 0 ) {
      String data = port.readString();
      if ( data != null ) {
        int pt = port.port == serial_arduino[0].port ? 0 : 1;
        if (!data.equals(";")) {
          StringData[pt] += data;
        } else {
          // 受信データから実行
          String[] cmds = StringData[pt].split(",");
          switch(int(cmds[0])) {
          case FUNCTION_AC_X:  // 角度の受け取り
            if (cmds.length > 1) AngleX[pt] = int(cmds[1]);
            break;
          case FUNCTION_AC_Y:  // 角度の受け取り
            if (cmds.length > 1) AngleY[pt] = int(cmds[1]);
            break;
          case FUNCTION_SW_LEFT:  // ボタン
            if (cmds.length > 1) ButtonL[pt] = int(cmds[1]);
            break;          
          case FUNCTION_SW_RIGHT:  // ボタン
            if (cmds.length > 1) ButtonR[pt] = int(cmds[1]);
            break;
          }
          // コマンドをリセット
          StringData[pt] = "";
        }
      }
    }
  }

  // 取得用
  int getAngleX(int player) {
    return -AngleX[player];
  }

  int getAngleY(int player) {
    return AngleY[player];
  }

  int getButtonL(int player) {
    return ButtonL[player];
  }

  int getButtonR(int player) {
    return ButtonR[player];
  }

  // 送信用
  void setCmd(int player, String s) {
    serial_arduino[player].write(s + ";");
  }
}

// うけとりー
void serialEvent(Serial port) {
  class_Arduino.serialEvent(port);
}

// なんかグローバルじゃなきゃうまく行かなかった
Serial makeSerial(String s) {
  return new Serial(this, s, 9600);
}