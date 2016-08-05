
// Main Processing tab
import ddf.minim.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

PoolTable table;

// If quick advance is enabled, we'll calculate more steps per frame
boolean quickAdvance;

Minim minim;
AudioSample[] ballHitSamples; // Store multiple samples for the ball hits
AudioSample[] woodHitSamples; // Store multiple samples for the wood hits

// Global volume value (0 = 0%, 1 = 100%)
float globalVolume = 1;

void settings() {
  size(1000, 640);
}

void setup() {
  surface.setTitle("8-Ball Pool");

  // Initialize our box2d world (and our table)
  initWorld();
 
  // Load some hit sounds
  minim = new Minim(this);
  
  ballHitSamples = new AudioSample[5];
  for (int i = 0; i < ballHitSamples.length; i++) {
    ballHitSamples[i] = minim.loadSample("audio/ballhit_" + (i + 1) + ".aiff", 512); // 512 buffer size
  }
  
  woodHitSamples = new AudioSample[9];
  for (int i = 0; i < woodHitSamples.length; i++) {
    woodHitSamples[i] = minim.loadSample("audio/woodhit_" + (i + 1) + ".aiff", 512); // 512 buffer size
  }
}

void initWorld() {
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  // We are setting a custom gravity (no gravity)
  box2d.setGravity(0, 0);
  
  // Turn on collision listening
  box2d.listenForCollisions();
  
  table = new PoolTable(0.8);
}

void update() {
  // We must always step through time!
  box2d.step();
  table.update();
}

void draw() {
  smooth();
  background(255, 210, 240);
  
  // Update both the world and the table
  if (quickAdvance) { // If quick advance is enabled, calculate 5 steps instead 1
    for (int i = 0; i < 5; i++) {
      update();
    } 
  } else {
    update();
  }
  
  table.display();
  
  fill(0);
  if (table.areBallsStill()) {
    text("You can now use the cue", 10, 20);
  } else {
    text("Hold the right mouse button to quickly advance", 10, height - 60);
    text("Press T to early Terminate this turn", 10, height - 40);
  }
  text("Press R to Reset", 10, height - 20);
}

void keyPressed() {
  switch (key) {
    case 'r':
    case 'R':
      initWorld();
      break;
    
    case 't':
    case 'T':
        while (!table.areBallsStill()) {
          update();
        }
      break;
  }
  if (key == 'r' || key == 'R') {
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    quickAdvance = true;
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    quickAdvance = false;
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    table.mouseClick();
  }
}

void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  // Get the velocity magnitude, and find the highest
  float mag1 = b1.getLinearVelocity().length();
  float mag2 = b2.getLinearVelocity().length();
  float mag = max(mag1, mag2);
  
  // Use the highest velocity to determine the volume (between 0-1)
  float vol = constrain(map(mag, 0, 10, 0, 1), 0, 1);
  
  // If both objects are balls, play a random ball hit sound
  if (o1.getClass() == Ball.class && o2.getClass() == Ball.class) {
    
    int n = int(random(ballHitSamples.length)); // Get a random sample
    setVolume(ballHitSamples[n], vol); // Set the volume depending its velocity
    ballHitSamples[n].trigger(); // Play it
    
  } else { // One must have been wood
    
    int n = int(random(woodHitSamples.length)); // Get a random sample
    setVolume(woodHitSamples[n], vol); // Set the volume depending its velocity
    woodHitSamples[n].trigger(); // Play it
  }
}

void endContact(Contact cp) {
}

void setVolume(AudioSample sample, float volume) {
  
  volume *= globalVolume;
  
  // TODO Update not to use deprecated methods
  // TODO set pan depending on its location on screen?
  if (sample.hasControl(Controller.VOLUME)) // Prefer volume over gain hack
  {
    sample.setVolume(volume);
  }
  else if (sample.hasControl(Controller.GAIN)) // "Volume" fallback
  {
    volume = map(volume, 0, 1, -15, 0); // -15 is almost like unaudible, this does the trick
    sample.setGain(volume);
  }
}