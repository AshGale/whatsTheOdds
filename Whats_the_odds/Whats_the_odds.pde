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
color playerOneColor = color(0, 0, 255);
color playerTwoColor = color(255, 128, 0);
color playerThreeColor = color(0, 255, 0);
color playerFourColor = color(255, 0, 255);

//message box and ui padding variables
int padding = 10;

//helper variables
boolean update = true;
int numberOfPlayers = 2;
int playerTurn = numberOfPlayers-1;
int selectedX = 0;
int selectedY = 0;
boolean selectedATile = false;

//board variables
Tile[][] grid;
Player[] players;

void setup() {
  frameRate(30);
  size(boardSize, boardSize + messageBoxHeight);
  smooth();

  //init variables
  initGrid();
  initPlayers();

  println("setup compleate");        
}

void draw() {
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

void isTurnOwver() {
  if(players[playerTurn].playerMoves <= 0) {
    //next players turn
    selectedATile = false;
    grid[selectedX][selectedY].deselected();

    playerTurn++;
    if(playerTurn == numberOfPlayers) {
      playerTurn = 0;
    }
    players[playerTurn].roled = roleDice();
    int income = getPlayerPlayerIncome();
    players[playerTurn].playerMoves = players[playerTurn].roled + income;

  }
}

void updateBoard() {
  for (int i = 0; i < tileAmmount; i++ ) {
    for (int k = 0; k < tileAmmount; k++ ) {
      grid[i][k].render();
    }
  }
}

void updateTextOut(){
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

void initPlayers() {

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

void initGrid() {
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

void update() {
  update = true;
}

int roleDice() {
  return (int)random(1,6);
}

int getPlayerPlayerIncome() {
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

void printText(String message, boolean top, boolean left) {
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

void keyPressed()
{
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

void mouseClicked() {
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




















