
void inputDirectionAction (int ofsetX, int ofsetY) {
  Piece piece = grid[selectedX][selectedY].piece;

  if(piece.building) {
    //is base and will creaet units in next tile, or add + if < 6 else nothing
    //          println("create unit right of building");
    createPiece(selectedX+ofsetX, selectedY+ofsetY);
    update();
  } 
  else {
    //          println("move unit right");
    //need to be changed for each direction key
    if(selectedX+ofsetX >= tileAmmount || selectedY+ofsetY >= tileAmmount 
      || selectedX+ofsetX < 0 || selectedY+ofsetY < 0) {
      //trying to move out of the board
    } 
    else {
      movePiece(selectedX, selectedY, selectedX+ofsetX, selectedY+ofsetY);
      selectedX += ofsetX;
      selectedY += ofsetY;
      update();
    }
  } 
}

void createPiece(int x, int y) {
  Tile tile = grid[x][y];

  if (tile.empty) {
    //    println("here: " + x + " " + y);
    grid[x][y].setPiece(new Piece(playerTurn, x, y, 1, false));
  } 
  else {
    if (tile.piece.value < 6) {
      //players[playerTurn].playerMoves--;
      grid[x][y].piece.value++;
    }
  }
}

void movePiece(int a, int b, int x, int y) {
  Tile tileFrom = grid[a][b];
  Tile tileTo = grid[x][y];

  //do nothing if the selected tile is empty, or destination is out of the board
  if(tileFrom.empty ) {

  } 
  else {
    if (tileTo.empty) {
      //      println("tile to empty, removing piece from " + a + " " + b);
      tileTo.selected();
      tileTo.setPiece(tileFrom.piece);//piece is null for some reason
      tileFrom.removePiece(); //needs to be after due to being pointer
      tileFrom.deselected();
      players[playerTurn].playerMoves--;
    } 
    else {
      //check of the tile being moved too has another players piece in it
      if (tileTo.piece.playerId == playerTurn) {
        //        println("too tile owned by player");
        //players[playerTurn].playerMoves--;

        int aggregate = tileFrom.piece.value + tileTo.piece.value;

        //
        if(tileTo.piece.building) {
          //know value is 7-12

        } 
        else {
          //too is a unit
          if(aggregate > 6) {

          } 
          else {
            //add from into too
            tileTo.selected(); 
            tileFrom.piece.value = aggregate;   
            tileTo.setPiece(tileFrom.piece);
            tileFrom.removePiece();
            tileFrom.deselected();
          }
        }
      } 
      else {
        //        println("tile too not player owned");
        //players[playerTurn].playerMoves--;
        int difference = tileFrom.piece.value - tileTo.piece.value; //eg 6 - 2 or 2 - 6

        //logic for taking other pieces
        if(difference > 0) {
          //attacker was stronger
          tileFrom.piece.value = difference;
          tileTo.selected();    
          tileTo.setPiece(tileFrom.piece);
          tileFrom.removePiece();
          tileFrom.deselected();
        } 
        else if (difference > 0) {
          //defender stronger
          tileTo.piece.value += difference;    
          tileTo.setPiece(tileTo.piece);
          tileFrom.removePiece();
        } 
        else {
          //must be 0, and both get removed.
          tileFrom.removePiece();
          tileFrom.deselected();    
          tileTo.deselected();    
          tileTo.removePiece();
          selectedATile = false;
          tileFrom.deselected();    
        }
      }
    }
  }
}


