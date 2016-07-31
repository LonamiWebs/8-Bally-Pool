// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example
// Modified version from Box.pde

// An eight-ball pool ball
class Ball {

  // We need to keep track of a Body and a width and height
  Body body;
  float radius = 24;
  
  int number;
  boolean strips;
  PGraphics ballGraphics;

  // Constructor
  Ball(float x, float y, int _number) {
    
    number = _number;
    if (number > 8) {
      strips = true;
      _number -= 8; // lower the number by 8 to pick the right color
    }
    
    // create the graphics
    ballGraphics = getMaskedBall(radius, ballColors[_number], strips);
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), radius);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height + radius + radius) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the ball
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    
    imageMode(CENTER);
    image(ballGraphics, 0, 0);

    if (number > 0) { // a.k.a. not cue
      fill(number == 8 ? 255 : 0); // only white if the ball is the 8
      textAlign(CENTER);
      textSize(radius);
      text(number, 0, radius / 2); // half the text size
    }
    
    popMatrix();
  }

  // This function adds the ball to the box2d world
  void makeBody(Vec2 center, float radius) {

    // Define the circle shape
    CircleShape sd = new CircleShape();
    sd.m_radius = box2d.scalarPixelsToWorld(radius);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.0;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

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