
class GObjectListener {
  public void mouseClicked(GObject sender) { }
  public void keyPressed(GObject sender) { }
}
  
class GObject {

  Area area;
  
  color background;
  color foreground;
  
  int keyDownFrame = -1;  // On what frame was the key down? -1 means it wasn't
  int framesBetweenKeyRepeat = 10; // How many frames until key repeat?
  
  boolean wasMouseDown;
  
  boolean hasFocus;
  
  GFrame parent;
  
  // Adding event listener to the GObjects
  ArrayList<GObjectListener> gobjectListeners = new ArrayList<GObjectListener>();
  int eventListenerId;  // Store the event listener ID here for later disposal
  
  void addGObjectListener(GObjectListener event) {
    gobjectListeners.add(event);
  }
  
  GObject() {
    background = color(0);
    foreground = color(255);
    area = new Area();
    
    // Register to global events to use locally
    eventListenerId = addEventListener(new EventListener() {
      @Override
      public void mouseClicked() {
        if (area.contains(mouseX, mouseY)) {
          onClick(); // Fire local click if the mouse is on this object 
        }
      }
      @Override
      public void keyPressed() {
        if (hasFocus) {
          onKey(); // Fire local key press if this object has the focus 
        }
      }
    });
  }
  
  GObject(float x, float y, float w, float h) {
    this();
    area.locate(x, y);
    area.resize(w, h);
  }
  
  // Fired when the mouse is clicked
  void onClick() {
    if (parent != null) {
      parent.clearFocus();
    }
    hasFocus = true;
    
    // Fire the event to those subscribed
    for (GObjectListener listener : gobjectListeners) {
      listener.mouseClicked(this);
    }
  }
  
  
  // Fired when a key is pressed
  void onKey() {
    // Fire the event to those subscribed
    for (GObjectListener listener : gobjectListeners) {
      listener.keyPressed(this);
    }
  }
  
  void display() {
    fill(background);
    stroke(foreground);
    area.display();
  }
  
  void dispose() {
    delEventListener(eventListenerId);
  }
}