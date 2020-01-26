

class Player {

  int playerId;
  int playerMoves = 0;
  int roled = 0; 
  int power = 0;
  color playerColor; 

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

