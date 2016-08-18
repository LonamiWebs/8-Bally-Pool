
class Cue {
  
  float cueLength = 300;
  float cueThickness = 8;
  
  float cueStrength = 10; // Affects to the hit velocity
  float cueMaxOffset = 100; // Limits the offset when pulling
  
  Vec2 startLoc;
  boolean hitting;
  
  CuePowerDisplay cuePower;
  
  Cue() {
    cuePower = new CuePowerDisplay(0.6); // Arbitrary relative height
  }
  
  void display() {
    
    Ball ball = game.table.getCueBall();
    
    // Determine the location of where we're going to hit
    // If we're hitting, it will be the saved starting location
    // Otherwise, it should point to the mouse
    Vec2 location = hitting ? new Vec2(startLoc) : new Vec2(mouseX, mouseY);
    
    // This vector represents the direction we'll use to move our cue along
    Vec2 ballLoc = ball.getLocation();
    Vec2 cueToBall = ballLoc.sub(location);
    
    // Normalize the cue to ball vector so it can be scaled afterwards
    cueToBall.normalize();
    
    // The end of our cue starts at the cue ball location
    Vec2 end = ball.getLocation();
    
    // Then we add our direction vector multiplied by the desired separation
    // Half the cue thickness because it acts as radius
    end.addLocal(cueToBall.mul(ball.radius + cueThickness / 2f));
    
    // If we're hitting, increase the distance from the cue end to the ball
    // based on the offset hit distance
    if (hitting) {
      end.addLocal(cueToBall.mul(determineHitOffset()));
    }
    
    // The start of our cue is the end + the cue to ball vector * cue length
    Vec2 start = end.add(cueToBall.mul(cueLength));
    
    strokeWeight(cueThickness);
    stroke(120, 100, 20);
    line(start.x, start.y, end.x, end.y);
    
    cuePower.display(getPower(), getMaxPower());
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
    
    Vec2 ballLoc = game.table.getCueBall().getLocation();
    Vec2 a = new Vec2(mouseX, mouseY).sub(ballLoc);
    Vec2 b = startLoc.sub(ballLoc);
    
    b.normalize();
    b.mulLocal(Vec2.dot(a, b));
    Vec2 normalPoint = ballLoc.add(b);
    
    // Check if the distance from the normal point to the cue ball
    // is larger than the distance from the starting location to the cue ball
    //
    // If this is the case, then we didn't "pull", hence the offset should be 0
    //
    // But this itself isn't enough (if we pull back far enough, the distance will be greater)
    // Hence, we also need to ensure that both signs are equal (going in the same direction)
    Vec2 ballToNormal = normalPoint.sub(ballLoc);
    Vec2 ballToStart = startLoc.sub(ballLoc);
    float distNormal = ballToNormal.length();
    float distStart = ballToStart.length();
    
    if (distNormal > distStart &&
        sign(ballToNormal.x) == sign(ballToStart.x) &&
        sign(ballToNormal.y) == sign(ballToStart.y)) {
      return 0;
    }
    
    // Otherwise, return the distance between the normal point and the starting location
    float offset = dist(normalPoint.x, normalPoint.y, startLoc.x, startLoc.y); 
    return min(offset, cueMaxOffset);
  }
  
  // Get ready to hit the ball
  void beginHit() {
    startLoc = new Vec2(mouseX, mouseY);
    hitting = true;
  }
  
  // End the hit, returns true if the hit was done
  // Returns false if the hit wasn't done (i.e. hit strength = 0)
  boolean endHit() {
    hitting = false;
    
    Vec2 power = getPowerVector();
    startLoc = null; // Reset start location after we found the power
    
    if (power.lengthSquared() == 0) {
      return false;
    }
    game.table.getCueBall().setVelocity(power);
    return true;
  }
  
  // Returns a power vector, which indicates the strength that will be applied
  // to the ball hit
  Vec2 getPowerVector() {
    float power = getPower();
    if (power == 0) { // If there's no power, return an empty vector
      return new Vec2();
    }
    
    Vec2 ballLoc = game.table.getCueBall().getLocation();
    Vec2 ballToLoc = startLoc.sub(ballLoc);
    ballToLoc.normalize();
    ballToLoc.mulLocal(getPower());
    
    return ballToLoc;
  }
  
  // Returns the power magnitude for the current hit
  float getPower() {
    return determineHitOffset() * cueStrength;
  }
  
  // Returns the maximum power magnitude
  float getMaxPower() {
    return cueMaxOffset * cueStrength;
  }
}