
// Represents a table hole
class Hole {

  PVector location;
  float radius;

  Hole(PVector _location, float _radius) {
    location = _location;
    radius = _radius;
  }
  
  boolean containsBall(Ball ball) {
    // Use distance squared for more performance
    float distance = PVector.sub(ball.getLocationPVector(), location).magSq();
    return distance < radius * radius;
  }

  // Drawing the table hole
  void display() {
    ellipseMode(RADIUS);
    noStroke();
    fill(20);
    ellipse(location.x, location.y, radius, radius);
  }
}