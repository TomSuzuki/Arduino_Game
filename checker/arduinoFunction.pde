// controllerからとってきたデータを成型してゲームに渡す

final int FUNCTION_TEST = 999;        // 何も行わない
final int FUNCTION_LED = 10;          // LED制御を行う（processing→arduino）
final int FUNCTION_VM_LEFT = 2;       // 左の振動モーター（processing→arduino）
final int FUNCTION_VM_RIGHT = 3;      // 右の振動モーター（processing→arduino）
final int FUNCTION_LCD = 32;          // LCDディスプレイに文字を送る（processing→arduino）
final int FUNCTION_AC_X = 7;          // xの傾き（arduino→processing）
final int FUNCTION_AC_Y = 8;          // yの傾き（arduino→processing）
final int FUNCTION_SW_LEFT = 5;       // 左のスイッチ（arduino→processing）
final int FUNCTION_SW_RIGHT = 6;      // 右のスイッチ（arduino→processing）

int controller_AngleX(int n) {
  return class_Arduino.getAngleX(n);
}

int controller_AngleY(int n) {
  return class_Arduino.getAngleY(n);
}

int controller_ButtonL(int n) {
  return class_Arduino.getButtonL(n);
}

int controller_ButtonR(int n) {
  return class_Arduino.getButtonR(n);
}

void controller_MotorL(int n, int m, int l) {
  sendCmd(n, ""+FUNCTION_VM_LEFT+","+m+","+l);
}

void controller_MotorR(int n, int m, int l) {
  sendCmd(n, ""+FUNCTION_VM_RIGHT+","+m+","+l);
}

void controller_LED(int n, int m) {
  sendCmd(n, ""+FUNCTION_LED+","+m);

  // test
  test_LED[n] = m;
}

void controller_LCD(int n, String s) {
  sendCmd(n, ""+FUNCTION_LCD+","+s);

  // test
  test_LCD[n] = s;
}

void sendCmd(int n, String s) {
  class_Arduino.setCmd(n, s);
}