

class Tile {
  //this class contains the information about what is in it's tile on the grid
  int positionX, positionY;
  boolean empty = true;
  boolean selected = false;
  int r,g,b;

  Item item;

  Tile (int x, int y) {
    this.positionX = x;
    this.positionY = y;
  }

  void setItem(Item item) {
    this.empty = false;
    this.item = item;
  }

  void removeItem() {
    this.empty = true;
    this.item = null;
  }

  Item getItem(){
    return this.item;
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
      // draw the item too
      fill(0,255,0);
      int centerX = positionX*tileSize+tileSize/2;
      int centerY = positionY*tileSize+tileSize/2;
      ellipse(centerX, centerY, tileSize, tileSize);
      textFont(createFont("Arial",tileSize,true),tileSize/2);
      fill(0); // black text
      textAlign(CENTER, CENTER);
      text(item.getValue(), centerX, centerY);
      textAlign(TOP, LEFT);
    }
  }
}




