
// Represents one of the 16 balls in the original 8-ball game
class Ball {

  // We need to keep track of a Body and its radius
  Body body;
  float radius;
  
  boolean isDying; // Has the ball fallen in a hole? And is dying painfully?
  float minSpeed = 0.2; // If the ball speed is below this, early stop it
  
  int number;
  PImage ballGraphics;

  // Constructor
  Ball(float x, float y, float _radius, int _number) {
    
    radius = _radius;
    number = _number;
    
    // Create the graphics
    ballGraphics = loadImage("img/ball_" + number + ".png");
    ballGraphics.resize(int(radius * 2), int(radius * 2)); // Resize once to avoid scaling on display()
    
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

  // This function marks the ball as dead
  void kill() {
    isDying = true; // Mark the ball as dying for it to be animated
  }
  
  // Determines whether the ball is dead yet or not
  boolean isDead() {
    return radius < 0.5;
  }
  
  // Determines whether the ball is still (stopped) or not
  boolean isStill() {
    return isDead() || body.getLinearVelocity().length() < minSpeed;
  }
  
  void update() {
    // If the ball is dying, shrink it
    if (isDying) {
      radius = lerp(radius, 0, 0.1); // values = from, to, speed
      
      Fixture f = body.getFixtureList();
      CircleShape cs = (CircleShape) f.getShape();
      cs.m_radius = box2d.scalarPixelsToWorld(radius);
      
      if (isDead()) { // If the ball radius reached its limit
        // Remove it from the box2d world
        box2d.destroyBody(body);
      }
    }
    // Else if the speed is less than the minimum, stop the body completely
    else if (body.getLinearVelocity().length() < minSpeed) {
      body.setLinearVelocity(new Vec2(0, 0));
    }
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
    bd.linearDamping = 0.3;
    bd.angularDamping = 0.3;

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity for testing purposes
    body.setLinearVelocity(new Vec2(random(-40, 10), random(5, 10)));
    body.setAngularVelocity(random(-5, 5));
    
    body.setUserData(this); // So we can retrieve the parent class on collisions 
  }
}