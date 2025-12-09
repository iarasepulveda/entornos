
int CANT_TOTAL_INDICES = 1000;
class Receptor {

  ArrayList<Blob> blobsIn;
  ArrayList<Blob> blobs;
  int tiempo_para_borrar = -15;
  boolean habilitado = true;
  Indice[] indices;

  Receptor() {
    blobsIn = new ArrayList<Blob>();
    blobs = new ArrayList<Blob>();
    indices = new Indice[CANT_TOTAL_INDICES];

    for (int i = 0; i < CANT_TOTAL_INDICES; i++) {
      indices[i] = null;
    }
  }

  void cerrarBlobs() {
    habilitado = true;
  }

  // -------------------------------------------------------------
  // Actualiza los blobs y elimina los que deben borrarse
  // -------------------------------------------------------------
void actualizar() {
  synchronized (blobsIn) {
    // Actualizar todos los blobs
    for (int i = blobsIn.size() - 1; i >= 0; i--) {
      Blob b = blobsIn.get(i);
      if (b != null) {
        b.actualizar();

        // Si el blob debe ser eliminado
        if (b.borrar) {
          int cualIndice = b.id % CANT_TOTAL_INDICES;
          indices[cualIndice] = null;  // Borra referencia del índice
          blobsIn.remove(i);           // Borra el blob de la lista
        }
      }
    }
  }
}

  // -------------------------------------------------------------
  // Dibuja los blobs de manera segura
  // -------------------------------------------------------------
void dibujarBlobs(float w, float h) {
  synchronized (blobsIn) {
    for (Blob b : blobsIn) {
      if (b != null) b.dibujar(w, h);
    }
  }
}

  // -------------------------------------------------------------
  // Agrega o actualiza blobs a partir de los mensajes OSC
  // -------------------------------------------------------------
  void agregar(OscMessage mensaje) {
    synchronized (blobsIn) {
      if (habilitado) {
        habilitado = false;
        int id = int(mensaje.get(0).floatValue());
        println(" → Agregando blob ID:", id);
        int indiceNuevo = id % CANT_TOTAL_INDICES;

        if (indices[indiceNuevo] != null) {
          // Ya existe un blob con ese índice → actualizar
          Blob este = indices[indiceNuevo].elBlob;
          este.actualizarDatos(mensaje);
          este.actualizado = true;
          este.ultimaActualizacion = 0;
        } else {
          // Crear nuevo blob
          Blob nb = new Blob();
          nb.setID(id);
          nb.actualizarDatos(mensaje);
          nb.actualizado = true;
          blobsIn.add(nb);
          indices[indiceNuevo] = new Indice(id, nb);
        }
        habilitado = true;
      }
    }
  }

  // -------------------------------------------------------------
  // Verifica si hay blobs repetidos (opcional)
  // -------------------------------------------------------------
  boolean hayRepeticiones() {
    println("Buscando repeticiones -------------- ");
    boolean resultado = false;
    synchronized (blobsIn) {
      for (int i = 0; i < blobs.size() - 1; i++) {
        for (int j = i + 1; j < blobs.size(); j++) {
          if (blobs.get(i).id == blobs.get(j).id) {
            println(blobs.get(i).id + " ---> REPETIDO ");
            resultado = true;
          }
        }
      }
    }
    return resultado;
  }
}

// ==================================================

class Indice {
  int id;
  Blob elBlob;

  Indice(int id_, Blob cual_) {
    id = id_;
    elBlob = cual_;
  }
}
