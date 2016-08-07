
class Player {
  
  int number;
  
  ArrayList<BallImage> pottedBalls;
  
  Vec2 location;
  Vec2 size;
  
  float margin = 10;
  
  boolean myTurn; // Is it my turn to play, sir?
  
  // Free place (can the player free place? where?)
  private boolean _freePlace; // TODO it's private but I can still access it, what?
  Area freePlaceArea;
  
  float nameHeight = 20;
  float descHeight = 12;
  
  // What balls are this player potting? Solids or strips?
  // None = undecided yet
  boolean solids;
  boolean strips;
  
  Player(int _number, Vec2 relativeSize) {
    
    number = _number;
    assert(number == 1 || number == 2);
    
    size = new Vec2(relativeSize.x * width, relativeSize.y * height);
    if (number == 1) {
      location = new Vec2(margin, margin);
    } else {
      location = new Vec2(width - margin - size.x, margin);
    }
    
    pottedBalls = new ArrayList<BallImage>();
  }
  
  // Which balls should this player pot?
  // If the player hasn't yet decided, this returns true
  boolean undecided() {
    // If both are false, this will return true
    // If either is true, this will return false
    return !(solids || strips);
  }
  
  // Marks "free place" as true in the given area
  void setFreePlaceArea(Area area) {
    _freePlace = true;
    freePlaceArea = area;
  }
  
  void display() {
    
    stroke(0);
    strokeWeight(1);
    fill(250, 240, 160, myTurn ? 255 : 100);
    rect(location.x, location.y, size.x, size.y);
    
    fill(0);
    textAlign(LEFT, TOP);
    textSize(nameHeight);
    text("Player " + number, location.x + margin, location.y + margin);
    
    
    textAlign(RIGHT, TOP);
    textSize(descHeight);
    if (solids) {
      text("You are solids", location.x + size.x - margin, location.y + margin);
    } else if (strips) {
      text("You are strips", location.x + size.x - margin, location.y + margin);
    }
    
    textAlign(LEFT, TOP);
    for (int i = 0; i < pottedBalls.size(); i++) {
      BallImage ball = pottedBalls.get(i);
      float ballX = location.x + margin + ball.diameter * (i + 1);
      float ballY = location.y + margin + ball.diameter + nameHeight;
      ball.display(ballX, ballY);
    }
  }
}