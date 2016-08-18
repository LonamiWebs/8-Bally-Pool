
// "Interfaces" (no need to override everything)
class EventListener {
    public int id;
    
    public void mouseClicked() { }
    public void mousePressed() { }
    public void mouseReleased() { }
    public void keyPressed() { }
    
    public void beginContact(Contact cp) { }
    public void endContact(Contact cp) { }
}

// Adding/deleting event listener to window events (clicks and key press)
ArrayList<EventListener> eventListeners = new ArrayList<EventListener>();
static int _eventListenerId;  // Unique ID

int addEventListener(EventListener event) {
  event.id = _eventListenerId++; // Set a new unique ID to the event
  eventListeners.add(event);
  return event.id;
}
void delEventListener(int id) {
  for (int i = eventListeners.size() - 1; i >= 0; i--) {
    if (eventListeners.get(i).id == id) {
      eventListeners.remove(i);
      break;
    }
  }
}

// Window events, don't use foreach to avoid ConcurrentModificationExceptions
void keyPressed() {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).keyPressed();
  }
}

void mouseClicked() {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).mouseClicked();
  }
}

void mousePressed() {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).mousePressed();
  }
}

void mouseReleased() {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).mouseReleased();
  }
}

void beginContact(Contact cp) {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).beginContact(cp);
  }
}

void endContact(Contact cp) {
  for (int i = 0; i < eventListeners.size(); i++) {
    eventListeners.get(i).endContact(cp);
  }
}

// GUI events
void playLocal() {
  game.initWorld();
  
  // Dispose and set to null
  currentFrame.dispose();
  currentFrame = null;
}

void playHost() {
  
}

void playJoin() {
  
}