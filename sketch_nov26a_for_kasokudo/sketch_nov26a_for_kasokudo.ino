#include <Wire.h>
#include "AccelerationLibrary.h"

AccelerationClass ac = AccelerationClass();

void setup() {
  Wire.begin();
  Serial.begin(9600);
  ac.setup();
}

void loop() {
  // 加速度センサの情報を更新する
  ac.update();

  // 必要なデータだけ取ってくる
  Serial.print(ac.getAngleX());
  Serial.print("\t");
  Serial.print(ac.getAngleY());
  Serial.println();

  delay(1000 / 5);
}
