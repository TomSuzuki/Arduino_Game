
// STG Game
class Game101 {

  // player
  private class Player {
    PImage img;
    int x, y;
    int id;

    Player(int id, String imgPath) {
      this.id = id;
      img = loadImage(imgPath);
      x = 160+id*320;
      y = 400;
    }

    private void update() {
      // move
      if (controller_AngleX(id) < -8) x -= 5;
      if (controller_AngleY(id) < -8) y -= 5;
      if (controller_AngleX(id) > 8) x += 5;
      if (controller_AngleY(id) > 8) y += 5;

      // hit chk
    }

    private void display() {
      image(img, x-24, y-24);
    }
  }

  // bullet
  private class Bullet {
    Bullet() {
    }
  }

  // var and array
  private Player[] player = new Player[2];

  // constructor
  Game101() {
  }

  public void GmaeInit() {
    player[0] = new Player(0, "./data/s1.gif");
    player[1] = new Player(1, "./data/s2.gif");
  }

  public void GameMain() {
    // map
    background(0);

    // update bullet

    // update player
    player[0].update();
    player[1].update();

    // display bullet

    // display player
    player[0].display();
    player[1].display();
  }
}