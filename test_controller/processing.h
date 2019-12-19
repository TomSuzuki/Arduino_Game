#include "Arduino.h"

class PSENDX {

  private:
    char data[65];
    String cmd = "";
    int ct;

  public:
    PSENDX();
    void setup(int pin);
    void getData();
    void sendData(String s);
    String getCmd();

};

PSENDX::PSENDX() {
}

void PSENDX::setup(int _pin) {
}

void PSENDX::getData() {
  // データ受信したとき（最大64文字）
  if (Serial.available()) {
    data[ct] = Serial.read();
    if (ct > 64 || data[ct] == '\0') {
      data[ct] = ';';
      cmd = data;
      ct = 0;
    } else ct++;
  }
}

// データの送信を行う
void PSENDX::sendData(String s) {
  //s = s + ";";
  //char c = s.c_str();
  char c[] = "rrr;";
  Serial.write(c);
}

String PSENDX::getCmd() {
  String temp = cmd;
  cmd = "";
  return temp;
}
