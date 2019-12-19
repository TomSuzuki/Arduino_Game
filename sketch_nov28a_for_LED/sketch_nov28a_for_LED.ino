#include "LEDX.h"

LEDX l = LEDX();

void setup() {
  l.setup(13);
}

void loop() {
  l.set(true);
  delay(1000);
  l.set(false);
  delay(1000);
}
