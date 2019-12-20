#include "AccelerationLibrary.h"
#include "processing.h"
#include "LEDX.h"
#include "LCDX.h"
#include "VibrationMotor.h"
#include "Button.h"

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

// pinの設定（加速度、LCDは固定ピン）
const int pin_Button[] = {2, 3};   // L R
const int pin_Motor[] = {A0, A1};  // L R
const int pin_LED[] = {8, 9};      // L R

// 制御用クラスの定義
AccelerationClass class_AC = AccelerationClass();
LEDX class_LX[2];
LCDX class_CX = LCDX();
PSENDX class_PX = PSENDX();
VMX class_VX[2];
ButtonX class_BX[2];

// グローバル制御
int frameCount = 0;

void setup()
{
  // 初期化
  Wire.begin();
  Serial.begin(9600);

  // 制御用クラスの初期化
  class_AC.setup();
  class_LX[0].setup(pin_LED[0]);
  class_LX[1].setup(pin_LED[1]);
  class_VX[0].setup(pin_Motor[0]);
  class_VX[1].setup(pin_Motor[1]);
  class_BX[0].setup(pin_Button[0]);
}

void loop()
{
  // 各種センサ、パーツの値などを更新
  class_AC.update();
  class_VX[0].update();
  class_VX[1].update();
  bool ButtonL = class_BX[0].update();
  bool ButtonR = class_BX[1].update();

  // 各種センサの値をとりにいく
  int AngleX = class_AC.getAngleX();
  int AngleY = class_AC.getAngleY();

  // データを送る（加速度の値）
  if (frameCount % 3 == 0) {
    class_PX.sendData(FUNCTION_AC_X, String(AngleX));
    class_PX.sendData(FUNCTION_AC_Y, String(AngleY));
  }

  // データを送る（ボタンの状態）
  if (ButtonL) class_PX.sendData(FUNCTION_SW_LEFT, String(class_BX[0].get()));
  if (ButtonR) class_PX.sendData(FUNCTION_SW_RIGHT, String(class_BX[1].get()));

  // データの受信
  class_PX.getData();

  // コマンドの実行
  String cmd = class_PX.getCmd();
  if (cmd.compareTo("") != 0) {
    switch (getValue(cmd, ',', 0).toInt()) {
      case FUNCTION_TEST: // 何もしない（デバッグ用関数）
        class_PX.sendData(FUNCTION_TEST, "This is test function.");
        break;
      case FUNCTION_LED:  // LEDの制御を行う（0なら0番を光らせる）
        bool b = getValue(cmd, ',', 1).toInt() == 0;
        class_LX[0].set(b);
        class_LX[0].set(!b);
        break;
      case FUNCTION_VM_LEFT:  // Lモーター
        class_VX[0].set(getValue(cmd, ',', 1).toInt(), getValue(cmd, ',', 2).toInt());
        break;
      case FUNCTION_VM_RIGHT:  // Rモーター
        class_VX[1].set(getValue(cmd, ',', 1).toInt(), getValue(cmd, ',', 2).toInt());
        break;
      case FUNCTION_LCD:  // LCDディスプレイに文字列を表示
        class_CX.set(getValue(cmd, ',', 1));
        break;
    }
  }

  // コントローラーの更新速度（1秒間に5回の精度で更新を行う）
  delay(1000 / 60);
  frameCount++; // 内部カウンタ
  digitalWrite(13, frameCount % 30 == 0 ? HIGH : LOW);
}
