#include "Arduino.h"

class ButtonX {

  private:
    int pin = 0;

  public:
    ButtonX();
    void setup(int pin);
    int get();

};

ButtonX::ButtonX() {
}

void ButtonX::setup(int _pin) {
  pin = _pin;
  pinMode(pin, INPUT_PULLUP);
}

int ButtonX::get() {
  return digitalRead(pin) == LOW ? 1 : 0;
}
