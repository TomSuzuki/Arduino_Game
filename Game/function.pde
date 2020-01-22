import java.text.NumberFormat;

// 便利な関数をまとめるやつ

// textを使いやすくした形
void msg(String s, int x, int y, int px, int py, color c) {
  fill(c);
  textAlign(px, py);
  text(s, x, y);
};

// 縁取りmsg
void msg(String s, int x, int y, int px, int py, color c, color c2,int w) {
  textAlign(px, py);
  fill(c2);
  for (int i = 0; i < 9; i++) text(s, x+(-1+i/3)*w, y+(-1+i%3)*w);
  fill(c);
  text(s, x, y);
};

// double型の指定区間関数
double constraind(double p1, double p2, double p3) {
  if (p1 < p2) p1 = p2;
  if (p1 > p3) p1 = p3;
  return p1;
}

// 回転するrect
void rotateRect(int x, int y, int w, int h, int ang) {
  pushMatrix();
  translate(x, y);
  rotate(radians(ang));
  rect(-w/2, -h/2, w, h);
  popMatrix();
}

// 中心座標指定のrect
void centerRect(int x, int y, int w, int h) {
  rect(x-w/2, y-h/2, w, h);
}
