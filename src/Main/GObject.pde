
interface GObjectEvent {
  void onClick(GObject sender); 
}
  
class GObject {
  
  PVector loc;
  PVector size;
  
  color background;
  color foreground;
  
  int keyDownFrame = -1;  // On what frame was the key down? -1 means it wasn't
  int framesBetweenKeyRepeat = 10; // How many frames until key repeat?
  
  boolean wasMouseDown;
  
  boolean hasFocus;
  
  GFrame parent;
  GObjectEvent event; // Keep track of the event listener
  
  GObject() {
    background = color(0);
    foreground = color(255);
    loc = new PVector();
    size = new PVector();
  }
  
  GObject(float x, float y, float w, float h) {
    this();
    loc.set(x, y);
    size.set(w, h);
  }
  
  void update() {
    if (!wasMouseDown && mousePressed) {
      if (contains(mouseX, mouseY)) { // Click
        onClick();
      }
    }
    boolean keyPress = false; // Was there a key press?
    // Check for keypress/repeat manually
    if (keyPressed) {
      if (frameCount - keyDownFrame > framesBetweenKeyRepeat) {
        keyDownFrame = frameCount;
        keyPress = true;
      }
    } else {
      keyDownFrame = -1;
    }
    
    if (keyPress) {
      if (hasFocus) { // Key press
        onKey();
      }
    }
    
    // Update new value
    wasMouseDown = mousePressed;
  }
  
  // Fired when the mouse is clicked
  void onClick() {
    if (parent != null) {
      parent.clearFocus();
    }
    hasFocus = true;
    if (event != null) {
      event.onClick(this);
    }
  }
  
  
  // Fired when a key is pressed
  void onKey() { }
  
  boolean contains(float x, float y) {
    return (x > loc.x &&
            y > loc.y &&
            x < loc.x + size.x &&
            y < loc.y + size.y);
  }
  
  void display() {
    fill(background);
    stroke(foreground);
    
    rectMode(CORNER);
    rect(loc.x, loc.y, size.x, size.y);
  }
}