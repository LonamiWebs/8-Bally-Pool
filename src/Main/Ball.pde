
// Represents one of the 16 balls in the original 8-ball game
class Ball {

  // We need to keep track of a Body and its radius
  Body body;
  float radius;
  
  boolean isDying; // Has the ball fallen in a hole? And is dying painfully?
  float minSpeed = 0.5; // If the ball speed is below this, consider it still
  
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
  
  Vec2 getLocation() {
    return box2d.getBodyPixelCoord(body);
  }

  // This function marks the ball as dying
  // Returns true if it was alive, false otherwise
  boolean kill() {
    boolean wasDying = isDying;
    isDying = true; // Mark the ball as dying for it to be animated
    
    return !wasDying; // Return true if it was alive
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
      body.setLinearVelocity(body.getLinearVelocity().mul(0.80)); // slow down the body
      
      Fixture f = body.getFixtureList();
      CircleShape cs = (CircleShape) f.getShape();
      cs.m_radius = box2d.scalarPixelsToWorld(radius);
      
      if (isDead()) { // If the ball radius reached its limit
        // Remove it from the box2d world
        box2d.destroyBody(body);
      }
    }
    // Else if the speed is less than the minimum, slow it down faster
    else if (body.getLinearVelocity().length() < minSpeed) {
      // 0.75 is an arbitrary percentage to slow down the body
      body.setLinearVelocity(body.getLinearVelocity().mul(0.75));
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
  
  private float getDensity(float radius, float mass) {
    float area = PI * sq(radius);
    return mass / area;
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
    // http://billiards.colostate.edu/threads/physics.html
    fd.density = getDensity(sd.m_radius, 0.1701); // 6 oz = 170.1g 
    fd.restitution = 0.95;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    // Parameters that affect physics
    bd.linearDamping = 0.77; // Value based on other games
    bd.angularDamping = 0.77;

    body = box2d.createBody(bd);
    body.createFixture(fd);

    body.setUserData(this); // So we can retrieve the parent class on collisions 
  }
}