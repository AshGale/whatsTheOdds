

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
    checkifLastPlayerPiece();
    // println("removing piece: " + this.empty + " " + positionX + " " + positionY);
  }

  void deselected () {
    this.selected = false; 
  }

  void selected () {
    this.selected = true; 
  }

  void checkifLastPlayerPiece() {
    //check if selected piece is last piece
    int playerPiecesCount = 0;
    Piece testPiece;

    for (int i = 0; i < tileAmmount; i++ ) {
      for (int k = 0; k < tileAmmount; k++ ) {
        if(grid[i][k].empty){

        } 
        else {
          testPiece = grid[i][k].piece;
          if (testPiece.playerId == this.piece.playerId) {         
            playerPiecesCount++;
          }
        }
      }
    }
    //if only 1 piece, then it's that last
    println("pieces "+playerPiecesCount);
    if (playerPiecesCount == 1) {
      println("removing las piece for player" + piece.playerId);
      players[this.piece.playerId].playerMoves = 0;
      players[this.piece.playerId].alive = false;
      this.empty = true;
      this.piece = null;
    } 
    else {
      this.empty = true;
      this.piece = null;      
    } 
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
      if(this.piece.building){
        rectMode(CENTER);
        rect(centerX, centerY, tileSize-padding, tileSize-padding);
        rectMode(CORNER);
      } 
      else {
        // unit
        if(this.piece.value%2 == 0){
          //attacker          	
          triangle(centerX-tileSize/2, centerY+tileSize/2, centerX, centerY-tileSize/2, centerX+tileSize/2, centerY+tileSize/2);
        } 
        else {
          ellipse(centerX, centerY, tileSize, tileSize);
        }
      }

      // value of the piece
      textFont(createFont("Arial",tileSize,true), tileSize/2);
      fill(0); // black text
      textAlign(CENTER, CENTER);
      text(piece.value, centerX, centerY);
      textAlign(TOP, LEFT);
    }
  }
}







