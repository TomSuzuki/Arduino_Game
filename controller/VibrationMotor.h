#include "Arduino.h"

class VMX {

  private:
    int pin = A0;
    int power[4] = {0, 72, 128, 255};  // モーターの強さの定義
    float offCounter = 0;
    const int frameRate = 1000 / 60;  // updateを呼ぶ間隔

  public:
    VMX();
    void setup(int pin);
    void set(int n, int s);
    void update();

};

VMX::VMX() {
}

void VMX::setup(int _pin) {
  pin = _pin;
}

// 振動の強さ（0-3）、振動させるミリ秒
void VMX::set(int n, int s) {
  analogWrite(pin, power[n]);
  offCounter = s;
}

// 毎回呼ぶ
void VMX::update() {
  if (offCounter > 0) {
    offCounter -= frameRate;
    if (offCounter < 0) analogWrite(pin, 0);
  }
}
