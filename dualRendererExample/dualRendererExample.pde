
void setup() {
  size(500, 500);

  // test
  DualRenderer dR = new DualRenderer(this, width, height, 2, sketchPath(System.currentTimeMillis() + ".pdf"));
  dR.beginDraw();
  dR.pushMatrix();
  dR.noStroke();
  dR.fillCMYK(1, 0, 0, 0);
  dR.rect(0, 0, width, height);
  dR.fillCMYK(0, 0, 0, 1);
  dR.rect(20, 20, width-40, height-40);
  dR.fillCMYK(0, 1, 0, 0);
  dR.rect(40, 40, width-80, height-80);
  dR.popMatrix();
  dR.endDraw();
  dR.dispose();
  background(0);
  image(dR.gra, 0, 0);
}

void draw() {
}

