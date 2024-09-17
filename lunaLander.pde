import processing.sound.*;
SoundFile musicaInicio;
SoundFile musicaEfecto;

PImage[] naveImagenes;      // Arreglo para las imágenes de la nave
int fireFrame = 0;        // Índice para la animación del fuego

int tiempoInicio;
int tiempoTranscurrido;
float altitud; 
float[] alturasTerreno;
float x, y;
float combustible;  
float consumo = 0.5;  // Cantidad de combustible consumido
float vx, vy;              // Velocidades
float angulo;               // Ángulo de rotación de la nave
float impulso;              // Fuerza de impulso
boolean izquierda, derecha, espacio;   // Control de teclas

float gravedad = 0.001;      // Gravedad
boolean aterrizado = false;
boolean chocado = false;
boolean juegoTerminado = false;
boolean juegoIniciado = false;

float distanciaZoom = 310f;  // Distancia en la que se activa el zoom
float escalaZoom = 5.5;     // Factor de escala para el zoom
boolean zoomActivo = false;

void setup() {
  size(1200, 600, P3D);
  iniciarJuego();
  iniciarEstrellas(); // Inicializa las estrellas
  iniciarAudio();
}

void draw() {
  if (!juegoIniciado) {
    // Mostrar la pantalla de inicio con fondo de estrellas
    displayPantallaInicio();
  } else {
    background(0, 0, 0);
    
    // Dibujar el terreno
    dibujarSuperficie();
    
    // Actualizar la nave si no ha aterrizado o chocado
    if (!aterrizado && !chocado) {
      actualizarNave();
      checkColision();
    }
    dibujarEstrellasJuego();
    
    // Activar el zoom si la nave está cerca de la franja y descendiendo
    if (height-y < distanciaZoom) {
      activarZoom();
    } else {
      desactivarZoom();
    }
    
    // Dibujar la nave
    dibujarNave();
    
    // Mostrar las velocidades en x y y
    if (zoomActivo) {
      displayInfo(zoomActivo);  // Los mensajes siguen el área de enfoque de la cámara
    } else {
      displayInfo(zoomActivo);  // Los mensajes están fijos en la pantalla
    }
    
    // Mostrar el mensaje final y opción de reinicio si el juego ha terminado
    if (juegoTerminado) {
      desactivarZoom();
      displayEndMessage();
    }
  }
}

// Inicializar el juego
void iniciarJuego() {
  
  int numPuntos = 100;  // Número total de puntos para definir el terreno
  alturasTerreno = new float[numPuntos];
  
  // Rango de altura para los puntos del terreno
  float alturaMinima = 50f;
  float alturaMaxima = 300f;
  
  // Generar los puntos aleatoriamente dentro del rango
  for (int i = 0; i < numPuntos; i++) {
    alturasTerreno[i] = random(alturaMinima, alturaMaxima);
  }

  int numPlanos = 7;  // Número de áreas planas que queremos crear
  int longitudPlano = 2;  // Cantidad de puntos consecutivos que serán planos
  
  for (int i = 0; i < numPlanos; i++) {
    int puntoInicio = int(random(0, numPuntos - longitudPlano));  // Seleccionar un punto inicial aleatorio
    float alturaPlano = alturasTerreno[puntoInicio];  // Tomar la altura del punto inicial
    // Repetir esa altura en los puntos siguientes para crear la zona plana
    for (int j = 0; j < longitudPlano; j++) {
      alturasTerreno[puntoInicio + j] = alturaPlano;
    }
  }
  
  // Asegurar que los puntos más altos del terreno estén bajo una franja
  float alturaMaximaTerreno = height * 0.8;
  for (int i = 0; i < alturasTerreno.length; i++) {
    if (alturasTerreno[i] > alturaMaximaTerreno) {
      alturasTerreno[i] = alturaMaximaTerreno;  // Limitar la altura de los puntos
    }
  }
  
  // Inicializar la nave en una posición aleatoria por encima de los puntos más altos del terreno
  x = random(width);
  y = random(alturaMaximaTerreno / 2);  // Posiciona la nave en la mitad superior de la franja
  
  // Inicializar velocidades y otras propiedades de la nave
  vx = 0;
  vy = 0;
  angulo = 0;  // Comienza en horizontal
  impulso = 0.003;
  combustible = 1000;  // Iniciar con 1000 unidades de combustible

  
  // Cargar imágenes de la nave
  naveImagenes = new PImage[6];
  for (int i = 0; i < naveImagenes.length; i++) {
    naveImagenes[i] = loadImage("nave" + i + ".png");
  }
  
  // Reiniciar estado del juego
  aterrizado = false;
  chocado = false;
  juegoTerminado = false;
}

// Verificar colisiones
void checkColision() {
  float pasoX = width / (alturasTerreno.length - 1f);
  
  for (int i = 0; i < alturasTerreno.length - 1; i++) {
    float x1 = i * pasoX;
    float y1 = height - alturasTerreno[i];
    float x2 = (i + 1) * pasoX;
    float y2 = height - alturasTerreno[i + 1];
    
    // Verificar si la nave colisiona con el segmento de terreno
    if (lineaIntersecaNave(x1, y1, x2, y2)) {
      // Verificar si el terreno es plano
      boolean terrenoPlano = (y1 == y2);
      // Condiciones de choque o aterrizaje
      if (!terrenoPlano || vy*100 > 20 || angulo > -75 || angulo < -105) {
        chocado = true; // Choque
      } else {
        aterrizado = true;  // Aterrizaje exitoso
      }
      juegoTerminado = true; // Final del juego
      break;
    }
  }
}

void activarZoom() {
  if (!zoomActivo) {
    zoomActivo = true;
  }
  
  // Ajustar la vista para hacer zoom en la nave
  float cameraZ = (height / 2) / tan(radians(45) / 2) / escalaZoom;  // Ajustar el zoom
  camera(x, y, cameraZ, x, y, 0, 0, 1, 0);  // Configurar la cámara para seguir a la nave
}

void desactivarZoom() {
  if (zoomActivo) {
    zoomActivo = false;
  }
  
  // Restaurar la vista del terreno completo
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
}

boolean lineaIntersecaNave(float x1, float y1, float x2, float y2) {
  // Aproximación simple: revisa si la nave está por debajo del terreno en x, y.
  float fondoNaveY = y + 5;  // Parte inferior de la nave
  return (x > x1 && x < x2 && fondoNaveY > lerp(y1, y2, (x - x1) / (x2 - x1)));
}

void keyPressed() {
  if (keyCode == LEFT) {
    izquierda = true;
  } 
  if (keyCode == RIGHT) {
    derecha = true;
  }
  if (keyCode == 32) {
    espacio = true;
  }
  if (keyCode == ENTER) {
    musicaInicio.stop();
    if (juegoTerminado) {
      iniciarJuego();
    } else {
      juegoIniciado = true; // Comenzar el juego
    }
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    izquierda = false;
  }
  if (keyCode == RIGHT) {
    derecha = false;
  }
  if (keyCode == 32) {
    espacio = false;
  }
}
