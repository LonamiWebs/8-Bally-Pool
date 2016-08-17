
GFrame frame;

void setup() {
  size(640, 360);
  frame = GetExample_GridFrame();
}

boolean show = true;
void draw() {
  background(120);
  if (show) {
    frame.update();
    frame.display();
  }
}

void keyPressed()
{
  if (key == 't') {
    show = !show;
  }
}