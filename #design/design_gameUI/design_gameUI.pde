
void setup() {
  size(640, 480);

  // test
  background(#111111);

  // frame
  noStroke();
  fill(#999999);
  rect(0, 0, 640, 50);
  rect(0, 0, 5, 480);
  rect(635, 0, 5, 480);
  rect(0, 475, 640, 5);
  stroke(255);
  fill(0, 0, 0, 0);
  rect(5, 50, 630, 425);

  // ui
  noStroke();
  fill(0);
  rect(319, 2, 2, 46);
  drawUI(0);
  drawUI(1);
}

void drawUI(int id) {
  textAlign(LEFT, TOP);
  textFont(createFont("Osaka", 16, false));
  int x = id*320;
  noStroke();
  fill(#444444);
  //rect(x+5, 5, 310, 40);
  fill(#222222);
  rect(x+5, 5, 40, 40);  // キャラクターアイコンに置き換える
  text("PLAYER "+(id+1), x+55, 10);
  textAlign(RIGHT, TOP);
  text("000,000,000", x+310, 10);
  fill(255);
  rect(x+50, 36, 260, 2);
  fill(#00FF00);
  rect(x+50, 36, 80, 2);
}
