
// Displays the cue power on screen
class CuePowerDisplay {
  
  // Location and step size of the power-o-meter
  Vec2 loc;
  Vec2 stepSize;
  
  // Maximum height the display can take
  float maxHeight;
  
  // Maximum steps (precision) for displaying
  float stepCount = 50;
  float margin = 20;
  
  // Determines the low and high color
  color lowColor = color(0, 255, 0);
  color highColor = color(255, 0, 0);
  
  CuePowerDisplay(float relativeHeight) {
    
    maxHeight = relativeHeight * height;
    
    // Divide the difference of the remaining height space by 2
    // for each side (up and down)
    loc = new Vec2(margin, (height - maxHeight) / 2f);
    stepSize = new Vec2(40, maxHeight / stepCount);
  }
  
  void display(float currentPower, float maxPower) {
    
    noStroke();
    
    // Determine how many steps we should paint
    int steps = int(map(currentPower, 0, maxPower, 0, stepCount));
    
    // Iterate over all the steps
    for (int i = 0; i < steps; i++) { // Paint the filled steps
    
      // Increment the step location by the step size times the current step
      Vec2 stepLoc = loc.add(new Vec2(0, stepSize.y * i));
      
      // Determine the color for this step and draw a rectangle
      fill(getColor(i), 200);
      rect(stepLoc.x, stepLoc.y, stepSize.x, stepSize.y);
    }
    
    // Paint the left steps
    fill(0, 0, 0, 50);
    
    // The left steps start exactly at the step number "steps"
    Vec2 emptySteps = loc.add(new Vec2(0, stepSize.y * steps));
    
    // The height of this step equals to the remaining steps  (stepCount - steps)
    rect(emptySteps.x, emptySteps.y, stepSize.x, stepSize.y * (stepCount - steps));
  }
  
  // Gets an interpolated color for the current step
  color getColor(int step) {
    float r = map(step, 0, stepCount, red(lowColor), red(highColor));
    float g = map(step, 0, stepCount, green(lowColor), green(highColor));
    float b = map(step, 0, stepCount, blue(lowColor), blue(highColor));
    return color(r, g, b);
  }
}