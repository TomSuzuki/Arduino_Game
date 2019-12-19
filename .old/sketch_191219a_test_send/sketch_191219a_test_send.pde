import processing.serial.*;
Serial serial;

void setup() {
  // シリアルポートの番号と通信速度は適宜修正してください。
  serial = new Serial(this, "/dev/cu.usbmodem1412401", 9600);  
}

void draw() {
}

// テストとして、画面をクリックした際に1024という数値を送信
void mousePressed() { 
  sendIntData(1024);
}

// Processingで扱うintは4バイトなのに対し、
// Arduino UnoやLeonardoで扱うintは2バイトなので注意。
// （よって、使う数値は-32768～32767の範囲にとどめておく）

// intデータの送信
void sendIntData(int value) {
  byte high = (byte)((value & 0xFF00) >> 8);
  byte low =  (byte)( value & 0x00FF);
  serial.write('H');  // ヘッダの送信
  serial.write(high); // 上位バイトの送信
  serial.write(low);  // 下位バイトの送信
}

// Arduino側できちんと受信・復元できたかを確認するために
// データを文字列として送り返してもらって、それをコンソールに表示。
// （Processingとの通信中にシリアルモニタが使えないので）

// データの受信
void serialEvent(Serial port) {
  if ( port.available() > 0 ) {
    String data = trim(port.readStringUntil('\n'));
    if ( data != null ) {
      println("data =", data);
    }
  }
}
