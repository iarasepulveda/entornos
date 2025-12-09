class Pez {
  int id;             // ID único del pez
  float x, y;         // posición actual
  float ySoga;        // altura de la soga (límite superior)
  float largo = 60;
  float alto = 30;
  
  boolean colgado = true; // empieza colgado
  float vx, vy;           // velocidad cuando nada libre
  float tOffset;          // desplazamiento de tiempo para movimiento ondulatorio

  Pez(int id_, float x_, float y_, float ySoga_) {
    id = id_;
    x = x_;
    y = y_;
    ySoga = ySoga_;
    tOffset = random(0, TWO_PI); // cada pez distinto
  }

  void actualizar(Pincel p) {
    if (colgado) {
      float d = dist(x, y, p.x, p.y);
      if (d < 50) {  
        colgado = false;
        vx = random(-1, 1);
        vy = random(1, 3);
      }
    } else {
      y += vy;
      x += sin(frameCount * 0.05 + tOffset) * 2;
      vy += sin(frameCount * 0.03 + tOffset) * 0.1;

      if (x < 600 + alto/2) x = 600 + alto/2;
      if (x > 1300 - alto/2) x = 1300 - alto/2;

      if (y < ySoga + 30) {
        y = ySoga + 30;
        vy = abs(vy);
      }

      vx += random(-0.05, 0.05);
      vy += random(-0.05, 0.05);
      vx = constrain(vx, -3, 3);
      vy = constrain(vy, 0.5, 3);
    }
  }

  void dibujar() {
    if (colgado) {
      stroke(80);
      line(x, ySoga, x, y - largo/2);

      noStroke();
      fill(10, 150, 200);
      ellipse(x, y, alto, largo);

      fill(0);
      triangle(x - alto/2, y - largo/2 - 20,
               x + alto/2, y - largo/2 - 20,
               x, y - largo/2);
    } else {
      pushMatrix();
      translate(x, y);
      float ang = map(sin(frameCount * 0.05 + tOffset), -1, 1, -PI/6, PI/6);
      rotate(ang);
      noStroke();
      fill(10, 150, 200);
      ellipse(0, 0, largo, alto);

      fill(0);
      triangle(largo/2, 0, largo/2 + 15, -10, largo/2 + 15, 10);
      popMatrix();
    }
  }

  // enviar datos a Unity 
  void enviarAUnity() {
    OscMessage msg = new OscMessage("/pez");
    msg.add(id);
    msg.add(x);
    msg.add(y);
    msg.add(colgado ? 1 : 0); // 1 si colgado, 0 si nadando libre
    oscP5.send(msg, unityAddr);
  }
}
