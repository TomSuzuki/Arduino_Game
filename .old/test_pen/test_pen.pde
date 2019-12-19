


void setup() {
  size(640, 480);
}

void draw() {
  int y = 25;
  background(0);
  for (int i = 0; i < keys.KeyClass.length; i++)if (keys.KeyClass[i].get_nowPush()) {
    text(i, 5, y);
    y+=18;
  }
}
