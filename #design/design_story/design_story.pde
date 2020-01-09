
void setup() {
  size(640, 480);

  // test
  background(#111111);
  noStroke();
  fill(#222222);
  rect(5, 340, 630, 475-340);

  fill(#FFFFFF);
  textAlign(LEFT, TOP);
  textFont(createFont("Osaka", 16, true));
  text("[text]\nあのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。", 15, 350, 610, 999);
}
