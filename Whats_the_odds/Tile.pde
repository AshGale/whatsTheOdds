

class Tile {
  //this class contains the information about what is in it's tile on the grid
  int positionX, positionY;
  boolean empty = true;
  boolean selected = false;
  color backgroundColor;
  Piece piece = null;

  Tile (int x, int y) {
    this.positionX = x;
    this.positionY = y;
  }

  void setPiece(Piece piece) {
    this.empty = false;
    this.piece = piece;
    //    println("setting piece: " + this.empty + " " + positionX + " " + positionY + " " + piece);
  }

  void removePiece() {
    this.empty = true;
    this.piece = null;
    // println("removing piece: " + this.empty + " " + positionX + " " + positionY);
  }

  void deselected () {
    this.selected = false; 
  }

  void selected () {
    this.selected = true; 
  }

  void render() {
    //box for background based on rgb
    if (selected) {
      fill(255,255,0);
    } 
    else {
      fill(backgroundColor);
    }
    rect(positionX*tileSize, positionY*tileSize, tileSize, tileSize);
    //    println("render tile at: " + positionX*tileSize + "x" + positionY*tileSize + " " + r);

    //println("empty: " + this.empty + " " + positionX + " " + positionY);
    if(this.empty) {
    } 
    else {
      // draw the piece too
      //      println("drawing: " + positionX + " " + positionY);
      fill(players[this.piece.playerId].playerColor);
      int centerX = positionX * tileSize + tileSize / 2;
      int centerY = positionY * tileSize + tileSize / 2;
      ellipse(centerX, centerY, tileSize, tileSize);
      // value of the piece
      textFont(createFont("Arial",tileSize,true),tileSize/2);
      fill(0); // black text
      textAlign(CENTER, CENTER);
      text(piece.value, centerX, centerY);
      textAlign(TOP, LEFT);
    }
  }
}





