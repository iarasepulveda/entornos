class Fruta {
  int id;
  float x, y;
  float radio = 40;
  boolean cayendo = false;
  float vy = 0; // Esta variable ya no se usa para la física, pero no molesta
  int toques = 0;

  Fruta(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
  }

  void actualizar(Pincel pincel) {
    float d = dist(pincel.x, pincel.y, x, y);

    // Esta parte se queda igual: detecta el toque, cuenta
    // los golpes y produce el temblor.
    if (!cayendo && d < radio) {
      toques++;
      if (toques >= 10) {
        cayendo = true; // ¡Importante! Solo cambia el estado
      } else {
        // Temblor aleatorio
        x += random(-2, 2);
        y += random(-2, 2);
      }
    }

    // --- PARTE QUE CAMBIA! ---
    // Hemos eliminado por completo el bloque "if (cayendo)" que
    // contenía la gravedad y el rebote. Ahora, cuando 'cayendo'
    // es true, Processing simplemente lo informa, pero ya no
    // mueve la fruta.
    
    /* EL CÓDIGO BORRADO ERA ESTE:
    if (cayendo) {
      vy += 0.5;
      y += vy;
      if (y + radio > height) {
        y = height - radio;
        vy *= -0.6;
        if (abs(vy) < 1) {
          vy = 0;
        }
      }
    }
    */
  }

  void dibujar() {
    fill(255, 100, 0); // naranja / tipo fruta
    stroke(0);
    ellipse(x, y, radio * 2, radio * 2);
  }
}
