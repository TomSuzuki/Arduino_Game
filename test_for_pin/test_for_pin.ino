#include <LiquidCrystal.h>
#include <Wire.h>
#include "AccelerationLibrary.h"

LiquidCrystal lcd( 4, 6, 10, 11, 12, 13 );
AccelerationClass ac = AccelerationClass();


void setup() {
  lcd.begin( 16, 2 );
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Hello, world!");
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
