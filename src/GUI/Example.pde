
GFrame GetExample_GridFrame() {
  GFrame frame = new GFrame(20, 20, width - 40, height - 40); // -40 for padding
  frame.setGrid(5, 7);
  
  GButton test1 = new GButton(1, 1, 2, 1);
  test1.label = "Press T to toggle view";
  test1.event = new GObjectEvent() {
    @Override
    public void onClick(GObject sender) {
      println("The first button was clicked");
    }
  };
  frame.addChild(test1);
  
  GButton test2 = new GButton(4, 1, 2, 1);
  test2.event = new GObjectEvent() {
    @Override
    public void onClick(GObject sender) {
      println("The second button was clicked");
    }
  };
  frame.addChild(test2);
  
  GInput test3 = new GInput(1, 3, 5, 1);
  frame.addChild(test3);
  
  return frame;
}