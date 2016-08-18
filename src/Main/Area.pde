
class Area {
  
  // Fields
  float x, y; // Location
  float w, h; // Width, height
  
  // Constructors
  Area() { }
  
  Area(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  Area(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  // Move utils
  void move(float xOff, float yOff) {
    x += xOff;
    y += yOff;
  }
  
  void move(Vec2 offset) {
    x += offset.x;
    y += offset.y;
  }
  
  void locate(float newX, float newY) {
    x = newX;
    y = newY;
  }
  
  // Size utils
  void resize(float newWidth, float newHeight) {
    w = newWidth;
    h = newHeight;
  }
  
  // Get location and size
  Vec2 loc() { return new Vec2(x, y); }
  Vec2 size() { return new Vec2(w, h); }
  
  Area copy() {
    return new Area(x, y, w, h);
  }
  
  // Display
  void display() {
    rectMode(CORNER);
    rect(x, y, w, h);
  }
  
  // Checks
  boolean contains(float _x, float _y) {
    return (_x > x     &&
            _y > y     &&
            _x < x + w &&
            _y < y + h);
  }
}