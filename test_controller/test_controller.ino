#include "AccelerationLibrary.h"
#include "processing.h"
#include "LEDX.h"
#include "LCDX.h"

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
    split(cmd, ',', cmds);
    String ss = "cmd_" + cmd;// cmdに文字列が入ってない？変数じゃなかったら送信できる。
    class_PX.sendData(ss);
  }

  // コントローラーの更新速度（1秒間に5回の精度で更新を行う）
  delay(1000 / 60);
}
