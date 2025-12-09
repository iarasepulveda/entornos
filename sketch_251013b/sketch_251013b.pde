// IMPORT THE SPOUT LIBRARY
import spout.*;
// DECLARE A SPOUT OBJECT
Spout spout;


import oscP5.*;
import netP5.*;
import java.util.ArrayList;
import processing.serial.*;

// --- OSC ---
int PUERTO = 12345;
Receptor receptor;
Pincel pincel;

// --- Cuadros y objetos ---
final float FLORES_X = 100;
final float FLORES_Y = 300;
final float FLORES_W = 400;
final float FLORES_H = 700;

ArrayList<Fruta> frutas;
ArrayList<Flor> flores;
ArrayList<Petalo> petalos;
ArrayList<Pez> peces;

void setup() {
   
  size(1920, 800);
   
  



  // Inicializar OSC
  setupOSC(PUERTO);
  setupUnityOSC(); 
  receptor = new Receptor();
  pincel = new Pincel();

  frutas = new ArrayList<Fruta>();
  flores = new ArrayList<Flor>();
  petalos = new ArrayList<Petalo>();
  peces = new ArrayList<Pez>();

  // Inicializar todos los objetos
  initObjetos();
  

}

void draw() {
  background(255);

  // --- dibujar cuadros ---
  noFill();
  stroke(180);
  strokeWeight(3);
  rect(FLORES_X, FLORES_Y, FLORES_W, FLORES_H);
  rect(600, 100, 700, 250);   // cuadro superior
  rect(1350, 300, 400, 700);  // cuadro derecho

  receptor.actualizar();

  // actualizar pincel si hay blob
  Blob blobPincel = detectarLAPIZ(receptor.blobsIn);
  if (blobPincel != null) pincel.actualizarDesdeBlob(blobPincel);
  pincel.dibujar();

  // actualizar y dibujar frutas
  for (Fruta f : frutas) f.actualizar(pincel);
  for (Fruta f : frutas) f.dibujar();

  // actualizar y dibujar flores
  for (Flor f : flores) f.actualizar(pincel);
  for (Flor f : flores) f.dibujar();

  // actualizar y dibujar pétalos que caen
  for (int i = petalos.size()-1; i >= 0; i--) {
    Petalo p = petalos.get(i);
    p.actualizar();
    p.dibujar();
  }

  // dibujar soga
  noFill();
  stroke(80);
  strokeWeight(3);
  beginShape();
  for (float x = 600; x <= 1300; x += 20) {
    float y = 100 + sin(map(x, 600, 1300, 0, PI)) * 20;
    vertex(x, y);
  }
  endShape();

  // actualizar y dibujar peces
  for (Pez p : peces) p.actualizar(pincel);
  for (Pez p : peces) p.dibujar();

  receptor.dibujarBlobs(width, height);


// enviar datos a Unity
enviarPincelAUnity();


}

// --- Inicialización de objetos usando sus clases ---
void initObjetos() {
  // frutas con ID
  frutas.add(new Fruta(0, 1450, 550));
  frutas.add(new Fruta(1, 1600, 450));
  frutas.add(new Fruta(2, 1500, 350));

  // flores
  for (int i = 0; i < 4; i++) {
    float fx = FLORES_X + FLORES_W / 2;
    float fy = FLORES_Y + 150 + i * 150;
    flores.add(new Flor(i, fx, fy)); // le pasamos el id (i)
  }


  // peces con ID
  float margen = 30 / 2;
  float inicioX = 600 + margen;
  float finX = 1300 - margen;
  float baseY = 100;
  for (int i = 0; i < 9; i++) {
    float x = map(i, 0, 8, inicioX, finX);
    float ySoga = baseY + sin(map(i, 0, 8, 0, PI)) * 20;
    float yPez = ySoga + 80;
    peces.add(new Pez(i, x, yPez, ySoga));
  }
}

// --- Detección de lápiz ---
Blob detectarLAPIZ(ArrayList<Blob> blobs) {
  Blob mejor = null;
  float maxArea = -1;

  for (Blob b : blobs) {
    if (b != null && !b.salio && b.area > maxArea) {
      mejor = b;
      maxArea = b.area;
    }
  }
  return mejor;
}
