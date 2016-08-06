
// A table boundary with a 45% bevel
class TableBoundary {

  // We need to keep track of the body in order to display it
  Body body;

  // Location starts at the top left corner
  // Position may be TOP, RIGHT, BOTTOM or LEFT
  TableBoundary(PVector location, PVector size, int position) {
    // Add the box to the box2d world
    makeBody(location, size, position);
  }

  // See below to know what trim side means
  TableBoundary(PVector location, PVector size, int position, int trimSide) {
    makeBody(location, size, position, trimSide);
  }

  // Drawing the boundary
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(180, 120, 40);
    stroke(0);
    strokeWeight(2);
    beginShape();
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the fixed table boundary to the box2d world
  void makeBody(PVector corner, PVector size, int position) {
    makeBody(corner, size, position, 0);
  }
  
  // Trim side can be -1, 0 or 1, meaning that 0 will not trim any horizontal side
  // By "trimming" a side we make the bevel half the size
  void makeBody(PVector corner, PVector size, int position, int trimSide) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();

    Vec2[] vertices = new Vec2[4];
    switch(position) {
      
      // done
      case TOP:
        vertices[0] = box2d.vectorPixelsToWorld(0     , 0);
        vertices[1] = box2d.vectorPixelsToWorld(size.x, 0);
        
        // Although it's possible not to trim any side, we don't need it in this game
        assert(trimSide != 0);
        if (trimSide == -1) {
          vertices[2] = box2d.vectorPixelsToWorld(size.x - size.y, size.y);
          vertices[3] = box2d.vectorPixelsToWorld(size.y / 2f    , size.y); // Half bevel
        } else {
          vertices[2] = box2d.vectorPixelsToWorld(size.x - size.y / 2f, size.y); // Half bevel
          vertices[3] = box2d.vectorPixelsToWorld(size.y              , size.y);
        }
        
        break;
      
      case BOTTOM:
        
        assert(trimSide != 0);
        if (trimSide == -1) {
          vertices[0] = box2d.vectorPixelsToWorld(0      + size.y / 2f, 0);
          vertices[1] = box2d.vectorPixelsToWorld(size.x - size.y     , 0);
        } else {
          vertices[0] = box2d.vectorPixelsToWorld(0      + size.y     , 0);
          vertices[1] = box2d.vectorPixelsToWorld(size.x - size.y / 2f, 0);
        }
        
        vertices[2] = box2d.vectorPixelsToWorld(size.x         , size.y);
        vertices[3] = box2d.vectorPixelsToWorld(0              , size.y);
        break;
      
      case LEFT:
        vertices[0] = box2d.vectorPixelsToWorld(0              , 0);
        vertices[1] = box2d.vectorPixelsToWorld(0              , size.y);
        vertices[2] = box2d.vectorPixelsToWorld(size.x         , size.y - size.x);
        vertices[3] = box2d.vectorPixelsToWorld(size.x         , 0 + size.x);
        break;
      
      case RIGHT:
        vertices[0] = box2d.vectorPixelsToWorld(0              , 0 + size.x);
        vertices[1] = box2d.vectorPixelsToWorld(0              , size.y - size.x);
        vertices[2] = box2d.vectorPixelsToWorld(size.x         , size.y);
        vertices[3] = box2d.vectorPixelsToWorld(size.x         , 0);
        break;
    }

    sd.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(corner));
    body = box2d.createBody(bd);

    body.createFixture(sd, 1.0);
    
    body.setUserData(this); // So we can retrieve the parent class on collisions
  }
}