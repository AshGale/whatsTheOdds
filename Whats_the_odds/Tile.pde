

class Tile {
  //this class contains the information about what is in it's tile on the grid
  int positionX, positionY;
  boolean empty = true;
  boolean selected = false;
  int r,g,b;

  Piece piece;

  Tile (int x, int y) {
    this.positionX = x;
    this.positionY = y;
  }

  void setPiece(Piece piece) {
    this.empty = false;
    this.piece = piece;
  }

  void removePiece() {
    this.empty = true;
    this.piece = null;
  }

  Piece getPiece(){
    return this.piece;
  }

  void deselected () {
    this.selected = false; 
  }

  void selected () {
    this.selected = true; 
  }

  void setBackground(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void render() {
    //box for background based on rgb
    if (selected) {
      fill(255,255,0);
    } 
    else {
      fill(r,g,b);
    }
    rect(positionX*tileSize, positionY*tileSize, tileSize, tileSize);
    //    println("render tile at: " + positionX*tileSize + "x" + positionY*tileSize + " " + r);

    if(empty) {
    } 
    else {
      // draw the piece too
      fill(players[this.piece.player].playerColor);
      int centerX = positionX*tileSize+tileSize/2;
      int centerY = positionY*tileSize+tileSize/2;
      ellipse(centerX, centerY, tileSize, tileSize);
      // value of the piece
      textFont(createFont("Arial",tileSize,true),tileSize/2);
      fill(0); // black text
      textAlign(CENTER, CENTER);
      text(piece.getValue(), centerX, centerY);
      textAlign(TOP, LEFT);
    }
  }
}




