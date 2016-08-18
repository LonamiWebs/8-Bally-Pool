
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
    
    if (area.contains(mouseX, mouseY)) {
      fill(overBackground);
      stroke(overForeground);
    } else {
      fill(background);
      stroke(foreground);
    }
    area.display();
    
    textAlign(CENTER, CENTER);
    fill(foreground);
    text(label, area.x + area.w / 2, area.y + area.h / 2);
  }
}