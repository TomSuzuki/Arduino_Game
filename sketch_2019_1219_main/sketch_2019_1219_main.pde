import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// 変数（コントローラー接続用）
Serial[] serial_arduino = {null, null};
String[] StringData = {"", ""};

// 送信関数定義
final int FUNCTION_TEST = 999;        // 何も行わない
final int FUNCTION_LED = 10;          // LED制御を行う（processing→arduino）
final int FUNCTION_VM_LEFT = 2;       // 左の振動モーター（processing→arduino）
final int FUNCTION_VM_RIGHT = 3;      // 右の振動モーター（processing→arduino）
final int FUNCTION_LCD = 32;          // LCDディスプレイに文字を送る（processing→arduino）
final int FUNCTION_AC_X = 7;          // xの傾き（arduino→processing）
final int FUNCTION_AC_Y = 8;          // yの傾き（arduino→processing）
final int FUNCTION_SW_LEFT = 5;       // 左のスイッチ（arduino→processing）
final int FUNCTION_SW_RIGHT = 6;      // 右のスイッチ（arduino→processing）

void setup() {
  // 接続を行う
  fn_setup();
}

// test
void mousePressed() { 
  sendData(0, ""+FUNCTION_LED+",testData");
  //sendData(1, "1999 OK?");
}

void draw() {
}

// Arduino 2台を接続する
void fn_setup() {
  String[] Arduinos = getArduinos();
  if (Arduinos.length != 2) {
    println("Arduinoの取得に失敗しました。");
    //exit();
  }
  println(Arduinos);
  serial_arduino[0] = new Serial(this, Arduinos[0], 9600);
  //serial_arduino[1] = new Serial(this, Arduinos[1], 9600);
}

// Arduinoの一覧を取得する（Mac用）
String[] getArduinos() {
  String[] ss = {};
  String[] list = Arduino.list();
  for (String s : list) if (s.split("cu.usbmodem").length == 2) ss = append(ss, s);
  return ss;
}

// shortデータの送信
void sendData(int n, String s) {
  serial_arduino[n].write(s + ";");
}

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
        println("port =", pt, "[", StringData[pt], "]");
        StringData[pt] = "";
      }
    }
  }
}
