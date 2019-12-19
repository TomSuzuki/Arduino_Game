// コントローラのテスト用
String ArduinoString[] = {"COM5", "COM6"};

void setup() {
  size(640, 480);
  class_Arduino.arduinoSetup();
  delay(1000);
}

void draw() {
  // 値の表示
  background(0);
  stroke(255);
  for (int i = 0; i < 2; i++) {
    pos(5 + 320*i, 20, 18);
    msg("ArduinoID = " + ArduinoString[i]);
    msg("");
    msg("Angle_X = "+controller_AngleX(i));
    msg("Angle_Y = "+controller_AngleY(i));
    msg("Button_L = "+controller_ButtonL(i));
    msg("Button_R = "+controller_ButtonR(i));
    msg("");
    msg("Motor_L = #Unimplemented");
    msg("Motor_R = #Unimplemented");
    msg("LED_id = #Unimplemented");
    msg("LCD_String = #Unimplemented");
  }
}

// 表示用（仮）
int msgX, msgY, msgAdd;
void pos(int x, int y, int add) {
  msgX = x;
  msgY = y;
  msgAdd = add;
}

void msg(String s) {
  text(s, msgX, msgY);
  msgY += msgAdd;
}