
void nextPlayersTurn() {
  players[playerTurn].roled = roleDice();
  int income = getPlayerPlayerIncome();
  players[playerTurn].playerMoves = players[playerTurn].roled + income;
  startTurn = false;
  update();
}

void inputDirectionAction (int ofsetX, int ofsetY) {
  Piece piece = grid[selectedX][selectedY].piece;

  if(piece.building) {
    //is base and will creaet units in next tile, or add + if < 6 else nothing
    //          println("create unit right of building");
    if(createPiece(selectedX+ofsetX, selectedY+ofsetY)) {
      players[playerTurn].playerMoves--;
      update();      
    } 
    else {

    }
  } 
  else {
    //          println("move unit right");
    //need to be changed for each direction key
    if(selectedX+ofsetX >= tileAmmount || selectedY+ofsetY >= tileAmmount 
      || selectedX+ofsetX < 0 || selectedY+ofsetY < 0) {
      //trying to move out of the board
    } 
    else {
      if(movePiece(selectedX, selectedY, selectedX+ofsetX, selectedY+ofsetY)) {
        players[playerTurn].playerMoves--;        
        selectedX += ofsetX;
        selectedY += ofsetY;
        update();
      } 
      else {
        //can't move there
      }
    }
  } 
}

boolean createPiece(int x, int y) {
  Tile tile = grid[x][y];

  if (tile.empty) {
    //    println("here: " + x + " " + y);
    grid[x][y].setPiece(new Piece(playerTurn, x, y, 1, false));
    return true;
  } 
  else {
    if(tile.piece.playerId == playerTurn){
      if (tile.piece.value < 6) {
        //players[playerTurn].playerMoves--;
        grid[x][y].piece.value++;
        return true;
      }
    }  
    else {      
      tile.piece.value--;      
      if(tile.piece.value == 0) {
        tile.removePiece();        
      } 
      else if (tile.piece.building) {
        if(tile.piece.value <= 6) {
          tile.piece.building = false;
        }
      }
      return true;
    }
  }
  return false;
}

boolean movePiece(int a, int b, int x, int y) {
  Tile tileFrom = grid[a][b];
  Tile tileTo = grid[x][y];

  //do nothing if the selected tile is empty, or destination is out of the board
  if(tileFrom.empty ) {
    return false;
  } 
  else {
    if (tileTo.empty) {
      //      println("tile to empty, removing piece from " + a + " " + b);
      tileTo.selected();
      tileTo.setPiece(tileFrom.piece);//piece is null for some reason
      tileFrom.removePiece(); //needs to be after due to being pointer
      tileFrom.deselected();
      return true;
    } 
    else {
      //check of the tile being moved too has another players piece in it
      if (tileTo.piece.playerId == playerTurn) {
        //        println("too tile owned by player");
        int aggregate = tileFrom.piece.value + tileTo.piece.value;        

        if(tileTo.piece.building) {
          //know value is 7-12
          if(tileTo.piece.playerId == playerTurn) {
            println("player" + (tileFrom.piece.playerId+1) + " healing base");

            if (aggregate > 12) {
              tileTo.piece.value = 12;              
              tileFrom.piece.value = aggregate - 12;
              tileFrom.deselected();
              tileTo.selected();
              return true;
            } 
            else {
              tileTo.piece.value = aggregate;              
              tileFrom.deselected();
              tileFrom.removePiece();
              selectedATile = false;
              return true;
            }
          } 
          else {
            return false; 
          }

        } 
        else {
          //to is a unit      
          if(aggregate > 6) {
            if(tileFrom.piece.value == 6 && tileTo.piece.value == 6) {
              //make base
              tileTo.selected(); 
              tileTo.piece.building = true; // new Piece(i, px, py, 12, true)
              tileTo.piece.value = 12;
              tileFrom.removePiece();
              tileFrom.deselected();
              return true;
            } 
            else {
              if(tileFrom.piece.value == 6) {
                tileTo.selected();
                tileFrom.piece.value = aggregate - 6;   
                tileTo.piece.value = 6;
                tileFrom.deselected();
                return true;
              } 
              else if (tileTo.piece.value == 6) {
//                tileTo.selected();
//                tileFrom.deselected();
//                update();
                return false;
              } 
              else {                
                // eg 4 + 4 too gets 6 and from gets 2
                tileTo.selected();
                tileFrom.piece.value = aggregate - 6;   
                tileTo.piece.value = 6;
                tileFrom.deselected();
                return true;
              }
            }            
          } 
          else {
            //add from into too
            tileTo.selected(); 
            tileFrom.piece.value = aggregate;   
            tileTo.setPiece(tileFrom.piece);
            tileFrom.removePiece();
            tileFrom.deselected();
            return true;
          }
        }
      } 
      else {
        //        println("tile to not player owned");

        if(tileTo.piece.building){
          //do subtraction onto to, and check if base is <=6 then set to unit
          if (tileFrom.piece.value%2 != 0) {//if gatherer
            return false; 
          } 
          println("player" + (tileFrom.piece.playerId+1) + " unit " + tileFrom.piece.value + " attacking " 
            + "player" + (tileTo.piece.playerId+1) + " base " + tileTo.piece.value);

          tileTo.piece.value -= tileFrom.piece.value;
          if(tileTo.piece.value <= 6) {
            tileTo.piece.building = false;        
          }
          tileFrom.removePiece();
          tileFrom.deselected();
          selectedATile = false;        
          return true;
        } 
        else {
          //unit attacking unit
          if (tileFrom.piece.value%2 != 0) {//if gatherer
            return false; 
          } 
          else {
            //attacking unit is an attacker
            println("player" + (tileFrom.piece.playerId+1) + " unit " + tileFrom.piece.value + " attacking " 
              + "player" + (tileTo.piece.playerId+1) + " unit " + tileTo.piece.value);

            int difference = tileFrom.piece.value - tileTo.piece.value; //eg 6 -> 2 leaves 0 4

            //logic for taking other pieces
            if(difference > 0) {
              //attacker was stronger
              println("attacker was stronger");
              tileFrom.piece.value = difference;
              tileTo.selected();    
              tileTo.setPiece(tileFrom.piece);
              tileFrom.removePiece();
              tileFrom.deselected();
              return true;
            } 
            else if (difference < 0) {
              //defender stronger
              println("defender stronger");
              tileTo.piece.value = - difference;              
              tileFrom.deselected();
              tileFrom.removePiece();
              selectedATile = false;
              return true; 
            } 
            else {
              //must be 0, and both get removed.
              println("evenly matched, both removed");
              tileFrom.removePiece();
              tileFrom.deselected();    
              tileTo.removePiece();    
              tileTo.deselected();
              selectedATile = false;
              tileFrom.deselected();  
              return true;  
            }
          }          
        }
      }
    }
  }
}









