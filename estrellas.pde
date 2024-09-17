int numEstrellas = 200; // Número de estrellas
Estrella[] estrellas; // Array para almacenar las estrellas

void iniciarEstrellas() {
  estrellas = new Estrella[numEstrellas];
  for (int i = 0; i < numEstrellas; i++) {
    estrellas[i] = new Estrella(random(width), random(height));
  }
}

void dibujarEstrellasFondo() {
  background(0); // Limpiar el fondo antes de dibujar las estrellas
  for (Estrella estrella : estrellas) {
    estrella.actualizar1();
    estrella.mostrar1();
  }
}

class Estrella {
  float x, y; // Posición de la estrella
  float velocidad;
  
  Estrella(float x, float y) {
    this.x = x;
    this.y = y;
    this.velocidad = random(0.1, 0.5); // Velocidad aleatoria más lenta
  }
  
  void actualizar1() {
    x += velocidad; // Mover hacia la derecha
    if (x > width) {
      x = 0; // Volver al inicio si sale de la pantalla
    }
  }
  
  void actualizar2() {
    x += 0.04; // Mover hacia la derecha
    if (x > width) {
      x = 0; // Volver al inicio si sale de la pantalla
    }
  }
  
  void mostrar1() {
    stroke(255);
    strokeWeight(random(1,3)); // Tamaño ajustado de las estrellas
    point(x, y);
  }
  
  void mostrar2() {
    stroke(255);
    strokeWeight(2); // Tamaño ajustado de las estrellas
    point(x, y);
  }
}

void dibujarEstrellasJuego() {
  for (Estrella estrella : estrellas) {
    if(estrella.y < height-300f){
      estrella.actualizar2();
      estrella.mostrar2();
    }
  }
}
