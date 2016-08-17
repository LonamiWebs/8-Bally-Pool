
class TextureGenerator {
  
  PFont font;
  TextureGenerator() {
    font = loadFont("TheBoldFont-48.vlw");
  }
  
  // ---------------------------------------- Balls textures begin
  color[] ballColors = new color[] {
    color(255, 255, 255), // cue      white
    color(255, 220, 10),  // 1 and 9  yellow
    color(0,   100, 255), // 2 and 10 blue
    color(255, 10,  10),  // 3 and 11 red
    color(120, 50,  180), // 4 and 12 purple
    color(255, 135, 10),  // 5 and 13 orange
    color(60,  180, 80),  // 6 and 14 green
    color(180, 80,  60),  // 7 and 15 maroon
    color(0,   0,   0),   // 8        black
  };
  
  PGraphics generateBallTexture(int ballNumber, float radius) {
    
    int diameter = int(radius * 2f);
    
    boolean strips = ballNumber > 8;
    // If the ball is stripped, substract 8 to get the right color
    color ballColor = ballColors[ballNumber - (strips ? 8 : 0)];
    PGraphics ball = createGraphics(diameter, diameter);
    
    ball.beginDraw();
    
    // Draw the ball itself
    ball.fill(strips ? 255 : ballColor); // If it's stripped, the ball is white and the strip colored
    ball.noStroke();
    ball.ellipseMode(RADIUS);
    ball.ellipse(radius, radius, radius, radius);
    
    // If has stripes, draw one big strip
    if (strips) {
      ball.strokeWeight(radius * 1.3);
      ball.stroke(ballColor);
      ball.line(radius, 0, radius, radius * 2);
    }
    
    // Draw a smaller white circle, and then draw text inside
    if (ballNumber > 0) { // Only if it's not the cue ball
      float txtSize = radius * 0.55;
      ball.fill(255);
      ball.noStroke();
      ball.ellipse(radius, radius, txtSize, txtSize);
      ball.textAlign(CENTER, CENTER);
      ball.textFont(font, txtSize);
      ball.fill(0);
      ball.text(ballNumber, radius, radius);
    }
    ball.endDraw();
    
    // Apply a circular mask
    PGraphics mask = createGraphics(diameter, diameter);
    mask.beginDraw();
    mask.background(0);
    mask.noStroke();
    mask.fill(255);
    mask.ellipseMode(RADIUS);
    mask.ellipse(radius, radius, radius, radius);
    mask.endDraw();
    ball.mask(mask);
    
    return ball;
  }
  // ---------------------------------------- Balls textures end
  
  // ---------------------------------------- Table texture begin
  PGraphics generateTableTexture(int w, int h, float noiseStep, float seed) {
    // The larger the noise step, the smaller its size
    
    PGraphics table = createGraphics(w, h);
    table.beginDraw();
    
    // Green color
    float r = 40;
    float g = 160;
    float b = 40;
    
    // Different colors offset so they don't increment at once
    float rOff = 0;
    float gOff = 100;
    float bOff = 200;
    
    // Maximum color deviation
    float deviation = 10;
    
    table.loadPixels();
    int imageSize = table.width * table.height;
    for (int i = 0; i < imageSize; i++) {
      
      int x = i % table.width; // the x position repeats every width, hence the remainder
      int y = i / table.width; // divide by stride to get the y position
      
      // Map the x and y values to a range of [0..noiseStep]
      // Add the seed so random textures can be generated
      float xOff = seed + map(x, 0, width, 0, noiseStep);
      float yOff = seed + map(y, 0, height, 0, noiseStep);
      
      // The final value equals the original + deviation, based on the noise with the given offsets
      float rFinal = r + map(noise(xOff + rOff, yOff + rOff), 0, 1, -deviation, deviation);
      float gFinal = g + map(noise(xOff + gOff, yOff + gOff), 0, 1, -deviation, deviation);
      float bFinal = b + map(noise(xOff + bOff, yOff + bOff), 0, 1, -deviation, deviation);
      table.pixels[i] = color(rFinal, gFinal, bFinal);
    }
    table.updatePixels();
    
    table.endDraw();
    return table;
  }
  // ---------------------------------------- Table texture end
}