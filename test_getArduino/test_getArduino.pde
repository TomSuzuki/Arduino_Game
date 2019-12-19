import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// 変数
Serial[] serial_arduino = {null, null};

void setup() {
  // 接続を行う
  fn_setup();
}

// test
void mousePressed() { 
  sendIntData(0, 1033);
  sendIntData(1, 1999);
}

void draw() {
}

// Arduino 2台を接続する
void fn_setup() {
  String[] Arduinos = getArduinos();
  if (Arduinos.length != 2) {
    println("Arduinoの取得に失敗しました。");
    exit();
  }
  println(Arduinos);
  serial_arduino[0] = new Serial(this, Arduinos[0], 9600);
  serial_arduino[1] = new Serial(this, Arduinos[1], 9600);
}

// Arduinoの一覧を取得する（Mac用）
String[] getArduinos() {
  String[] ss = {};
  String[] list = Arduino.list();
  for (String s : list) if (s.split("cu.usbmodem").length == 2) ss = append(ss, s);
  return ss;
}

// shortデータの送信
void sendIntData(int n, int value) {
  byte high = (byte)((value & 0xFF00) >> 8);
  byte low =  (byte)( value & 0x00FF);
  serial_arduino[n].write('H');  // ヘッダの送信
  serial_arduino[n].write(high); // 上位バイトの送信
  serial_arduino[n].write(low);  // 下位バイトの送信
}

// データの受信
void serialEvent(Serial port) {
  if (port.available() > 0 ) {
    String data = trim(port.readStringUntil('\n'));
    if ( data != null ) {
      println("data =", data, ": port =",port.port == serial_arduino[0].port ? "0" : "1");
    }
  }
}
