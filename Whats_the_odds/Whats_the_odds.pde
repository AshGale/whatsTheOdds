//overide variables
int tileSize = 50;// min 30 when tile ammount is 10
int tileAmmount = 10; // keep even, otherwise checkerboard will be lines
int boardSize = tileSize * tileAmmount;
int messageBoxHeight = 50;

//message box and ui padding variables
int padding = 10;

//player variables
boolean running = true;
int playerTurn = 1;
int playerMoves = 1;
int roled = 0;
int selectedX = 0;
int selectedY = 0;

//board variables
Tile[][] grid;

void setup() {
  frameRate(30);
  size(boardSize, boardSize + messageBoxHeight);
  smooth();

  //init variables
  initGrid();
  initPlayers(1);

  println("setup");        
}

void draw() {
  if (running) {
    background(255);

    //dray messages output
    updateTextOut();//when theer is a update

    // draw checkboard
    updateBoard();
    //running = !running; //stop program running
  }
}

//UPDATE METHODS

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
  fill(212,212,212);//light gey
  rect(0, boardSize, boardSize, messageBoxHeight);
  textAlign(TOP, LEFT);
  printText("Player turn: " + playerTurn, true, true);
  printText("roled: " + roled, true, false);
  printText("Game running: " + running, false, true);
  printText("Moves left: " + playerMoves, false, false);

}

//INIT METHODS

void initPlayers(int players) {

  for (int i = 1; i <= players; i++ ) {

    //determine starting position not on edge tiles (1, tileAmmount-2)
    int px = (int)random(1, tileAmmount-2);
    int py = (int)random(1, tileAmmount-2);

    //need to check surounding tiles, ie selected and one around is not taken

    Item item = new Item(i, px, py, 12, true);//create new player base

      grid[px][py].setItem(item);
    println("player " + i + " starting position: " + px + " " + py);
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
        tile.setBackground(0,0,0);
      } 
      else {
        tile.setBackground(255,255,255);
      }
      //      println("new tile " + i + "x" + k + " black? " + black);
      grid[i][k] = tile;
      black = !black;
    }
    black = !black;//correct for last colour being the colour needed
  }
}

//HELPER METHODS

int roleDice() {
  return (int)random(1,6);
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
      println("up");
    } 
    else if (keyCode == DOWN) {
      println("down");
    } 
    else if (keyCode == LEFT) {
      println("left");
    } 
    else if (keyCode == RIGHT) {
      println("right");
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
    grid[selectedX][selectedY].deselected();
    selectedX = mouseX/tileSize;
    selectedY = mouseY/tileSize;
    grid[selectedX][selectedY].selected();
  } 
  else {
    // println("off board");
  }
}






