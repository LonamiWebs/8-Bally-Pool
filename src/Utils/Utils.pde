
TextureGenerator generator;
float ballRadius = 48;

void setup() {
  size(640, 360);
  
  generator = new TextureGenerator();
  for (int i = 0; i < 16; i++) {
    println("Generating ball number " + i);
    saveImage(
              generator.generateBallTexture(i, ballRadius),
              "ball_" + i + ".png");
  }
}

void draw() {
  fill(0);
  image(generator.generateTableTexture(width, height, noiseStep, seed), 0, 0);
  text("Mouse X = noise step; Mouse Y = seed; Click to save", 10, 20);
  
  if (!moved) {
    text("Image saved under " + savePath, 10, height - 20);
  }
}

boolean moved = true;

float noiseStep;
float seed;
void mouseMoved() {
  moved = true;
  noiseStep = map(mouseX, 0, width, 1, 200);
  seed = map(mouseY, 0, height, 0, 10000);
}

void mousePressed() {
  moved = false; // notify that it's now still
  saveImage(generator.generateTableTexture(width, height, noiseStep, seed), "table.png");
}

String savePath = "../Main/data/img/";
void saveImage(PGraphics image, String name) {
  image.save(savePath + name);
}