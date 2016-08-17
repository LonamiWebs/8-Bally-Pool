
// Represents a table hole
class Hole {

  Vec2 location;
  float radius;

  Hole(Vec2 _location, float _radius) {
    location = _location;
    radius = _radius;
  }
  
  boolean containsBall(Ball ball) {
    // Use distance squared for more performance
    float distance = ball.getLocation().sub(location).lengthSquared();
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