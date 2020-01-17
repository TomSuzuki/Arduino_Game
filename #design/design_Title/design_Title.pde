
void setup() {
  size(640, 480);
  PImage img = loadImage("title.png");

  // test
  background(#111111);
  image(img, 0, 0);

  stroke(#FFFFFF);
  textAlign(CENTER, TOP);
  textFont(createFont("SoukouMincho", 64, true));
  text("タイトル", 320, 100);
  textSize(24);
  text("開始", 320, 300);
  text("記録", 320, 330);
  text("終了", 320, 360);
}
