
class Player {
  
  int number;
  
  ArrayList<BallImage> pottedBalls;
  
  Area area;
  
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
  
  // Did we lose or win?
  boolean won;
  boolean lost;
  
  Cue cue;
  BallImage cueBallDisplay; // Used when we can freely place
  
  Player(int _number, Vec2 relativeSize) {
    
    number = _number;
    assert(number == 1 || number == 2);
    
    area = new Area();
    area.resize(relativeSize.x * width, relativeSize.y * height);
    if (number == 1) {
      area.locate(margin, margin);
    } else {
      area.locate(width - margin - area.w, margin);
    }
    
    pottedBalls = new ArrayList<BallImage>();
    
    cue = new Cue();
    
    // Add listener to fire local methods
    addEventListener(new EventListener() {
      @Override
      public void mousePressed() { mousePress(); }
      @Override
      public void mouseReleased() { mouseRelease(); }
      @Override
      public void mouseClicked() { mouseClick(); }
    });
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
    cueBallDisplay = new BallImage(12, 0); // Arbitrary radius
  }
  
  void clearFreePlaceArea() {
    _freePlace = false;
    freePlaceArea = null;
    cueBallDisplay = null;
  }
  
  void display() {
    
    // Display player info 
    stroke(0);
    strokeWeight(1);
    fill(250, 240, 160, myTurn ? 255 : 100);
    area.display();
    
    fill(0);
    cursor.locate(area.x + margin, area.y + margin);
    cursor.type("Player " + number, nameHeight);
    cursor.move(20, 0);
    cursor.setTextSize(descHeight); // The next text will be description
    
    if (won) {
      cursor.typeLine("- You WON!!");
    } else if (lost) {
      cursor.typeLine("- You lost man :(");
    }
    
    if (solids) {
      cursor.typeLine("- You are solids");
    } else if (strips) {
      cursor.typeLine("- You are strips");
    }
    
    textAlign(LEFT, TOP);
    for (int i = 0; i < pottedBalls.size(); i++) {
      BallImage ball = pottedBalls.get(i);
      float ballX = area.x + margin + ball.diameter * (i + 1);
      float ballY = area.y + margin + ball.diameter + nameHeight;
      ball.display(ballX, ballY);
    }
    
    // If the cue ball isn't null (i.e. we're not placing), display cue
    if (game.table.cueBallAlive() && myTurn && game.table.areBallsStill()) {
      cue.display();
    }
    
    // If we're free placing, display the new ball place
    if (_freePlace) {
      cursor.typeLine("- You have the cue ball in hand");
      
      noStroke();
      fill(255, 255, 255, 40);
      freePlaceArea.display();
      
      if (freePlaceArea.contains(mouseX, mouseY)) {
        cueBallDisplay.display(mouseX, mouseY);
      }
    }
  }
  
  // --------------------------------------------- Events begin
  
  void mouseClick() {
    if (!myTurn) return;
    
    // Check whether we can or not place the cue ball
    if (_freePlace && freePlaceArea.contains(mouseX, mouseY)) {
      if (game.table.canPlaceBall(mouseX, mouseY)) {
        game.table.placeCueBall(mouseX, mouseY);
        clearFreePlaceArea();
      }
    }
  }
  
  void mousePress() {
    if (!myTurn) return;
    
    if (game.table.cueBallAlive() && mouseButton == LEFT && game.table.areBallsStill()) {
      cue.beginHit();
    }
  }
  
  void mouseRelease() {
    if (!myTurn) return;
    
    if (game.table.cueBallAlive() && mouseButton == LEFT && game.table.areBallsStill()) {
      cue.endHit();
    }
  }
  // --------------------------------------------- Events end
  
}