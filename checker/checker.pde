// コントローラのテスト用

// 仮
String test_LCD[] = {"", ""};
int test_LED[] = {0, 1};

void setup() {
  size(640, 480);
  String ArduinoString[] = {"COM5", "COM6"};
  controller_Setup(ArduinoString);
  delay(1000);
  controller_LED(0, 0);
  controller_LED(1, 1);
}

void draw() {
  // 値の表示
  background(0);
  stroke(255);
  for (int i = 0; i < 2; i++) {
    pos(5 + 320*i, 20, 18);
    //msg("ArduinoID = " + ArduinoString[i]);
    msg("");
    msg("Angle_X = "+controller_AngleX(i));
    msg("Angle_Y = "+controller_AngleY(i));
    msg("Button_L = "+controller_ButtonL(i));
    msg("Button_R = "+controller_ButtonR(i));
    msg("");
    msg("Motor_L = #nodata");
    msg("Motor_R = #nodata");
    msg("LED_id = "+test_LED[i]);
    msg("LCD_String = "+test_LCD[i]);

    int x = 5 + 320*i;
    int y = 220;
    if (button(x, y+=20, "Motor_L 3 1000ms")) controller_MotorL(i, 3, 1000);
    if (button(x, y+=20, "Motor_R 3 1000ms")) controller_MotorR(i, 3, 1000);    
    if (button(x, y+=20, "Motor_L 2 500ms")) controller_MotorL(i, 2, 500);
    if (button(x, y+=20, "Motor_R 2 500ms")) controller_MotorR(i, 2, 500);  
    if (button(x, y+=20, "Motor_L 1 500ms")) controller_MotorL(i, 1, 500);
    if (button(x, y+=20, "Motor_R 1 500ms")) controller_MotorR(i, 1, 500);  
    if (button(x, y+=20, "controller_LCD test")) {
      controller_LCD(i, "test");
      test_LCD[i] = "test";
    }
    if (button(x, y+=20, "controller_LCD display!!")) {
      controller_LCD(i, "display!!");    
      test_LCD[i] = "display!!";
    }
    if (button(x, y+=20, "controller_LED 0")) {
      controller_LED(i, 0); 
      test_LED[i] = 0;
    }
    if (button(x, y+=20, "controller_LED 1")) { 
      controller_LED(i, 1); 
      test_LED[i] = 1;
    }
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

boolean button(int x, int y, String s) {
  fill(0);
  if (mouseX == constrain(mouseX, x, x+179) && mouseY == constrain(mouseY, y, y+19)) fill(128);
  rect(x, y, 180, 20);
  fill(255);
  text(s, x+5, y+15);
  if (mouseX == constrain(mouseX, x, x+179) && mouseY == constrain(mouseY, y, y+19) && mousePressed) return true;
  return false;
}