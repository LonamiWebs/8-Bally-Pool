// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example
// Slightly modified by Lonami for first attemps

// Basic example of floating ball

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our balls
ArrayList<Ball> balls;

void settings() {
  size(640,360);
}

void setup() {
  smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, 0);

  // Create ArrayLists	
  balls = new ArrayList<Ball>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/4,height-5,width/2-50,10));
  boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10));
}

void draw() {
  background(25, 150, 15);

  // We must always step through time!
  box2d.step();

  // Balls fall float on the middle of the screen every 5 frames
  if (frameCount % 5 == 0) {
    Ball p = new Ball(width / 2, height / 2, int(random(16))); // Pick a random ball number from 0-15
    balls.add(p);
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }

  // Display all the balls
  for (Ball b: balls) {
    b.display();
  }

  // Balls that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = balls.size()-1; i >= 0; i--) {
    Ball b = balls.get(i);
    if (b.done()) {
      balls.remove(i);
    }
  }
}