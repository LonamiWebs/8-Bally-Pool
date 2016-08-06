
class Cue {
  
  Ball cueBall;
  
  float cueLength = 300;
  float cueThickness = 8;
  
  float cueStrength = 5; // Affects to the hit velocity
  
  PVector startLoc;
  boolean hitting;
  
  void updateCueBall(Ball _cueBall) {
    cueBall = _cueBall;
  }
  
  void display() {
    
    // Determine the location of where we're going to hit
    // If we're hitting, it will be the saved starting location
    // Otherwise, it should point to the mouse
    PVector location = hitting ? startLoc.copy() : new PVector(mouseX, mouseY);
    
    // This vector represents the direction we'll use to move our cue along
    PVector ballLoc = cueBall.getLocationPVector();
    PVector cueToBall = PVector.sub(ballLoc, location);
    
    // Get the distance and normalize
    float distance = cueToBall.mag();
    cueToBall.div(distance); // Normalize without calculating the distance again
    
    // The end of our cue starts at the cue ball location
    PVector end = cueBall.getLocationPVector();
    
    // Then we add our direction vector multiplied by the desired separation
    // Half the cue thickness because it acts as radius
    end.add(PVector.mult(cueToBall, cueBall.radius + cueThickness / 2f));
    
    // If we're hitting, increase the distance from the cue end to the ball
    // based on the offset hit distance
    if (hitting) {
      end.add(PVector.mult(cueToBall, determineHitOffset()));
    }
    
    // The start of our cue is the end + the cue to ball vector * cue length
    PVector start = PVector.add(end, PVector.mult(cueToBall, cueLength));
    
    strokeWeight(cueThickness);
    stroke(120, 100, 20);
    line(start.x, start.y, end.x, end.y);
  }
  
  // Determines the hit offset (or how much the mouse moved since it was pressed)
  //
  // This is the projection of the mouse on the vector that goes from
  // the cue ball to the starting location (where the mouse started to be held)
  float determineHitOffset() {
    // See http://natureofcode.com/book/chapter-6-autonomous-agents/
    // |A| cos(θ) is the scalar projection of A onto B
    
    // Early terminate on this case
    if (startLoc == null) {
      return 0;
    }
    
    PVector ballLoc = cueBall.getLocationPVector();
    PVector a = PVector.sub(new PVector(mouseX, mouseY), ballLoc);
    PVector b = PVector.sub(startLoc,                    ballLoc);
    
    b.normalize();
    b.mult(a.dot(b));
    PVector normalPoint = PVector.add(ballLoc, b);
    
    // Check if the distance from the normal point to the cue ball
    // is larger than the distance from the starting location to the cue ball
    //
    // If this is the case, then we didn't "pull", hence the offset should be 0
    //
    // But this itself isn't enough (if we pull back far enough, the distance will be greater)
    // Hence, we also need to ensure that both signs are equal (going in the same direction)
    PVector ballToNormal = PVector.sub(normalPoint, ballLoc);
    PVector ballToStart = PVector.sub(startLoc, ballLoc);
    float distNormal = ballToNormal.mag();
    float distStart = ballToStart.mag();
    
    if (distNormal > distStart &&
        sign(ballToNormal.x) == sign(ballToStart.x) &&
        sign(ballToNormal.y) == sign(ballToStart.y)) {
      return 0;
    }
    
    // Otherwise, return the distance between the normal point and the starting location
    return dist(normalPoint.x, normalPoint.y, startLoc.x, startLoc.y);
  }
  
  // Get ready to hit the ball
  void beginHit() {
    startLoc = new PVector(mouseX, mouseY);
    hitting = true;
  }
  
  // End the hit, returns true if the hit was done
  // Returns false if the hit wasn't done (i.e. hit strength = 0)
  boolean endHit() {
    hitting = false;
    
    PVector power = getPowerVector();
    if (power.magSq() == 0) {
      return false;
    }
    cueBall.body.setLinearVelocity(box2d.vectorPixelsToWorld(power));
    return true;
  }
  
  // Returns a power vector, which indicates the strength that will be applied
  // to the ball hit
  PVector getPowerVector() {
    float power = getPower();
    if (power == 0) { // If there's no power, return an empty vector
      return new PVector();
    }
    
    PVector ballLoc = cueBall.getLocationPVector();
    PVector ballToLoc = PVector.sub(startLoc, ballLoc);
    ballToLoc.normalize();
    ballToLoc.mult(getPower());
    
    return ballToLoc;
  }
  
  // Returns the power magnitude for the current hit
  float getPower() {
    return determineHitOffset() * cueStrength;
  }
}