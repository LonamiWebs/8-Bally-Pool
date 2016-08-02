
// Main Processing tab

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

PoolTable table;

void settings() {
  size(820, 640);
}

void setup() {
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, 0);
  table = new PoolTable(0.8);
}

void draw() {
  background(20);
  // We must always step through time!
  box2d.step();
  
  table.display();
}