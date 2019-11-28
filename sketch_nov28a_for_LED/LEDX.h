#include "Arduino.h"

class LEDX {

  private:
    int pin = 0;

  public:
    LEDX();
    void setup(int pin);
    void set(bool b);

};

LEDX::LEDX(){
}

void LEDX::setup(int _pin) {
  pin = _pin;
  pinMode(pin, OUTPUT);
  digitalWrite(pin, LOW);
}

void LEDX::set(bool b) {
  digitalWrite(pin, b ? HIGH : LOW);
}
