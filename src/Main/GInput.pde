
class GInput extends GObject {
  
  color focusBackground;
  color focusForeground;
  
  StringBuilder textBuilder;
  String cachedText;
  
  String hint;
  
  GInput(float x, float y, float w, float h) {
    super(x, y, w, h);
    
    background = color(20, 40, 40);
    focusBackground = color(20);
    focusForeground = color(220);
    
    textBuilder = new StringBuilder();
    cachedText = "";
    hint = "Enter your name";
  }
  
  void onClick() {
    super.onClick();
  }
  
  void onKey() {
    int keyCode = (int)key;
    if (keyCode == BACKSPACE || (int)key == DELETE) {
      // Set length to current - 1 (trim last character)
      textBuilder.setLength(max(textBuilder.length() - 1, 0));
    } else if (keyCode >= (int)' ' && keyCode < 127) {
      // Ensure that the key is a valid character
      textBuilder.append(key);
    }
    
    cachedText = textBuilder.toString();
  }
  
  void display() {
    
    if (contains(mouseX, mouseY)) {
      fill(focusBackground);
      stroke(focusForeground);
    } else {
      fill(background);
      stroke(foreground);
    }
    rectMode(CORNER);
    rect(loc.x, loc.y, size.x, size.y);
    
    textAlign(CENTER, CENTER);
    fill(foreground);
    if (!hasFocus && textBuilder.length() == 0) { // If no text, display hint
      text(hint, loc.x + size.x / 2, loc.y + size.y / 2);
    } else {
      PVector cursorLoc = new PVector(loc.x + size.x / 2, loc.y + size.y / 2);
      text(cachedText, cursorLoc.x, cursorLoc.y);
      
      // Move the cursor to the end and draw a blinking line if focused
      if (hasFocus && frameCount % 60 < 30) { // Limit to 60 frames, blink on half
      
        cursorLoc.add(textWidth(cachedText) / 2.0, 0); // Divide width by two since we're using CENTER align
        line(cursorLoc.x, cursorLoc.y - size.y / 6, cursorLoc.x, cursorLoc.y + size.y / 6);
      }
    }
  }
}