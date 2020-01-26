import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Whats_the_odds extends PApplet {

//start game
//player one roles
//player gets that ammount of moves
//player can make units outside the tower by selecting a tower and using arrow keys 
//player can select a unit, and move it with the arrow keys 
//max pieces value is 6 
//towers obtained by adding 2 value 6's together

//odd pieces give a piece.value chance in 6 to get a extra move (ie 3 in 6, role 3 or lower)
//even pieces can attack other players pieces, odd can't attack
//pieceses can be moved, to be added together.
//player turn ends when they have no moves

//overide variables
int tileSize = 50;// min 30 when tile ammount is 10
int tileAmmount = 10; // keep even, otherwise checkerboard will be lines
int boardSize = tileSize * tileAmmount;
int messageBoxHeight = 50;
int playerOneColor = color(0, 0, 255);
int playerTwoColor = color(255, 128, 0);
int playerThreeColor = color(0, 255, 0);
int playerFourColor = color(255, 0, 255);

//message box and ui padding variables
int padding = 10;

//helper variables
boolean update = true;
int numberOfPlayers = 4;
int playerTurn = numberOfPlayers-1;
int selectedX = 0;
int selectedY = 0;
boolean selectedATile = false;

//board variables
Tile[][] grid;
Player[] players;

public void setup() {
  frameRate(30);
  size(boardSize, boardSize + messageBoxHeight);
  smooth();

  //init variables
  initGrid();
  initPlayers();

  println("setup compleate");        
}

public void draw() {
  if (update) {
    background(255);

    isTurnOwver();

    //dray messages output
    updateTextOut();//when theer is a update

    // draw checkboard
    updateBoard();

    //no need to constantly run, so set update on inputs
    update = false; //stop program update
  }
}

//UPDATE METHODS

public void isTurnOwver() {
  if(players[playerTurn].playerMoves <= 0) {
    //next players turn tidy up
    selectedATile = false;
    grid[selectedX][selectedY].deselected();

    //select next player
    playerTurn++;    
    if(playerTurn == numberOfPlayers) {
      playerTurn = 0;
    }

    println("player " + playerTurn + " alive? " + players[playerTurn].alive);

    //if current palyer no alive, return
    if(!players[playerTurn].alive) {
      println("player " + playerTurn + " not alive");
      update();
      isTurnOwver();
    } 
    else {
      //calculate moves
      players[playerTurn].roled = roleDice();
      int income = getPlayerPlayerIncome();
      players[playerTurn].playerMoves = players[playerTurn].roled + income;
    }

  }
}

public void updateBoard() {
  for (int i = 0; i < tileAmmount; i++ ) {
    for (int k = 0; k < tileAmmount; k++ ) {
      grid[i][k].render();
    }
  }
}

public void updateTextOut(){
  //String tl, String tr, String bl, String br

  //clear last text
  fill(players[playerTurn].playerColor);//light gey
  rect(0, boardSize, boardSize, messageBoxHeight);
  textAlign(TOP, LEFT);
  printText("Player turn: " + (playerTurn+1), true, true);
  printText("Moves left: " +  players[playerTurn].playerMoves, true, false);
  printText("Number of Players: " + numberOfPlayers, false, true);
  printText("roled: " + players[playerTurn].roled, false, false);

}

//INIT METHODS

public void initPlayers() {

  //note the index starting at 0
  players = new Player[numberOfPlayers];

  for (int i = 0; i < numberOfPlayers; i++ ) {

    Player player = new Player(i);
    players[i] = player;

    //determine starting position not on edge tiles (1, tileAmmount-2)
    int px = (int)random(1, tileAmmount-1);
    int py = (int)random(1, tileAmmount-1);

    //need to check surounding tiles, ie selected and one around is not taken

    Piece piece = new Piece(i, px, py, 12, true);//create new player base

      grid[px][py].setPiece(piece);
    println("player " + (i+1) + " starting position: " + px + " " + py);
  }

}

public void initGrid() {
  grid = new Tile[tileAmmount][tileAmmount];

  // var to keep track of the checkerboard pattern
  boolean black = false;

  //loop through the grid an set a new tile
  for (int i = 0; i < tileAmmount; i++ ) {
    for (int k = 0; k < tileAmmount; k++ ) {

      Tile tile = new Tile(i,k); 
      if(black == true) {
        tile.backgroundColor = color(0,0,0);
      } 
      else {
        tile.backgroundColor = color(255,255,255);
      }
      //      println("new tile " + i + "x" + k + " black? " + black);
      grid[i][k] = tile;
      black = !black;
    }
    black = !black;//correct for last colour being the colour needed
  }
}

//HELPER METHODS

public void update() {
  update = true;
}

public int roleDice() {
  return (int)random(1,6);
}

public int getPlayerPlayerIncome() {
  //loops through the grid and gets all the pieces that have a odd number for that player
  Piece piece;
  int income = 0;
  //if a odd piece for the player is found, role the dice, and if value is value or lass, +1 income
  for (int i = 0; i < tileAmmount; i++ ) {
    for (int k = 0; k < tileAmmount; k++ ) {
      if(grid[i][k].empty){

      } 
      else {
        piece = grid[i][k].piece;
        if (piece.playerId == playerTurn) {
          if(piece.building){
            income++;
          } 
          else {
            if(piece.value%2 == 1) {//if odd number
              if(roleDice() <= piece.value) {
                income++;
              } 
              else {
                //println("player" + (playerTurn+1) + " lost out on income!");
              }
            }
          }
        }
      }
    }
  }
  return income;
}

public void printText(String message, boolean top, boolean left) {
  textFont(createFont("Arial",12,true),12);
  fill(0); // black text

  // 4 positions for text, determine where to show text
  if (top) {
    if (left) {
      //top left
      text(message, padding, boardSize + padding*2);
    } 
    else {
      //top right
      text(message, boardSize/2 - padding, boardSize + padding*2);
    }
  } 
  else {
    if (left) {
      //bottom left
      text(message, padding, boardSize + messageBoxHeight - padding);
    } 
    else {
      //bottom right
      text(message, boardSize/2 - padding, boardSize + messageBoxHeight - padding);
    }
  }
}

//INPUT METHODS

public void keyPressed()
{
  //make sure not extra input while updating
  if (update == false) { 
    // if the key is between 'A'(65) and 'z'(122)
    if( key >= 'A' && key <= 'z') {

    } 
    else {
      //println("pressed: '" + key + "'");
    }

    if (key == CODED) {
      if (keyCode == UP) {
        //      println("up");
        if (selectedATile) {
          inputDirectionAction(0, -1); //
        }
      } 
      else if (keyCode == DOWN) {
        //      println("down");
        if (selectedATile) {
          inputDirectionAction(0, 1); //
        }
      } 
      else if (keyCode == LEFT) {
        //      println("left");
        if (selectedATile) {
          inputDirectionAction(-1, 0); //
        }
      } 
      else if (keyCode == RIGHT) {
        //      println("right");
        if (selectedATile) {
          inputDirectionAction(1, 0); //
        }
      } 
      else {
        //println("keyCode pressed: " + keyCode);
      }
    }
  }
}

public void mouseClicked() {
  //  println(mouseX + "," + mouseY);
  if(mouseX < boardSize && mouseY < boardSize) {
    //    println("clicked on board");
    //    println("selected tile: " + mouseX/tileSize + " " + mouseY/tileSize); 
    int x = mouseX/tileSize;
    int y = mouseY/tileSize;

    //own piece ? ie piece player id == current player id
    if(grid[x][y].piece != null && grid[x][y].piece.playerId == playerTurn) {
      grid[selectedX][selectedY].deselected();
      selectedX = x;
      selectedY = y;
      grid[x][y].selected();

      selectedATile = true;
      update(); // show selected tile
    } 
    else {
      //nothing
      //      selectedATile = false;
      //      grid[selectedX][selectedY].deselected();
      //      update(); // show selected tile
    }
  } 
  else {
    // println("off board");
  }
}
























class Piece {
  int positionX, positionY;
  int playerId;
  int value = 0;
  boolean building = false;
  //  boolean unit = false;
  //  boolean attacker = false;

  Piece (int playerId, int x, int y, int value, boolean building ) {
    //    println(player + " " + x + " " + y + " " + value + " " + building);
    this.playerId = playerId;
    this.positionX = x;
    this.positionY = y;
    this.value = value;
    this.building = building;
  }
}







class Player {
  boolean alive = true;
  int playerId;
  int playerMoves = 0;
  int roled = 0; 
  int power = 0;
  int playerColor; 

  Player (int playerId) {
    this.playerId = playerId;
    if(playerId == 0) {
      this.playerColor = playerOneColor;
    } 
    else if (playerId == 1) {
      this.playerColor = playerTwoColor;
    } 
    else if (playerId == 2) {
      this.playerColor = playerThreeColor;
    } 
    else if (playerId == 3) {
      this.playerColor = playerFourColor;
    }
    //    println(playerId  + " " + playerColor);
  }
}



class Tile {
  //this class contains the information about what is in it's tile on the grid
  int positionX, positionY;
  boolean empty = true;
  boolean selected = false;
  int backgroundColor;
  Piece piece = null;

  Tile (int x, int y) {
    this.positionX = x;
    this.positionY = y;
  }

  public void setPiece(Piece piece) {
    this.empty = false;
    this.piece = piece;
    //    println("setting piece: " + this.empty + " " + positionX + " " + positionY + " " + piece);
  }

  public void removePiece() {
    checkifLastPlayerPiece();
    // println("removing piece: " + this.empty + " " + positionX + " " + positionY);
  }

  public void deselected () {
    this.selected = false; 
  }

  public void selected () {
    this.selected = true; 
  }

  public void checkifLastPlayerPiece() {
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

  public void render() {
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








public void inputDirectionAction (int ofsetX, int ofsetY) {
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

public boolean createPiece(int x, int y) {
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

public boolean movePiece(int a, int b, int x, int y) {
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
                tileTo.selected();
                tileFrom.deselected();
                update();
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










  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Whats_the_odds" });
  }
}
