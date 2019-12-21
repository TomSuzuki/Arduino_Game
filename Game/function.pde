// 便利な関数をまとめるやつ

void msg(String s, int x, int y, int px, int py, color c) {
  fill(c);
  textAlign(px, py);
  text(s, x, y);
};

double constraind(double p1, double p2, double p3) {
  if (p1 < p2) p1 = p2;
  if (p1 > p3) p1 = p3;
  return p1;
}