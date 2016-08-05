
class PoolTable {
  
  // --------------------------------------------- Fields begin
  // Location and size
  PVector loc;
  PVector size;
  
  PImage tableGraphics;

  // Lists we'll use to track objects
  ArrayList<TableBoundary> boundaries; // Track table
  ArrayList<Hole> holes;
  ArrayList<Ball> balls;
  
  Cue cue; // Cue stick
  // --------------------------------------------- Fields end
  // --------------------------------------------- Constructor begin
  
  // Initializes the pool table with a relative percentage width
  // The width should be in the range (0..1)
  PoolTable(float relativeWidth) {
    
    // Set table size and location
    setSizeAndLocation(relativeWidth);
    
    // Create the graphics
    tableGraphics = loadImage("img/table.png");
    tableGraphics.resize(int(size.x), int(size.y)); // Resize once to avoid scaling on display()
  
    // Create ArrayLists and cue stick
    boundaries = new ArrayList<TableBoundary>();
    holes = new ArrayList<Hole>();
    balls = new ArrayList<Ball>();
    cue = new Cue();
  
    // Determine some values
    float ballRadius = getBallRadius(relativeWidth);
    float holeRadius = getHoleRadius(ballRadius);
    float tableBevel = holeRadius; // Use holeRadius as tableBevel for dimensions to fit
    
    float triangleY = height / 2;
    float triangleX = loc.x + size.x * 0.70; // The triangle will be at the 70% X of the table
    float cueX      = loc.x + size.x * 0.15; // The cue ball will be at the 15% X of the table
    
    // Place table boundaries
    placeTableBoundaries(tableBevel, holeRadius);
    
    // Place holes
    placeHoles(holeRadius, tableBevel);
    
    // Place the cue ball and the balls triangle
    balls.add(new Ball(cueX, triangleY, ballRadius, 0)); // 0 = cue ball
    placeBallsTriangle(ballRadius, triangleX, triangleY);
  }
  
  void setSizeAndLocation(float relativeWidth) {
    // From Wikipedia we know that the height is half the width
    // "The table's playing surface is approximately 9 by 4.5 feet (2.7 by 1.4 m)"
    float endWidth = relativeWidth * width;
    size = new PVector(endWidth, endWidth * 1 / 2f);
    
    float leftMargin = (width - size.x) / 2f;
    float upMargin = (height - size.y) / 2f;
    loc = new PVector(leftMargin, upMargin);
  }
  
  // The bevel acts as boundary thickness, hence it becomes is a 45º bevel
  void placeTableBoundaries(float bevel, float holeRadius) {
    
    // All the table boundaries are displaced a distance = bevel from the corners
    // ----------------------------------------------------------------------------- Top
    PVector boundaryLoc = new PVector(loc.x, loc.y - bevel);
    // The horizontal size is (table width - bevel) / 2
    PVector horizontalSize = new PVector((size.x - bevel) / 2f, bevel);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP,  1)); // Trim right side
    
    // Move to the next table boundary by adding its size + the bevel
    boundaryLoc.add(horizontalSize.x + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP, -1)); // Trim left  side
    
    // ----------------------------------------------------------------------------- Bottom
    boundaryLoc.set(loc.x, loc.y + size.y);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM,  1)); // Trim right side
    // Move to the next table boundary by adding its size + 2 times the bevel
    boundaryLoc.add(horizontalSize.x + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM, -1)); // Trim left  side
    
    // ----------------------------------------------------------------------------- Left
    boundaryLoc.set(loc.x - bevel, loc.y);
    // The vertical size is the same as the table height, since there's only one
    PVector verticalSize = new PVector(bevel, size.y);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, LEFT));
    
    // ----------------------------------------------------------------------------- Right
    boundaryLoc.add(size.x + bevel, 0);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, RIGHT));
  }
  
  void placeHoles(float holeRadius, float tableBevel) {
    
    // Half the bevel to displace the center holes a bit outside the table
    float halfBevel = tableBevel / 2f;
    
    // Add the three upper holes, with the middle one displaced
    holes.add(new Hole(new PVector(loc.x             , loc.y)            , holeRadius)); // (0.0, 0.0)
    holes.add(new Hole(new PVector(loc.x + size.x / 2, loc.y - halfBevel), holeRadius)); // (0.5, 0.0)
    holes.add(new Hole(new PVector(loc.x + size.x    , loc.y)            , holeRadius)); // (1.0, 0.0)
    
    // Add the three down holes, with the middle one displaced
    holes.add(new Hole(new PVector(loc.x             , loc.y + size.y)            , holeRadius)); // (0.0, 1.0)
    holes.add(new Hole(new PVector(loc.x + size.x / 2, loc.y + size.y + halfBevel), holeRadius)); // (0.5, 1.0)
    holes.add(new Hole(new PVector(loc.x + size.x    , loc.y + size.y)            , holeRadius)); // (1.0, 1.0)
  }
  
  void placeBallsTriangle(float ballRadius, float x, float y) {
    
    // Stores the available numbers, we'll pick a random one every time
    ArrayList<Integer> numbers = new ArrayList<Integer>(15);
    for (int i = 1; i <= 15; i++) {
      numbers.add(i);
    }
    
    // Generate vectors used for moving when placing the balls
    PVector rightUp = new PVector(1, 0);
    rightUp.rotate(-1f / 6f * PI); // -30º (up)
    rightUp.mult(ballRadius * 2); // * 2 so the balls are touching each other
    
    PVector rightDown = new PVector(1, 0);
    rightDown.rotate(1f / 6f * PI); // 30º (down)
    rightDown.mult(ballRadius * 2);
    
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
    
    PVector loc = new PVector(x, y); // Initial point
    for (int i = 0; i < 5; i++) { // Going up
      for (int j = 0; j < 5 - i; j++) { // Going down
        
        // Displacement for this IJ, add it to the initial point to get the ball loc
        PVector ijLoc = PVector.add(PVector.mult(rightUp, i), PVector.mult(rightDown, j)); 
        PVector ballLoc = PVector.add(loc, ijLoc);
        
        int numberIndex = int(random(numbers.size()));
        int poppedNumber = numbers.remove(numberIndex);
        balls.add(new Ball(ballLoc.x, ballLoc.y, ballRadius, poppedNumber));
      }
    }
    
    loc = new PVector(width / 2, height / 2);
    for (int i = 0; i < 3; i++) {
      loc.add(rightDown);
    }
  }
  
  // Returns the real radius for the ball to be displayed
  float getBallRadius(float relativeTableWidth) {
    // From wikipedia: "The holes are spaced slightly closer than the regulation ball width of 2 1/2 inch (57.15 mm)"
    // Hence, relativeWidth      x           57.15 * relativeWidth
    //        ------------- = ------- -> x = --------------------- = relativeWidth * 0.021166667
    //           2700mm       57.15mm               2700mm
    return relativeTableWidth * width * 0.021166667;
  }
  
  // Returns the real radius for the ball holes to be displayed
  float getHoleRadius(float ballRadius) { return ballRadius * 2f; }
  
  // --------------------------------------------- Constructor end
  // --------------------------------------------- Update begin
  void update() {
    
    // Check if any hole contains any ball
    for (Hole hole : holes) {
      for (int i = balls.size() - 1; i >= 0; i--) {
        Ball ball = balls.get(i);
        
        // If the hole contains the ball, remove it from both box2d world
        if (hole.containsBall(ball)) {
          ball.kill();
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
    
    cue.update(getCueBall());
  }
  
  Ball getCueBall() {
    for (Ball ball : balls) {
      if (ball.number == 0) {
        return ball;
      }
    }
    return null;
  }
  // --------------------------------------------- Update end
  // --------------------------------------------- Display begin
  void display() {
    
    imageMode(CORNER);
    image(tableGraphics, loc.x, loc.y);
  
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
    
    if (areBallsStill()) {
      cue.display();
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
  
  // Should be called when the mouse is called
  void mouseClick() {
    if (areBallsStill()) {
      cue.hit(getCueBall());
    }
  }
}