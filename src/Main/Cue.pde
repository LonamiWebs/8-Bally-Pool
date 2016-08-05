
class Cue {
  
  PVector cueBallLoc;
  
  float cueLength = 300;
  float cueThickness = 8;
  
  void update(Ball cueBall) {
    cueBallLoc = cueBall.getLocationPVector();
  }
  
  void display() {
    
    // Get mouse location
    PVector location = new PVector(mouseX, mouseY);
    
    // The cue to ball vector is cue ball location - mouse location
    PVector cueToBall = PVector.sub(cueBallLoc, location);
    
    // Get the distance and normalize
    float distance = cueToBall.mag();
    cueToBall.div(distance); // Normalize without calculating the distance again
    
    // The end of our cue is the cue ball location + the cue to ball vector * distance
    // Because we use cueToBall * distance to "separate" our end from the ball
    PVector end = PVector.add(cueBallLoc, PVector.mult(cueToBall, distance));
    
    // The start of our cue is the end + the cue to ball vector * cue length
    PVector start = PVector.add(end, PVector.mult(cueToBall, cueLength));
    
    strokeWeight(cueThickness);
    stroke(120, 100, 20);
    line(start.x, start.y, end.x, end.y);
  }
  
  void hit(Ball cueBall) {
    // Get mouse location
    PVector location = new PVector(mouseX, mouseY);
    PVector cueToBall = PVector.sub(location, cueBallLoc);
    cueToBall.mult(5);
    
    cueBall.body.setLinearVelocity(box2d.vectorPixelsToWorld(cueToBall));
  }
  
}