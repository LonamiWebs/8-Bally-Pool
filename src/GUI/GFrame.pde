
class GFrame extends GObject {
  
  private ArrayList<GObject> children;
  
  // 0 if we're not using rows or cols
  int rows;
  int cols;
  
  // Cache the row and column size if the grid is set
  float rowSize;
  float colSize;
  
  GFrame(float x, float y, float w, float h) {
    super(x, y, w, h);
    
    children = new ArrayList<GObject>();
  }
  
  // Sets a grid. All later placed objects will be placed by indicating
  // a grid (row, col) index instead of their positions
  // Note that this will NOT update previously added childs
  void setGrid(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    
    if (rows > 0 && cols > 0) {
      rowSize = height / (float)rows;
      colSize = width / (float)cols;
    }
  }
  
  void addChild(GObject child) {
    // If using a grid, update their size and location
    if (rows > 0 && cols > 0) {
      child.loc.x *= colSize;
      child.loc.y *= rowSize;
      child.size.x *= colSize;
      child.size.y *= rowSize;
    }
    
    child.parent = this;
    children.add(child);
  }
  
  void onClick() {
    // Notify all the child that they've lost focus
    clearFocus();
  }
  
  void clearFocus() {
    for (GObject child : children) {
      child.hasFocus = false;
    }
  }
  
  void update() {
    super.update();
    for (GObject child : children) {
      child.update();
    }
  }
  
  void display() {
    for (GObject child : children) {
      child.display();
    }
  }
}