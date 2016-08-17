
// Main Processing tab
import ddf.minim.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

// Keep track of the table, the player manager and the cue ball
PoolTable table;
PlayerManager playerManager;

Cursor cursor; // For writting text to screen

// If quick advance is enabled, we'll calculate more steps per frame
boolean quickAdvance;

Minim minim;
AudioSample[] ballHitSamples; // Store multiple samples for the ball hits
AudioSample[] woodHitSamples; // Store multiple samples for the wood hits

// Global volume value (0 = 0%, 1 = 100%)
float globalVolume = 0;

void settings() {
  size(1000, 640);
}

void setup() {
  print("Loading... ");
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
  
  // Load cursor for writing text
  cursor = new Cursor();
  
  println("Done!");
}

void initWorld() {
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  // We are setting a custom gravity (no gravity)
  box2d.setGravity(0, 0);
  
  // Turn on collision listening
  box2d.listenForCollisions();
  
  // Initialize table and players (those floats are sizes)
  table = new PoolTable(0.6);
  playerManager = new PlayerManager(0.3, 0.13); 
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
  playerManager.display();
  
  fill(0);
  cursor.locate(10, height - 20);
  cursor.setTextSize(12);
  cursor.typePrevLine("Press R to Reset");
  
  if (!table.areBallsStill()) {
    cursor.typePrevLine("Press T to early Terminate this turn");
    cursor.type("Hold the right mouse button to quickly advance");
  }
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
    volume = map(volume, 0, 1, -30, 0); // -30 is almost like unaudible, this does the trick
    sample.setGain(volume);
  }
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