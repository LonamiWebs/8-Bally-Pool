
class EventListener {
    public void mouseClicked() { }
    public void mousePressed() { }
    public void mouseReleased() { }
    public void keyPressed() { }
    public void beginContact(Contact cp) { }
    public void endContact(Contact cp) { }
}

ArrayList<EventListener> eventListeners = new ArrayList<EventListener>();

void addEventListener(EventListener event) {
  eventListeners.add(event);
}

void keyPressed() {
  for (EventListener event : eventListeners) {
    event.keyPressed();
  }
}

void mouseClicked() {
  for (EventListener event : eventListeners) {
    event.mouseClicked();
  }
}

void mousePressed() {
  for (EventListener event : eventListeners) {
    event.mousePressed();
  }
}

void mouseReleased() {
  for (EventListener event : eventListeners) {
    event.mouseReleased();
  }
}

void beginContact(Contact cp) {
  for (EventListener event : eventListeners) {
    event.beginContact(cp);
  }
}

void endContact(Contact cp) {
  for (EventListener event : eventListeners) {
    event.endContact(cp);
  }
}