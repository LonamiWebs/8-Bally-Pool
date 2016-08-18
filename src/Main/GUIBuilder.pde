
GFrame buildWelcomeFrame() {
  GFrame frame = new GFrame(0, 0, width, height);
  frame.setGrid(8, 11);  // Rows, columns
  
  // First go buttons
  GButton playLocalButton = new GButton(1, 5, 4, 1);
  playLocalButton.label = "Play locally";
  playLocalButton.addGObjectListener(new GObjectListener() {
    @Override
    public void mouseClicked(GObject sender) {
      playLocal();
    }
  });
  frame.addChild(playLocalButton);
  
  GButton hostButton = new GButton(6, 5, 2, 1);
  hostButton.label = "Host";
  frame.addChild(hostButton);
  
  GButton joinButton = new GButton(8, 5, 2, 1);
  joinButton.label = "Join";
  frame.addChild(joinButton);
  
  // Then some input
  GInput nameInput = new GInput(6, 2, 4, 1);
  nameInput.hint = "Enter your name...";
  nameInput.maxLength = 20;
  frame.addChild(nameInput);
  
  GInput hostInput = new GInput(6, 3, 4, 1);
  hostInput.hint = "Enter host IP (empty if hosting)...";
  hostInput.maxLength = 15; // xxx.xxx.xxx.xxx = 15
  frame.addChild(hostInput);
  
  return frame;
}