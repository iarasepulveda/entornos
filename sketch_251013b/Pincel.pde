class Pincel {
  float x, y;

  void actualizarDesdeBlob(Blob b) {
    x = b.centerX * width;
    y = b.centerY * height;
  }

  void dibujar() {
    fill(255, 0, 200); // color del lápiz rosa
    noStroke();
    ellipse(x, y, 20, 20);
  }
}
