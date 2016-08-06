
class Player {
  
  int number;
  
  ArrayList<Ball> pottedBalls;
  
  Vec2 location;
  Vec2 size;
  
  float margin = 10;
  
  boolean myTurn; // Is it my turn to play, sir?
  
  float nameHeight = 20;
  float descHeight = 12;
  
  Player(int _number, Vec2 relativeSize) {
    
    number = _number;
    assert(number == 1 || number == 2);
    
    size = new Vec2(relativeSize.x * width, relativeSize.y * height);
    if (number == 1) {
      location = new Vec2(margin, margin);
    } else {
      location = new Vec2(width - margin - size.x, margin);
    }
    
    myTurn = number == 1;
  }
  
  void display() {
    
    stroke(0);
    strokeWeight(1);
    fill(255, myTurn ? 255 : 100);
    rect(location.x, location.y, size.x, size.y);
    
    textSize(nameHeight);
    textAlign(LEFT, TOP);
    fill(0);
    text("Player " + number, location.x + margin, location.y + margin);
  }
}