
class PlayerManager {
  
  Player player1, player2;
  
  int winner;
  
  PlayerManager(float relativeWidth, float relativeHeight) {
    
    player1 = new Player(1, new Vec2(relativeWidth, relativeHeight));
    player2 = new Player(2, new Vec2(relativeWidth, relativeHeight));
    
    float whoFirst = random(1); // Who goes first? 50% each
    if (whoFirst < 0.5) {
      player1.myTurn = true;
    } else {
      player2.myTurn = true;
    }
  }
  
  // Toggles the players turns
  void toggleTurns() {
    player1.myTurn = !player1.myTurn;
    player2.myTurn = !player2.myTurn;
  }
  
  void potBall(int ballNumber) {
    if (winner > 0) { // We already won, do nothing
      return;
    }
    
    // Get the current and other player for easy-access
    Player currentPlayer = player1.myTurn ? player1 : player2;
    Player otherPlayer   = player1.myTurn ? player2 : player1;
    
    // Check if the potted ball was the cue ball
    if (ballNumber == 0) {
      // Those are bad news, the other player can now freely place the ball
      otherPlayer._freePlace = true;
      
      // Early terminate, no need for more checks
      return;
    }
    
    // Check if the player potted the 8
    if (ballNumber == 8) {
      if (currentPlayer.pottedBalls.size() == 7) {
        // He had to pot it! He wins!
        winner = currentPlayer.number;
        
      } else { // L O S E R
        // The other player wins!
        winner = otherPlayer.number;
      
        // Early terminate, no need for more checks
        return;
      }
    }
    
    // 12 = arbitrary ball size
    BallImage ball = new BallImage(12, ballNumber);
    
    // If the player is undecided, then the ball he potted will
    // indicate whether to use solids or strips
    // We can assume that the other player is undecided too
    if (currentPlayer.undecided()) { 
      currentPlayer.pottedBalls.add(ball);
      
      // Now let the player be whatever they have to be
      currentPlayer.solids = ball.solids;
      currentPlayer.strips = ball.strips;
      
      // The other plyer has to be the opposite
      otherPlayer.solids = !ball.solids;
      otherPlayer.strips = !ball.strips;
    
    } else {
      // Otherwise, pot the ball on the one who's playing it
      if (ball.solids) {
        if (player1.solids) {
          player1.pottedBalls.add(ball);
        } else {
          player2.pottedBalls.add(ball);
        }
      } else { // strips
        if (player1.strips) {
          player2.pottedBalls.add(ball);
        } else {
          player2.pottedBalls.add(ball);
        }
      }
    }
  }
  
  void display() {
    player1.display();
    player2.display();
  }
}