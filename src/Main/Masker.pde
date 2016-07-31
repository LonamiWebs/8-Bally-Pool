
// Mask utils
void circleMaskGraphics(PGraphics toMask, float radius) {
  
  PGraphics mask = createGraphics(int(radius * 2f), int(radius * 2f));
  
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.ellipseMode(RADIUS);
  mask.ellipse(radius, radius, radius, radius);
  mask.endDraw();
  
  toMask.mask(mask);
  
}

PGraphics getMaskedBall(float radius, color c, boolean strips) {
  
  PGraphics ball = createGraphics(int(radius * 2f), int(radius * 2f));
  
  ball.beginDraw();
  
  // Draw the ball itself
  ball.fill(strips ? 255 : c); // If it's stripped, the ball is white and the strip colored
  ball.noStroke();
  ball.ellipseMode(RADIUS);
  ball.ellipse(radius, radius, radius, radius);
  
  if (strips) { // If has stripes, draw one big strip
    ball.strokeWeight(radius * 5f / 4f);
    ball.stroke(c);
    ball.line(radius, 0, radius, radius * 2);
  }
  
  ball.endDraw();
  
  circleMaskGraphics(ball, radius);
  return ball;
}