#include "Arduino.h"

class ButtonX {

  private:
    int pin = 0;
    int value = 0;
    int ctCount = 0;
    const int maxCt = 5;

  public:
    ButtonX();
    void setup(int pin);
    int get();
    bool update();

};

ButtonX::ButtonX() {
}

void ButtonX::setup(int _pin) {
  pin = _pin;
  pinMode(pin, INPUT_PULLUP);
}

int ButtonX::get() {
  return value == LOW ? 1 : 0;
}

// 更新があったときだけデータを送る（チャタリング処理が雑かも）
bool ButtonX::update() {
  int now = digitalRead(pin);
  if (now == HIGH) ctCount = 0;
  if (maxCt > ctCount++) now = HIGH;
  if (value == now) return false;
  value = now;
  return true;
}
