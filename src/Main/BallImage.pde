
// Represents a static ball which is just an image
class BallImage {
  
  // Keep track of the ball diameter
  float diameter;
  
  int number;
  PImage ballGraphics;
  
  boolean solids;
  boolean strips;

  // Constructor
  BallImage(float radius, int _number) {
    
    diameter = radius * 2f;
    number = _number;
    
    // Create the graphics
    ballGraphics = loadImage("img/ball_" + number + ".png");
    ballGraphics.resize(int(diameter), int(diameter)); // Resize once to avoid scaling on display()
    
    // Determine whether it's solids or strips (or none)
    if (number > 0) {
      if (number < 8) {
        solids = true;
      } else if (number > 8) {
        strips = true;
      }
    }
  }

  // Drawing the ball
  void display(float x, float y) {
    imageMode(CENTER);
    image(ballGraphics, x, y, diameter, diameter);
  }
}