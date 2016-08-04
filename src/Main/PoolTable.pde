
class PoolTable {
  
  // Location and size
  PVector location;
  PVector size;
  
  PImage tableGraphics;

  // Lists we'll use to track objects
  ArrayList<TableBoundary> boundaries; // Track table
  ArrayList<Hole> holes;
  ArrayList<Ball> balls;
  
  // Initializes the pool table with a relative percentage width
  // The width should be in the range (0..1)
  PoolTable(float relativeWidth) {
    
    // Set table size and location
    setSizeAndLocation(relativeWidth);
    
    // Create the graphics
    tableGraphics = loadImage("img/table.png");
    tableGraphics.resize(int(size.x), int(size.y)); // Resize once to avoid scaling on display()
  
    // Create ArrayLists
    boundaries = new ArrayList<TableBoundary>();
    holes = new ArrayList<Hole>();
    balls = new ArrayList<Ball>();
  
    // Add a bunch of fixed boundaries
    float ballRadius = getBallRadius(relativeWidth);
    float holeRadius = getHoleRadius(ballRadius);
    addTableBoundaries(holeRadius);
    
    // Add a bunch of holes (upper holes)
    holes.add(new Hole(location.copy(), holeRadius)); // (0.0, 0.0)
    holes.add(new Hole(new PVector(location.x + size.x / 2, location.y), holeRadius)); // (0.5, 0.0)
    holes.add(new Hole(new PVector(location.x + size.x, location.y), holeRadius)); // (1.0, 0.0)
    // Add a bunch of holes (downer holes)
    holes.add(new Hole(new PVector(location.x, location.y + size.y), holeRadius)); // (0.0, 1.0)
    holes.add(new Hole(new PVector(location.x + size.x / 2, location.y + size.y), holeRadius)); // (0.5, 1.0)
    holes.add(new Hole(new PVector(location.x + size.x, location.y + size.y), holeRadius)); // (1.0, 1.0)
    
    // Place the balls triangle
    float triangleY = height / 2;
    float triangleX = location.x + size.x * 0.75; // Place at the 75% of the table
    placeTriangleBalls(ballRadius, triangleX, triangleY);
  }
  
  void setSizeAndLocation(float relativeWidth) {
    // From Wikipedia we know that the height is half the width
    // "The table's playing surface is approximately 9 by 4.5 feet (2.7 by 1.4 m)"
    float endWidth = relativeWidth * width;
    size = new PVector(endWidth, endWidth * 1 / 2f);
    
    float leftMargin = (width - size.x) / 2f;
    float upMargin = (height - size.y) / 2f;
    location = new PVector(leftMargin, upMargin);
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
  
  void placeTriangleBalls(float ballRadius, float x, float y) {
    
    // Stores the available numbers, we'll pick a random one every time
    ArrayList<Integer> numbers = new ArrayList<Integer>(15);
    for (int i = 1; i <= 15; i++) {
      numbers.add(i);
    }
    
    // Generate vectors used for moving when placing the balls
    PVector rightUp = new PVector(1, 0);
    rightUp.rotate(-1f / 6f * PI); // -30º (up)
    rightUp.mult(ballRadius * 2.2); // 2.2 to add some more spacing
    
    PVector rightDown = new PVector(1, 0);
    rightDown.rotate(1f / 6f * PI); // 30º (down)
    rightDown.mult(ballRadius * 2.2);
    
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
    
    PVector loc = new PVector(x, y); // initial point
    for (int i = 0; i < 5; i++) { // going up
      
      
      for (int j = 0; j < 5 - i; j++) { // going down
        
        // Displacement for this IJ, add it to the initial point to get the ball location
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
  
  void addTableBoundaries(float holeRadius) {
    // The table boundaries are displaced the radius of the hole from the corner
    float boundaryThickness = holeRadius;
    
    // ----------------------------------------------------------------------------- Top
    PVector boundaryLoc = new PVector(location.x, location.y - boundaryThickness);
    // The horizontal size is (table width / 2) - (radius of the middle hole)
    PVector horizontalSize = new PVector(size.x / 2f - holeRadius, boundaryThickness);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP));
    
    // Move to the next table boundary by adding its size + diameter of the hole
    boundaryLoc.add(horizontalSize.x + holeRadius * 2f, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, TOP));
    
    // ----------------------------------------------------------------------------- Bottom
    boundaryLoc.set(location.x, location.y + size.y);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM));
    // Move to the next table boundary by adding its size + diameter of the hole
    boundaryLoc.add(horizontalSize.x + holeRadius * 2f, 0);
    boundaries.add(new TableBoundary(boundaryLoc, horizontalSize, BOTTOM));
    
    // ----------------------------------------------------------------------------- Left
    boundaryLoc.set(location.x - boundaryThickness, location.y);
    // The vertical size is the same as the table height, since there's only one
    PVector verticalSize = new PVector(boundaryThickness, size.y);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, LEFT));
    
    // ----------------------------------------------------------------------------- Right
    boundaryLoc.add(size.x + boundaryThickness, 0);
    boundaries.add(new TableBoundary(boundaryLoc, verticalSize, RIGHT));
  }
  
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
      if (ball.isDead()) { // If a ball is now dead, remove it from our list
        balls.remove(i);
      }
    }
  }

  void display() {
    
    rectMode(CORNER);
    /*
    fill(25, 150, 15);
    noStroke();
    rect(location.x, location.y, size.x, size.y);
    */
    
    imageMode(CORNER);
    image(tableGraphics, location.x, location.y);
  
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
  
}