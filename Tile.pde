

class Tile {
  //this class contains the information about what is in it's tile on the grid
  int positionX, positionY;
  boolean empty = true;
  int r,g,b;

  Item item;

  Tile (int x, int y) {
    this.positionX = x;
    this.positionY = y;
  }

  void setItem(Item item) {
    this.item = item;
  }

  Item getItem(){
    return this.item;
  }

  void setBackground(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void render() {
    //box for background based on rgb
    fill(r,g,b);
    rect(positionX*tileSize, positionY*tileSize, tileSize, tileSize);
//    println("render tile at: " + positionX*tileSize + "x" + positionY*tileSize + " " + r);
    
    if(empty) {} else {
  // draw the item too
    }
  }
}


