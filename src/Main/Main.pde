
// Main Processing tab
import ddf.minim.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Game game;
Cursor cursor; // For writting text to screen


void settings() {
  size(1000, 640);
}

void setup() {
  print("Loading... ");
  surface.setTitle("8-Ball Pool");
  
  game = new Game(this);
  game.initWorld();
    
  // Load cursor for writing text
  cursor = new Cursor();
  
  println("Done!");
}


void draw() {
  smooth();
  background(255, 210, 240);
  
  game.run();
}

// Returns the sign of a given value
int sign(float value) {
  if (value > 0) {
    return 1;
  } else if (value < 0) {
    return -1;
  } else {
    return 0;
  }
}