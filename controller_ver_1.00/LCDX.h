/*
    2019-12-19 TomSuzuki
    version 1.00

    使い方のメモ
      ピンの場所は固定

    // 文字を出力
    LX.set("test");

*/

#include <LiquidCrystal.h>
#include "Arduino.h"

LiquidCrystal lcd(4, 6, 10, 11, 12, 13);

class LCDX {

  private:

  public:
    LCDX();
    void set(String s);
};

LCDX::LCDX() {
  lcd.begin(16, 2);
  lcd.clear();
}

void LCDX::set(String s) {
  lcd.begin(16, 2);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(s);
  lcd.setCursor(0, 1);
  lcd.print(s.substring(16));
}
