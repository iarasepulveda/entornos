import oscP5.*;

OscP5 oscP5;
NetAddress unityAddr;

void setupUnityOSC() {
  oscP5 = new OscP5(this, 12345); // puerto local (puede ser diferente)
  unityAddr = new NetAddress("127.0.0.1", 9000); // puerto de Unity
}

// Nueva función en Processing
void enviarPincelAUnity() {
  if (pincel != null) {

    float normX = pincel.x / float(width);
    float normY = pincel.y / float(height);

    // IMPORTANTE: Unity y Processing tienen el eje Y invertido
    normY = 1.0 - normY;

    OscMessage msg = new OscMessage("/pincel/pos");
    msg.add(normX);
    msg.add(normY);

    oscP5.send(msg, unityAddr);
  }
}
