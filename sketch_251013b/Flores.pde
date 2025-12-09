class Flor {
  int id; // nuevo: id único
  float x, y;
  float radioCentro = 25;
  int totalPetalos = 8;
  ArrayList<PetaloFlor> misPetalos;

  Flor(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
    misPetalos = new ArrayList<PetaloFlor>();

    // crear pétalos alrededor del centro
    for (int i = 0; i < totalPetalos; i++) {
      float ang = TWO_PI / totalPetalos * i;
      float px = x + cos(ang) * 45;
      float py = y + sin(ang) * 45;
      misPetalos.add(new PetaloFlor(px, py, ang));
    }
  }

  void actualizar(Pincel pincel) {
    for (int i = misPetalos.size()-1; i >= 0; i--) {
      PetaloFlor pf = misPetalos.get(i);
      float d = dist(pincel.x, pincel.y, pf.x, pf.y);
      if (d < 25) {
        petalos.add(new Petalo(pf.x, pf.y));
        misPetalos.remove(i);
      }
    }
  }

  void dibujar() {
    for (PetaloFlor pf : misPetalos) pf.dibujar();
    fill(255, 220, 0);
    stroke(0);
    ellipse(x, y, radioCentro*2, radioCentro*2);
  }

  // --- NUEVO: enviar datos a Unity ---
  void enviarAUnity() {
    OscMessage msg = new OscMessage("/flor");
    msg.add(id);
    msg.add(x);
    msg.add(y);
    msg.add(misPetalos.size()); // pétalos que quedan
    oscP5.send(msg, unityAddr);
  }
}

class PetaloFlor {
  float x, y, ang;
  float w = 30;
  float h = 45;

  PetaloFlor(float x_, float y_, float ang_) {
    x = x_;
    y = y_;
    ang = ang_;
  }

  void dibujar() {
    pushMatrix();
    translate(x, y);
    rotate(ang);
    fill(255);
    stroke(0);
    ellipse(0, 0, w, h);
    popMatrix();
  }
}

class Petalo {
  float x, y;
  float vy = random(1, 2);
  float vx = random(-0.3, 0.3);
  float rot = random(TWO_PI);
  float vrot = random(-0.05, 0.05);
  float size = 35;

  Petalo(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void actualizar() {
    x += vx;
    y += vy;
    vy += 0.05; // gravedad
    rot += vrot;
  }

  void dibujar() {
    pushMatrix();
    translate(x, y);
    rotate(rot);
    fill(255);
    stroke(0);
    ellipse(0, 0, size * 0.7, size);
    popMatrix();
  }
}
