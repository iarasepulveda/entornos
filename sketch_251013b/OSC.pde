// Variables globales para OSC
OscP5 osc;
OscProperties propiedadesOSC;
ArrayList<OscMessage> mensajes;

void setupOSC(int puerto) {
  propiedadesOSC = new OscProperties();
  propiedadesOSC.setDatagramSize(10000);
  propiedadesOSC.setListeningPort(puerto);
  osc = new OscP5(this, propiedadesOSC);
  mensajes = new ArrayList<OscMessage>();
} 

// Función que se llama automáticamente cuando llega un mensaje OSC
void oscEvent(OscMessage m) {
  if (m.addrPattern().equals("/bblobtracker/blobs")) {
    // Acceso seguro a la lista de blobs
    synchronized (receptor.blobsIn) {
      receptor.agregar(m);
    }
  }
}
