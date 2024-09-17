void dibujarNave() {
  pushMatrix();
  translate(x, y);
  rotate(radians(angulo));
  imageMode(CENTER);
  image(naveImagenes[fireFrame], 0, 0, 20, 20);  // Tamaño reducido de la nave
  popMatrix();
}

void actualizarNave() {
  if (espacio && combustible > 0) {
    // Aplicar impulso basado en el ángulo
    vx += impulso * cos(radians(angulo));
    vy += impulso * sin(radians(angulo));
    
    // Reducir el combustible
    combustible -= consumo;
    if (combustible < 0) {
      combustible = 0;  // Evitar valores negativos
    }
    
    // Avanzar la animación del fuego
    fireFrame = (fireFrame + 1) % naveImagenes.length;
    
    if (!musicaEfecto.isPlaying()) {
      musicaEfecto.loop();
    }
  } else {
    // Si no está presionada la tecla, mostrar la primera imagen (sin fuego)
    fireFrame = 0;
    if (musicaEfecto.isPlaying()) {
      musicaEfecto.stop();
    }
  }
  
  if (izquierda) {
    angulo -= 2;  // Rotar a la izquierda
  }
  
  if (derecha) {
    angulo += 2;  // Rotar a la derecha
  }
  
  // Aplicar gravedad siempre hacia abajo
  vy += gravedad;
  
  // Actualizar la posición de la nave
  x += vx;
  y += vy;
  
  // Evitar que la nave salga por los lados
  if (x < 0) x = width;
  if (x > width) x = 0;
  
  // Actualizar altitud de la nave
  altitud = height - y;

  // Actualizar el tiempo transcurrido
  tiempoTranscurrido = (millis() - tiempoInicio) / 1000; // Tiempo transcurrido en segundos
}

void dibujarSuperficie() {
  float pasoX = width / (alturasTerreno.length - 1f);
  noFill();
  stroke(255, 255, 255);
  strokeWeight(3);
  beginShape();
  for (int i = 0; i < alturasTerreno.length; ++i) {
    float x = i * pasoX;
    float y = height - alturasTerreno[i];
    vertex(x, y);
  }
  endShape();
}
