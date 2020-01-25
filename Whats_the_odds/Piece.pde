

class Piece {
  int positionX, positionY;
  int player;

  int value = 0;
  boolean building = false;
  boolean unit = false;
  boolean attacker = false;

  Piece() {

  }

  Piece (int player, int x, int y, int value, boolean building ) {
    //    println(player + " " + x + " " + y + " " + value + " " + building);
    this.player = player;
    this.positionX = x;
    this.positionY = y;
    this.value = value;
    this.building = building;
  }

  int getValue() {
    return this.value;
  }

  int getPositionX () {
    return this.positionX;
  }

}




