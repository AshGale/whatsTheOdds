//overide variables
int tileSize = 50;// min 30 when tile ammount is 10
int tileAmmount = 10; // keep even, otherwise checkerboard will be lines
int boardSize = tileSize * tileAmmount;
int messageBoxHeight = 50;

//message box padding
int padding = 10;

boolean running = true;
int playerTurn = 1;
int playerMoves = 1;

Tile[][] grid;

void setup() {
  frameRate(30);
  size(boardSize, boardSize + messageBoxHeight);
  smooth();

  //init variables
  initGrid();
  
  println("setup");        
}

void draw() {
  if (running) {
    background(255);

    //dray messages output
    //    updateTextOut();//when theer is a update

    // draw checkboard
    for (int i = 0; i < tileAmmount; i++ ) {
      for (int k = 0; k < tileAmmount; k++ ) {
        grid[i][k].render();
      }
    }
    running = !running; //stop program running
    //draw grid
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

int roleDice() {
  return (int)random(1,6);
}

void updateTextOut(){
  //String tl, String tr, String bl, String br

  //clear last text
  fill(212,212,212);//light gey
  rect(0, boardSize, boardSize, messageBoxHeight);

  printText("Player turn: " + playerTurn, true, true);
  printText("roled: " + roleDice(), true, false);
  printText("Game running: " + running, false, true);
  printText("Moves left: " + playerMoves, false, false);

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


