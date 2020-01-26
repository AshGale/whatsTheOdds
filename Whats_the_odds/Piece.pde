

class Piece {
  int positionX, positionY;
  int playerId;
  int value = 0;
  boolean building = false;
  boolean unit = false;
  boolean attacker = false;

  Piece (int playerId, int x, int y, int value, boolean building ) {
    //    println(player + " " + x + " " + y + " " + value + " " + building);
    this.playerId = playerId;
    this.positionX = x;
    this.positionY = y;
    this.value = value;
    this.building = building;
  }
}




