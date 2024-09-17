void displayInfo(boolean zoom) {
  fill(255);

  if (zoom) {
    textSize(5);
    // Ajustar la posición de los mensajes relativos al área de zoom
    float textoXDerecha = x + (width / (escalaZoom * 2)) * 1;  // Ajuste en X respecto a la cámara (lado derecho)
    float textoXIzquierda = x - (width / (escalaZoom * 2)) * 1.18;  // Ajuste en X respecto a la cámara (lado izquierdo)
    float textoY = y - (height / (escalaZoom * 2)) * 1.2;  // Ajuste en Y respecto a la cámara (parte superior)

    // Flechas indicadoras de dirección horizontal y vertical
    String direccionHorizontal = vx > 0 ? "→" : "←";
    text("Velocidad horizontal: " + abs(int(vx * 100)) + "m/s  " + direccionHorizontal, textoXDerecha, textoY);  // Velocidad horizontal

    String direccionVertical = vy > 0 ? "↓" : "↑";
    text("Velocidad vertical: " + abs(int(vy * 100)) + "m/s  " + direccionVertical, textoXDerecha - 3.5, textoY + 7);  // Velocidad vertical
    
    // Mostrar tiempo transcurrido, combustible y altitud
    text("Tiempo: " + tiempoTranscurrido + " segundos", textoXIzquierda, textoY);  
    text("Combustible: " + combustible, textoXIzquierda - 3.5, textoY + 7);
    text("Altitud: " + int(altitud) + " mts", textoXDerecha - 14, textoY + 14);
  } else {
    textSize(16);
    // Mostrar los mensajes en la vista completa global
    String direccionHorizontal = vx > 0 ? "→" : "←";
    text("Velocidad horizontal: " + abs(int(vx * 100)) + "m/s  " + direccionHorizontal, width * 0.905, 20);  // Velocidad horizontal

    String direccionVertical = vy > 0 ? "↓" : "↑";
    text("Velocidad vertical: " + abs(int(vy * 100)) + "m/s  " + direccionVertical, width * 0.9, 40);  // Velocidad vertical
    
    // Mostrar tiempo transcurrido, combustible y altitud
    text("Tiempo: " + tiempoTranscurrido + " segundos", width * 0.1, 20);  
    text("Combustible: " + combustible, width * 0.1, 40);
    text("Altitud: " + int(altitud) + " mts", width * 0.88, 60);
  }
}

void displayPantallaInicio() {
  dibujarEstrellasFondo();
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Luna Lander", width / 2, height / 2 - 40);
  textSize(25);
  text("Javier Llano", width / 2, 55);
  text("Realidad Virtual - Ingeniería Mecatrónica - 2024", width / 2, 80);
  textSize(20);
  text("Presione ENTER para comenzar", width / 2, height / 2 + 20);
  textSize(20);
  text("Debe aterrizar la nave en una superficie plana a una velocidad vertical menor de 20m/s", width / 2, height / 2 + 80);
  textSize(20);
  text("Use las teclas derecha e izquierda para rotar la nave y espacio para activar el motor de avance", width / 2, height / 2 + 100);
}

void iniciarAudio() {
  musicaInicio = new SoundFile(this, "inicio.mp3");
  musicaInicio.loop(); // Reproduce el audio en bucle
  musicaEfecto = new SoundFile(this, "efecto.mp3");
}

void displayEndMessage() {
  dibujarEstrellasFondo();
  fill(255);
  textAlign(CENTER);
  textSize(32);
  if (musicaEfecto.isPlaying()) {
    musicaEfecto.stop();
  }
  if (chocado) {
    text("¡Nave destruida!", width / 2, height / 2 - 20);
  } else if (aterrizado) {
    text("¡Aterrizaje exitoso!", width / 2, height / 2 - 20);
  }
  textSize(20);
  text("Presione ENTER para reiniciar el juego", width / 2, height / 2 + 20);
}
