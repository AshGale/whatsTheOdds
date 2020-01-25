

class Item {
  int positionX, positionY;
  int player;

  int value = 0;
  boolean building = false;
  boolean unit = false;
  boolean attacker = false;

  Item() {

  }

  Item (int player, int x, int y, int value, boolean building ) {
    this.player = player;
    this.positionX = x;
    this.positionY = y;
    this.value = value;
    this.building = building;
  }

  int getValue() {
    return this.value;
  }

}



