
// Represents one of the 16 balls in the original 8-ball game
class Ball {

  // We need to keep track of a Body and its radius
  Body body;
  float radius = 24;
  
  int number;
  boolean strips;
  PImage ballGraphics;

  // Constructor
  Ball(float x, float y, float _radius, int _number) {
    
    radius = _radius;
    number = _number;
    if (number > 8) {
      strips = true;
      _number -= 8; // lower the number by 8 to pick the right color
    }
    
    // create the graphics
    ballGraphics = loadImage("img/ball_" + number + ".png");
    
    // Add th box to the box2d world
    makeBody(new Vec2(x, y), radius);
  }
  
  PVector getLocationPVector() {
    Vec2 loc = getLocation();
    return new PVector(loc.x, loc.y);
  }
  
  Vec2 getLocation() {
    return box2d.getBodyPixelCoord(body);
  }

  // This function removes the ball from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Drawing the ball
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = getLocation();
    // Get its angle of rotation
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    
    imageMode(CENTER);
    image(ballGraphics, 0, 0, radius * 2, radius * 2);
    
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
    fd.restitution = 0.7;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    // Parameters that affect physics
    bd.linearDamping = 0.2;
    bd.angularDamping = 0.2;
    // ---------------------- TODO: limit velocity, if less than (minVel), stop the body so the next player can play its turn

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity for testing purposes
    body.setLinearVelocity(new Vec2(random(-30, 5), random(5, 10)));
    body.setAngularVelocity(random(-5, 5));
  }
}