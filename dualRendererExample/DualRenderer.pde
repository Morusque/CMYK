
public float mm(float pt) {// converts mm to PostScript points
  return pt * 2.83464567f;
}

int CMYKtoRGB(float c, float m, float y, float k) {// converts cmyk to rgb 
  float C = c * (1-k) + k;
  float M = m * (1-k) + k;
  float Y = y * (1-k) + k;
  float r = (1-C) * 255;
  float g = (1-M) * 255;
  float b = (1-Y) * 255;
  return color(r, g, b);
}

CMYKColor RGBtoCMYK (int r, int g, int b) {// converts rgb to cmyk
  float w1 = Math.max((r / 0xFF), (g / 0xFF));
  float w = Math.max(w1, (b / 0xFF));
  float c = (w - (r / 0xFF)) / w;
  float m = (w - (g / 0xFF)) / w;
  float y = (w - (b / 0xFF)) / w;
  float k = 1 - w;
  return new CMYKColor(c, m, y, k);
}

class DualRenderer {// contains both a cmyk pdf renderer and a rgb onscreen renderer and draws on both at once
  PDF pdf;
  PGraphics gra;
  float pxPP;
  PVector size;
  DualRenderer (PApplet p, float wInPixels, float hInPixels, float pixelsPerPoint, String out) {
    this.size = new PVector(wInPixels, hInPixels);
    this.pxPP = pixelsPerPoint;
    float wPoints = wInPixels/pxPP;
    float hPoints = hInPixels/pxPP;
    pdf = new PDF(p, wPoints, hPoints, out);
    gra = createGraphics(floor(wInPixels), floor(hInPixels), JAVA2D);
  }
  void beginDraw() {
    gra.beginDraw();
  }
  void endDraw() {
    gra.endDraw();
  }
  void pushMatrix() {
    pdf.pushMatrix();
    gra.pushMatrix();
  }
  void popMatrix() {
    pdf.popMatrix();
    gra.popMatrix();
  }  
  void translate(float x, float y) {
    pdf.translate(x, y);
    gra.translate(x, y);
  }
  void rotate(float r) {
    pdf.rotate(r);
    gra.rotate(r);
  }
  void noStroke() {
    pdf.noStroke();
    gra.noStroke();
  }
  void noFill() {
    pdf.noFill();
    gra.noFill();
  }
  void fill(int k) {
    pdf.fillK(0xFF-k);
    gra.fill(k);
  }
  void fill(int r, int g, int b) {
    CMYKColor convertedColor = RGBtoCMYK(r, g, b);
    pdf.fillCMYK(convertedColor.getCyan(), convertedColor.getMagenta(), convertedColor.getYellow(), convertedColor.getBlack());
    gra.fill(r, g, b);
  }
  void fill(int r, int g, int b, int a) {
    CMYKColor convertedColor = RGBtoCMYK(r, g, b);
    pdf.fillCMYK(convertedColor.getCyan(), convertedColor.getMagenta(), convertedColor.getYellow(), convertedColor.getBlack(), a);
    gra.fill(r, g, b, a);
  }
  void fillCMYK(float c, float m, float y, float k) {
    pdf.fillCMYK(c, m, y, k);
    gra.fill(CMYKtoRGB(c, m, y, k));
  }
  void fillCMYK(float c, float m, float y, float k, float a) {
    pdf.fillCMYK(c, m, y, k, a);
    color convertedColor = CMYKtoRGB(c, m, y, k);
    gra.fill(red(convertedColor), green(convertedColor), blue(convertedColor), a);
  }
  void stroke(int k) {
    pdf.strokeK(0xFF-k);
    gra.stroke(k);
  }
  void stroke(int r, int g, int b) {
    CMYKColor convertedColor = RGBtoCMYK(r, g, b);
    pdf.strokeCMYK(convertedColor.getCyan(), convertedColor.getMagenta(), convertedColor.getYellow(), convertedColor.getBlack());
    gra.stroke(r, g, b);
  }
  void stroke(int r, int g, int b, int a) {
    CMYKColor convertedColor = RGBtoCMYK(r, g, b);
    pdf.strokeCMYK(convertedColor.getCyan(), convertedColor.getMagenta(), convertedColor.getYellow(), convertedColor.getBlack(), a);
    gra.stroke(r, g, b, a);
  }
  void strokeCMYK(float c, float m, float y, float k) {
    pdf.strokeCMYK(c, m, y, k);
    gra.stroke(CMYKtoRGB(c, m, y, k));
  }
  void strokeCMYK(float c, float m, float y, float k, float a) {
    pdf.strokeCMYK(c, m, y, k, a);
    color convertedColor = CMYKtoRGB(c, m, y, k);
    gra.stroke(red(convertedColor), green(convertedColor), blue(convertedColor), a);
  }
  void rect(float x, float y, float w, float h) {
    pdf.rect(x/pxPP, y/pxPP, w/pxPP, h/pxPP);
    gra.rect(x, y, w, h);
  }
  void ellipse(float x, float y, float w, float h) {
    pdf.ellipse(x/pxPP, y/pxPP, w/pxPP, h/pxPP);
    gra.ellipse(x, y, w, h);
  }
  void triangle(float x1, float y1, float x2, float y2, float x3, float y3) {
    pdf.triangle(x1/pxPP, y1/pxPP, x2/pxPP, y2/pxPP, x3/pxPP, y3/pxPP);
    gra.triangle(x1, y1, x2, y2, x3, y3);
  }
  void beginShape() {
    pdf.beginShape();
    gra.beginShape();
  }
  void endShape() {
    pdf.endShape();
    gra.endShape();
  }
  void vertex(float x, float y) {
    pdf.vertex(x/pxPP, y/pxPP);
    gra.vertex(x, y);
  }
  void text(String txt, float x, float y) {
    pdf.text(txt, x/pxPP, y/pxPP);
    gra.text(txt, x, y);
  }
  void text(String txt, float x, float y, float x2, float y2) {
    pdf.text(txt, x/pxPP, y/pxPP, x2, y2);// it seemed logical to do x2/pxPP, y2/pxPP but apparently not
    gra.text(txt, x, y, x2, y2);
  }
  void textFont(PFont font) {
    pdf.textFont(font);
    gra.textFont(font);
  }
  void textAlign(int i, int j) {
    pdf.textAlign(i,j);
    gra.textAlign(i,j);
  }
  void textSize(float f) {
    pdf.textSize(f/pxPP);
    gra.textSize(f);
  }
  void strokeWeight(float f) {
    pdf.strokeWeight(f/pxPP);
    gra.strokeWeight(f);
  }
  void dispose() {
    pdf.dispose();
  }
}

