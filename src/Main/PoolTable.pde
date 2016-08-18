
class PoolTable {
  
  // --------------------------------------------- Fields begin
  // Location and size
  Area area;
  
  PImage tableGraphics;

  // Lists we'll use to track objects
  ArrayList<TableBoundary> boundaries; // Track table
  ArrayList<Hole> holes;
  ArrayList<Ball> balls;
  
  // Determines whether the balls have been moving or not
  boolean playing; // i.e. is the current player playing?
  
  // Keep track of the previous value to be able to
  // perform a one-time check
  boolean wasPlaying;
  
  // --------------------------------------------- Fields end
  // --------------------------------------------- Constructor begin
  
  // Initializes the pool table with a relative percentage width
  // The width should be in the range (0..1)
  PoolTable(float relativeWidth) {
    
    // Set table size and location
    setArea(relativeWidth);
    
    // Create the graphics
    tableGraphics = loadImage("img/table.png");
    tableGraphics.resize(int(area.w), int(area.h)); // Resize once to avoid scaling on display()
  
    // Create ArrayLists
    boundaries = new ArrayList<TableBoundary>();
    holes = new ArrayList<Hole>();
    balls = new ArrayList<Ball>();
  
    // Determine some values
    float holeRadius = getHoleRadius();
    float tableBevel = holeRadius; // Use holeRadius as tableBevel for dimensions to fit
    
    float triangleY = height / 2;
    float triangleX = area.x + area.w * 0.70; // The triangle will be at the 70% X of the table
    
    // Place table boundaries
    placeTableBoundaries(tableBevel);
    
    // Place holes
    placeHoles(holeRadius, tableBevel);
    
    // Place the balls triangle
    placeBallsTriangle(getBallRadius(), triangleX, triangleY);
  }
  
  void setArea(float relativeWidth) {
    area = new Area();
    // From Wikipedia we know that the height is half the width
    // "The table's playing surface is approximately 9 by 4.5 feet (2.7 by 1.4 m)"
    area.w = relativeWidth * width;
    area.h = area.w / 2f;
    
    // Divide remaining space by 2 to leave margin both up and down
    area.x = (width - area.w) / 2f; // Left margin
    area.y = (height - area.h) / 2f; // Top margin
  }
  
  // The bevel acts as boundary thickness, hence it becomes is a 45º bevel
  void placeTableBoundaries(float bevel) {
    
    // All the table boundaries are displaced a distance = bevel from the corners
    // ----------------------------------------------------------------------------- Top
    Vec2 boundaryLoc = new Vec2(area.x, area.y - bevel);
    // The horizontal size is (table width - bevel) / 2
    Vec2 horizontalSize = new Vec2((area.w - bevel) / 2f, bevel);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP,  1)); // Trim right side
    
    // Move to the next table boundary by adding its size + the bevel
    boundaryLoc.addLocal(horizontalSize.x + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP, -1)); // Trim left  side
    
    // ----------------------------------------------------------------------------- Bottom
    boundaryLoc.set(area.x, area.y + area.h);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM,  1)); // Trim right side
    // Move to the next table boundary by adding its size + 2 times the bevel
    boundaryLoc.addLocal(horizontalSize.x + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM, -1)); // Trim left  side
    
    // ----------------------------------------------------------------------------- Left
    boundaryLoc.set(area.x - bevel, area.y);
    // The vertical size is the same as the table height, since there's only one
    Vec2 verticalSize = new Vec2(bevel, area.h);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, LEFT));
    
    // ----------------------------------------------------------------------------- Right
    boundaryLoc.addLocal(area.w + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, RIGHT));
  }
  
  void placeHoles(float holeRadius, float tableBevel) {
    
    // Half the bevel to displace the center holes a bit outside the table
    float halfBevel = tableBevel / 2f;
    
    // Add the three upper holes, with the middle one displaced
    holes.add(new Hole(new Vec2(area.x             , area.y)            , holeRadius)); // (0.0, 0.0)
    holes.add(new Hole(new Vec2(area.x + area.w / 2, area.y - halfBevel), holeRadius)); // (0.5, 0.0)
    holes.add(new Hole(new Vec2(area.x + area.w    , area.y)            , holeRadius)); // (1.0, 0.0)
    
    // Add the three down holes, with the middle one displaced
    holes.add(new Hole(new Vec2(area.x             , area.y + area.h)            , holeRadius)); // (0.0, 1.0)
    holes.add(new Hole(new Vec2(area.x + area.w / 2, area.y + area.h + halfBevel), holeRadius)); // (0.5, 1.0)
    holes.add(new Hole(new Vec2(area.x + area.w    , area.y + area.h)            , holeRadius)); // (1.0, 1.0)
  }
  
  void placeBallsTriangle(float ballRadius, float x, float y) {
    // Vec2 doesn't have rotate, hence it cannot be used here
    
    // Stores the available numbers, we'll pick a random one every time
    ArrayList<Integer> numbers = new ArrayList<Integer>(15);
    for (int i = 1; i <= 15; i++) {
      numbers.add(i);
    }
    
    // Generate vectors used for moving when placing the balls
    float theta = 1f / 6f * PI; // 30º
    
    // Get the normal vector that is rotated 30º up (-theta = counterwise)
    Vec2 rightUp = new Vec2(cos(-theta), sin(-theta));
    rightUp.mulLocal(ballRadius * 2); // * 2 so the balls are touching each other
    
    // Get the normal vector that is rotated 30º down (theta = clockwise)
    Vec2 rightDown = new Vec2(cos(theta), sin(theta));
    rightDown.mulLocal(ballRadius * 2);
    
    // Both form a 60º angle, 30º going up and 30º going down
    // For each ball in a diagonal, we can fill another [4..1] in the other direction
    //         5
    //       4
    //     3   Z
    //   2   y
    // 1   A   z
    //   a   B
    //     b   C
    //       c
    //         d
    Vec2 loc = new Vec2(x, y); // Initial point
    for (int i = 0; i < 5; i++) { // Going up
      for (int j = 0; j < 5 - i; j++) { // Going down
        
        // Displacement for this IJ
        Vec2 ijLoc = rightUp.mul(i).add(rightDown.mul(j));
        
        // Add it to the initial point to get the final ball location
        Vec2 ballLoc = loc.add(ijLoc);
        
        int numberIndex = int(random(numbers.size()));
        int poppedNumber = numbers.remove(numberIndex);
        balls.add(new Ball(ballLoc.x, ballLoc.y, ballRadius, poppedNumber));
      }
    }
    
    loc = new Vec2(width / 2, height / 2);
    for (int i = 0; i < 3; i++) {
      loc.add(rightDown);
    }
  }
  
  // Sets the real radius that the balls will use
  float getBallRadius() {
    // From wikipedia: "The holes are spaced slightly closer than the regulation ball width of 2 1/2 inch (57.15 mm)"
    // Hence, relativeWidth      x           57.15 * relativeWidth
    //        ------------- = ------- -> x = --------------------- = relativeWidth * 0.021166667
    //           2700mm       57.15mm               2700mm
    return area.w * 0.021166667;
  }
  
  // Returns the real radius for the ball holes to be displayed based on the balls radius
  float getHoleRadius() { return getBallRadius() * 2f; }
  
  // --------------------------------------------- Constructor end
  // --------------------------------------------- Update begin
  void update() {
    
    // Check if any hole contains any ball
    for (Hole hole : holes) {
      for (int i = balls.size() - 1; i >= 0; i--) {
        Ball ball = balls.get(i);
        
        // If the hole contains the ball, remove it from both box2d world
        if (hole.containsBall(ball)) {
          if (ball.kill()) { // If we killed the ball, pot it!
            game.playerManager.potBall(ball.number);
          }
        }
      }
    }
    
    // Update all the balls
    for (int i = balls.size() - 1; i >= 0; i--) {
      Ball ball = balls.get(i);
      ball.update();
      
      // If a ball is now dead, remove it from our list
      if (ball.isDead()) {
        balls.remove(i);
      }
    }
    
    playing = !areBallsStill();
    
    // Toggle the player turns if necessary
    if (shouldChangeTurn()) {
      game.playerManager.toggleTurns();
    }
  }
  
  Ball getCueBall() {
    if (balls.size() == 0) {
      return null; // Empty, the cue ball is not here
    }
    
    // The cue ball is always the last added
    Ball ball = balls.get(balls.size() - 1);
    if (ball.number != 0) {
      return null; // The cue ball is not here
    }
    
    return ball;
  }
  // --------------------------------------------- Update end
  // --------------------------------------------- Display begin
  void display() {
    
    imageMode(CORNER);
    image(tableGraphics, area.x, area.y);
  
    // Display all the holes
    for (Hole hole : holes) {
      hole.display();
    }
  
    // Display all the boundaries
    for (TableBoundary boundary : boundaries) {
      boundary.display();
    }
  
    // Display all the balls
    for (Ball b : balls) {
      b.display();
    }
  }
  // --------------------------------------------- Display end
  
  boolean areBallsStill() {
    for (Ball b : balls) {
      if (!b.isStill()) {
        return false;
      }
    }
    return true;
  }
  
  // Determines whether the cue ball is alive or not
  boolean cueBallAlive() {
    if (balls.size() == 0) {
      return false;
    }
    // The last ball should always be the cue ball
    Ball cueBall = balls.get(balls.size() - 1);
    if (cueBall.number == 0 &&  // If it actually is
        cueBall.isStill()) { // And it's stopped (i.e., also not dying)
        return true;
    }
    return false;
  }
  
  // Should the turn be changed to the next player?
  // If yes, the state is cleared after checked!
  boolean shouldChangeTurn() {
    if (wasPlaying && !playing) {
      wasPlaying = false; // Clear state
      return true;
    } else {
      wasPlaying = playing;
      return false;
    }
  }
  
  // Returns the first quarter of the area of the table
  // Also trims the borders by the ball radius
  Area getFirstQuarter() {
    float radius = getBallRadius();
    return new Area(area.x + radius,
                    area.y + radius,
                    area.w / 4f - radius * 2,
                    area.h - radius * 2);
  }
  
  // Returns the area of the table
  // Also trims the borders by the ball radius
  Area getArea() {
    float radius = getBallRadius();
    return new Area(area.x + radius,
                    area.y + radius,
                    area.w - radius * 2,
                    area.h - radius * 2);
  }
  
  // Determines whether a ball can be placed or not in the given location
  boolean canPlaceBall(float x, float y) {
    
    float diameter = getBallRadius() * 2;
    for (Ball ball : balls) {
      
      Vec2 loc = ball.getLocation();
      float distance = dist(x, y, loc.x, loc.y);
      
      if (distance < diameter) {
        return false; // One ball would be inside the other, return false
      }
    }
    
    return true;
  }
  
  // Places the cue ball in the given location
  void placeCueBall(float x, float y) {
    
    Ball cueBall = new Ball(x, y, getBallRadius(), 0); 
    balls.add(cueBall);
  }
}