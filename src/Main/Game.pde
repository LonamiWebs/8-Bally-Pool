
// A reference to our box2d world, let it be global
Box2DProcessing box2d;
  
class Game
{
  
  // Keep track of the table, the player manager and the cue ball
  PoolTable table;
  PlayerManager playerManager;
  
  Minim minim;
  AudioSample[] ballHitSamples; // Store multiple samples for the ball hits
  AudioSample[] woodHitSamples; // Store multiple samples for the wood hits
  
  // Global volume value (0 = 0%, 1 = 100%)
  float globalVolume = 0;
  
  PApplet parent;
  
  boolean isInitialized;  // Is the game initialized?
  
  public Game(PApplet _parent) {
    parent = _parent;
    
    // Load some hit sounds
    minim = new Minim(parent);
    
    ballHitSamples = new AudioSample[5];
    for (int i = 0; i < ballHitSamples.length; i++) {
      ballHitSamples[i] = minim.loadSample("audio/ballhit_" + (i + 1) + ".aiff", 512); // 512 buffer size
    }
    
    woodHitSamples = new AudioSample[9];
    for (int i = 0; i < woodHitSamples.length; i++) {
      woodHitSamples[i] = minim.loadSample("audio/woodhit_" + (i + 1) + ".aiff", 512); // 512 buffer size
    }
    
    addEventListener(new EventListener() {
      @Override
      public void beginContact(Contact cp) {
        onContact(cp); // Fire local method
      }
    });
  }
    
  // Initialize our box2d world (and our table)
  void initWorld() {
    // Initialize box2d physics and create the world
    box2d = new Box2DProcessing(parent);
    box2d.createWorld();
    
    // We are setting a custom gravity (no gravity)
    box2d.setGravity(0, 0);
    
    // Turn on collision listening
    box2d.listenForCollisions();
    
    // Initialize table and players (those floats are sizes)
    table = new PoolTable(0.6);
    playerManager = new PlayerManager(0.3, 0.13);
    
    isInitialized = true;
  }
  
  void run() {
    update();
    display();
  }
  
  void update() {
    // We must always step through time!
    box2d.step();
    table.update();
  }
  
  void display() {
    table.display();
    playerManager.display();
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
  
  void onContact(Contact cp) {
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
}