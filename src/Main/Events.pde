
// Global events are stored in this file for quicker access
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
        // Update one last time to notify that balls are still
        update();
      break;
  }
}

void mousePressed() {
  table.mousePress();
  if (mouseButton == RIGHT) {
    quickAdvance = true;
  }
}

void mouseReleased() {
  table.mouseRelease();
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