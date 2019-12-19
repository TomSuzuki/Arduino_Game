#include "AccelerationLibrary.h"
#include "processing.h"
#include "LEDX.h"
#include "LCDX.h"

// 関数列挙（できるかぎり同じ形でprocessingでも使えるものが望ましい）
const int FUNCTION_TEST = 999;        // 何も行わない
const int FUNCTION_LED = 10;          // LED制御を行う（processing→arduino）
const int FUNCTION_VM_LEFT = 2;       // 左の振動モーター（processing→arduino）
const int FUNCTION_VM_RIGHT = 3;      // 右の振動モーター（processing→arduino）
const int FUNCTION_LCD = 32;          // LCDディスプレイに文字を送る（processing→arduino）
const int FUNCTION_AC_X = 7;          // xの傾き（arduino→processing）
const int FUNCTION_AC_Y = 8;          // yの傾き（arduino→processing）
const int FUNCTION_SW_LEFT = 5;       // 左のスイッチ（arduino→processing）
const int FUNCTION_SW_RIGHT = 6;      // 右のスイッチ（arduino→processing）

// pinの設定
const int pin_Swicth[] = {2, 3};
const int pin_Motor[] = {A0, A1};
const int pin_LED[] = {8, 9};

// 制御用クラスの定義
AccelerationClass class_AC = AccelerationClass();
LEDX class_LX[2];
LCDX class_CX = LCDX();
PSENDX class_PX = PSENDX();

void setup()
{
  // 初期化
  Wire.begin();
  Serial.begin(9600);

  // 制御用クラスの初期化
  class_AC.setup();
  class_LX[0].setup(pin_LED[0]);
  class_LX[1].setup(pin_LED[1]);

}

void loop()
{
  // 各種センサの値を更新
  class_AC.update();

  // 各種センサの値をとりにいく
  int x = class_AC.getAngleX();
  int y = class_AC.getAngleY();

  // データを送る

  // データの受信
  class_PX.getData();

  // コマンドの実行
  String cmds[] = {};
  String cmd = class_PX.getCmd();
  if (cmd.compareTo("") != 0) {
    switch (getValue(cmd, ',', 0).toInt()) {
      case FUNCTION_TEST:
        break;
      case FUNCTION_LED:  // LEDの制御を行う（0なら0番を光らせる）
        bool b = getValue(cmd, ',', 1).toInt() == 0;
        class_LX[0].set(b);
        class_LX[0].set(!b);
        break;
    }
  }

  // コントローラーの更新速度（1秒間に5回の精度で更新を行う）
  delay(1000 / 60);
}
