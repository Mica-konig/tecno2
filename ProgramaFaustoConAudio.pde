import oscP5.*;

PImage cuadrado;
float centrox;
float centroy;
PGraphics fondo;
PGraphics figura;
OscP5 osc;

float amp = 0;
float pitch = 0;
GestorSenial intensidad;
GestorSenial altura;
float minimaIntensidad = 70;
float maximaIntensidad = 100; 

float minimaAltura = 50;
float maximaAltura = 80; 
void setup() {
  size(1000, 600);
  osc = new OscP5(this, 12345);
  cuadrado = loadImage("cuadrado.png");
  background(0);

  intensidad = new GestorSenial( minimaIntensidad, maximaIntensidad );
  altura = new GestorSenial( minimaAltura, maximaAltura );

  fondo = createGraphics(width, height);
  figura = createGraphics(width, height);
  centrox = width/2;
  centroy = height/2;
}

void draw() {
  float px = random(width);
  float py = random(height);  

  intensidad.actualizar( amp );
  println(pitch);
  altura.actualizar( pitch );

  boolean haySonido = intensidad.filtradoNorm() > 0.2;

  if (haySonido) {
    float fracuenciaFiltrada = altura.filtradoNorm(); 
    if (fracuenciaFiltrada<0.5) {
      fondo.beginDraw();

      float d  = abs(py-centroy);
      float factor = map(d, 0, height/2, 0, 2);
      if (factor >1) {
        color celeste = color(30, 255, 255);
        color naranja = color(255, 80, 200);
        color mezclaFondo = lerpColor( naranja, celeste, factor-1);
        fondo.tint(mezclaFondo);
      } else {
        color naranja = color(100, 200, 50);
        color blanco = color(255, 255, 255);
        color mezclaFondo = lerpColor( blanco, naranja, factor);
        fondo.tint(mezclaFondo);
      }

      fondo.image(cuadrado, px, py, cuadrado.width*random(1.0, 1.5), cuadrado.height*random(1.0, 1.5));
      fondo.endDraw();
    } else {
      float figurax = random(width);
      float figuray = random(centroy-100, centroy+100);

      figura.beginDraw();

      float alturaMaxima = noise(figurax*0.1)*70;
      if (figuray<centroy+alturaMaxima&& figuray>centroy-alturaMaxima) {
        figura.tint(0);
        figura.image(cuadrado, figurax, figuray, cuadrado.width*random(0.2, 0.8), cuadrado.height*random(0.2, 0.8));
      } else if (figuray<centroy+alturaMaxima*2 && figuray>centroy-alturaMaxima*2) {
        figura.tint(#FF8000);
        figura.image(cuadrado, figurax, figuray, cuadrado.width*random(0.2, 0.8), cuadrado.height*random(0.2, 0.8));
      }
      figura.endDraw();
    }
  }
  image(fondo, 0, 0);
  image(figura, 0, 0);
}
void  oscEvent (OscMessage m) {
     // println(m);

  if (m.addrPattern().equals("/amp")) {
    amp = m.get(0).floatValue();
  } else if (m.addrPattern().equals("/pitch")) {
    
    //if(m.typetag().equals("i")){
//println(m.get(0));
    //}
    pitch = m.get(0).floatValue();
  }
}
