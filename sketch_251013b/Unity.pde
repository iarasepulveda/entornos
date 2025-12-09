import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress unityAddr;

void setupUnityOSC() {
  oscP5 = new OscP5(this, 12345); // puerto local (puede ser diferente)
  unityAddr = new NetAddress("127.0.0.1", 9000); // puerto de Unity
}

// Nueva función en Processing
void enviarPincelAUnity() {
  // 'pincel' es la variable que ya tienen y que sigue al blob
  if (pincel != null) {
    OscMessage msg = new OscMessage("/pincel/pos");
    msg.add(pincel.x); // Envía la coordenada X del pincel en píxeles
    msg.add(pincel.y); // Envía la coordenada Y del pincel en píxeles
    oscP5.send(msg, unityAddr);
  }
}
