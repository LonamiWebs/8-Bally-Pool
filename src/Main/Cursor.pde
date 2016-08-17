
// Utility for writing
class Cursor {
  
  // Fields
  Vec2 location;
  private float textHeight;
  
  Cursor() {
    textAlign(LEFT, TOP);
    location = new Vec2();
  }
  
  Cursor(float x, float y) {
    this();
    location = new Vec2(x, y);
  }
  
  // Move cursor
  void locate(float x, float y) {
    location.x = x;
    location.y = y;
  }
  void move(float x, float y) {
    location.x += x;
    location.y += y;
  }
  
  // Text size
  float getPaddedHeight() {
    return textHeight * 1.2; // height + 20% padding
  }
  
  void setTextSize(float textSize) {
    textHeight = textSize;
    textSize(textSize);
  }
  
  // Typing, displaces the cursor location
  void type(String text) {
    text(text, location.x, location.y);
    location.x += textWidth(text);
  }
  
  void typeLine(String text) {
    text(text, location.x, location.y);
    newLine();
  }
  
  void typePrevLine(String text) {
    text(text, location.x, location.y);
    prevLine();
  }
  
  void type(String text, float textSize) {
    setTextSize(textSize);
    type(text);
  }
  
  void prevLine() {
    location.y -= getPaddedHeight();
  }
  
  void newLine() {
    location.y += getPaddedHeight();
  }
  
}