
class GButton extends GObject {
  
  color overBackground;
  color overForeground;
  
  String label;
  
  GButton(float x, float y, float w, float h) {
    super(x, y, w, h);
    
    overBackground = color(20);
    overForeground = color(220);
    
    label = "Button v." + x;
  }
  
  void display() {
    
    if (contains(mouseX, mouseY)) {
      fill(overBackground);
      stroke(overForeground);
    } else {
      fill(background);
      stroke(foreground);
    }
    rectMode(CORNER);
    rect(loc.x, loc.y, size.x, size.y);
    
    textAlign(CENTER, CENTER);
    fill(foreground);
    text(label, loc.x + size.x / 2, loc.y + size.y / 2);
  }
}