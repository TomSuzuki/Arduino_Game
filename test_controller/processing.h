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
  while (Serial.available()) {
    data[ct] = Serial.read();
    if (ct > 64 || data[ct] == ';') {
      data[ct] = '\0';
      cmd = data;
      ct = 0;
    } else ct++;
  }
}

// データの送信を行う
void PSENDX::sendData(String s) {
  for (int i = 0; i < s.length(); i++) Serial.write(s.charAt(i));
  Serial.write(';');
}

String PSENDX::getCmd() {
  String temp = cmd;
  cmd = "";
  return temp;
}
