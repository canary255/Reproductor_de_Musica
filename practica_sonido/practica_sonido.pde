
import ddf.minim.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;


Minim minim;
FilePlayer musica;
TickRate rateControl;
AudioOutput output;

float minutoActual = 0.0;
float segundoActual = 0.0;
boolean pause = false;
boolean menuVelocidad = false;
boolean menuVolumen = false;

String[] nombre;

PImage[] volumenImagen;
PImage siguiente,anterior,avanzar,retroceder;


int posicionLista;
int radio = 50;
int loopcount,tiempoMusica;
int volumen;
int volumenMusica;
float rate;
boolean negativo;
PImage[] background;



void setup()
{
  size(768, 480, P3D);
  
  posicionLista=0;
  minim = new Minim(this);
  output = minim.getLineOut(Minim.STEREO,2048);
  nombre = new String[6];
  nombre[0] = "groove.mp3";
  nombre[1] = "Astronomia - Tony Igy.mp3";
  nombre[2] = "Dr.Wily (Super Mario).mp3";
  nombre[3] = "Initial D - Deja vu.mp3";
  nombre[4] = "John Scatman - Scatman World.mp3";
  nombre[5] = "Shingeki no Kyojin Opening 5.mp3";
  musica = new FilePlayer(minim.loadFileStream(nombre[posicionLista]));
  rateControl = new TickRate(1f);
  rateControl.setInterpolation( true );
  musica.patch( rateControl ).patch( output );
  rate = 1.1;
  
  
  background = new PImage[6];
  background[0] = loadImage("groove.png");
  background[1] = loadImage("baile.jpg");
  background[2] = loadImage("mario_comunista.png");
  background[3] = loadImage("initial_d.jpg");
  background[4] = loadImage("scatman.jpg");
  background[5] = loadImage("Shingeki.jpg");
  
  volumenImagen = new PImage[5];
  volumenImagen[0] = loadImage("volume_logo.png");
  volumenImagen[1] = loadImage("volume_logo_mid.png");
  volumenImagen[2] = loadImage("volume_logo_low.png");
  volumenImagen[3] = loadImage("volume_logo_very_low.png");
  volumenImagen[4] = loadImage("volume_logo_mute.png");
  
  
  
  
  siguiente = loadImage("siguiente.png");
  anterior = loadImage("anterior.png");
  avanzar = loadImage("avanzar.png");
  retroceder = loadImage("retroceder.png");
  
  volumen = 0;
  
  musica.play();
  textFont(createFont("Arial", 12)); 
  tiempoMusica = millis();
  
  println((int)(musica.getMetaData().length()/1000)/60 +":"+ (musica.getMetaData().length()/1000)%60);
}


void draw()
{
  background[posicionLista].resize(width,height);
  background(background[posicionLista]);
  
  rateControl.value.setLastValue(rate);
  output.setGain(volumen);  //-70 = 0 real
  
  fill(0x25,0x28,0x50);
  noStroke();
  rect(0,height-100,width,height,10);
  
  stroke(255);
  ellipse(width/2,height-50,50,50);
  controlaPlayPause();
  muestraVelocidad();
  muestraVolumen();
  muestraLogos();
  String nombreCancion = musica.getMetaData().fileName();
  if(nombreCancion.length() > 20){
    text(nombreCancion.substring(0,20)+"...",32,height-50);
  } else {
  text(nombreCancion,32,height-50);
  }
  
  
  if(!musica.isPlaying() && !pause){
    musica.loop();
    segundoActual=0;
    minutoActual=0;
  }
     
  
  for(int i = 0; i < output.bufferSize() - 1; i++)
  {
    stroke(255,0,0);
    line(i, (height/2)-25+ output.left.get(i)*50,  i+1, (height/2)-25  + output.left.get(i+1)*50);
    line(i, (height/2)+25 + output.right.get(i)*50, i+1, (height/2)+25 + output.right.get(i+1)*50);
  }
  fill(255);
  float x = map(musica.position(), 0, musica.length(), 0, width);
  line(x, height/2 - 100, x, height/2 + 100);
  
   minutoActual=(int)(musica.position()/1000)/60;
   segundoActual=(int)(musica.position()/1000)%60;
  
  if(musica.isPlaying()  && minutoActual >= (int)(musica.getMetaData().length()/1000)/60 && segundoActual >= (int)(musica.getMetaData().length()/1000)%60){
    minutoActual=(int)(musica.getMetaData().length()/1000)/60;
    segundoActual=(int)(musica.getMetaData().length()/1000)%60;
  }

  text((int) minutoActual+":"+nf((int)segundoActual,2)
  +"/"+(int)(musica.getMetaData().length()/1000)/60 +":"+ nf((musica.getMetaData().length()/1000)%60,2), width/4, height-50);
}

void keyPressed()
{
  if(negativo){
    if(key=='r' || key=='R'){
      background[posicionLista].filter(INVERT);
      negativo=false;
    }
  } else if(key=='r' || key=='R'){
    background[posicionLista].filter(INVERT);
    negativo = true;
  }
  
  if(keyCode==RIGHT){
    volumen+=10;
    if(volumen > 0)volumen = 0;
  } else if(keyCode==LEFT){
    volumen-=10;
    if(volumen < -70)volumen = -70;
  } if(keyCode==UP){
    volumen+=1;
    if(volumen > 0)volumen = 0;
  } if(keyCode==DOWN){
    volumen-=1;
    if(volumen < -70)volumen = -70;
  }
  
 if(key=='n' || key=='N'){  //Siguiente cancion
 
 } else if (key=='p' || key=='P'){  //cancion Anterior
 
 }
 
}


void mouseClicked(){
  println("X: "+mouseX + " Y: " + mouseY);
  
  //Caso play/pause
  if(mouseX > (width/2)-30 && mouseX < (width/2)+30 && mouseY < height-20 && mouseY > height-80){
    if(pause){
      pause=false;
      musica.play();
    } else  {
      pause=true;
      musica.pause();
    }
  }
  
  //Caso boton velocidad
  if( !menuVelocidad && mouseX > width-95 && mouseX < width-25 && mouseY < height-37 && mouseY > height-62){
    menuVelocidad = true;  //muestra menu
  } else if (menuVelocidad && mouseX > width-95 && mouseX < width-25 && mouseY < height-37 && mouseY > height-62){
    menuVelocidad = false; //oculta menu
  }
  
  //Caso elegir velocidades
  elegirVelocidad();
  cancionAnteriorSiguiente();
  cancionRetrocedeAvanza();
}


void controlaPlayPause(){
  if(pause){
    pushMatrix();
    fill(255);
    lights();
    triangle(width/2-7,height-60,width/2+10,height-50,width/2-7,height-40);
    fill(0,0,128);
    popMatrix();
  } else {
    pushMatrix();
    fill(255);
    lights();
    rect(width/2-14,height-63,10,25);
    rect(width/2+3,height-63,10,25);
    fill(0,0,128);
    popMatrix();
  }

}

void muestraVelocidad(){
  if(menuVelocidad){
      fill(25);
      rect(width-95,height-87,70,25);
      fill(255);
      text("x2",width-88,height-70);
      fill(50);
      rect(width-95,height-112,70,25);
      fill(255);
      text("x1.5",width-88,height-95);
      fill(75);
      rect(width-95,height-137,70,25);
      fill(255);
      text("x1.25",width-88,height-120);
      fill(100);
      rect(width-95,height-162,70,25);
      fill(255);
      text("x1",width-88,height-145);
      fill(125);
      rect(width-95,height-187,70,25);
      fill(255);
      text("x0.75",width-88,height-170);
      fill(150);
      rect(width-95,height-212,70,25);
      fill(255);
      text("x0.5",width-88,height-195);
      fill(175);
      rect(width-95,height-237,70,25);
      fill(255);
      text("x0.25",width-88,height-220);
      
      fill(0,0,200);
      rect(width-95,height-62,70,25);
      fill(255);
      text("Velocidad",width-88,height-45);
  } else {
      rect(width-95,height-62,70,25);
      fill(255);
      text("Velocidad",width-88,height-45);
  }
  if(rate==1.1)text("x1.0",width-70,height-20);
  else text("x"+rate,width-70,height-20);


}

void muestraVolumen(){   
     beginShape();
     noStroke();
     if(volumen >-10){
       texture(volumenImagen[0]);
     } else if (volumen >-35 && volumen <=-10){
       texture(volumenImagen[1]);
     } else if (volumen >-50 && volumen <=-35){
       texture(volumenImagen[2]);
     } else if (volumen >-70 && volumen <=-50){
       texture(volumenImagen[3]);
     } else if (volumen <=-70){
       texture(volumenImagen[4]);
     }
     vertex(width/1.32, height-64, 0, 0);
     vertex(width/1.32, height-44, 0, 204);
     vertex((width/1.32)+20, height-44, 198, 204);
     vertex((width/1.32)+20, height-64, 198, 0);
     endShape();
     
     text("Volumen: "+(volumen+70),(width/1.32)-18,height-20);
     text("↓ -1",(width/1.32)-30,height-54);
     text("↑ +1",(width/1.32)+30,height-54);
     text(" ← -10+ → ",(width/1.32)-18,height-80);
}

void elegirVelocidad(){
  if( menuVelocidad && mouseX > width-95 && mouseX < width-25 && mouseY < height-212 && mouseY > height-237){      //x0.25
    menuVelocidad = false; 
    rate=0.25;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-187 && mouseY >= height-212){  //x0.5
    menuVelocidad = false;
    rate=0.5;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-162 && mouseY >= height-187){  //x0.75
    menuVelocidad = false;
    rate=0.75;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-137 && mouseY >= height-162){  //x1
    menuVelocidad = false;
    rate=1.1;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-112 && mouseY >= height-137){  //x1.25
    menuVelocidad = false;
    rate=1.25;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-87 && mouseY >= height-112){  //x1.5
    menuVelocidad = false;
    rate=1.5;
  } else if (menuVelocidad && mouseX >= width-95 && mouseX <= width-25 && mouseY <= height-62 && mouseY >= height-87){  //x2
    menuVelocidad = false;
    rate=2;
  } else if (menuVelocidad && (mouseX < width-95 || mouseX > width-25 || mouseY > height-37 || mouseY < height-237)){  
    menuVelocidad = false;
  } 

}

void muestraLogos(){
    //anterior
    pushMatrix();
    beginShape();
    texture(anterior);
    noStroke();
    vertex(width/2-75, height-70, 0, 0);
    vertex(width/2-75, height-34, 0, 182);
    vertex(width/2-45, height-34, 187, 182);
    vertex(width/2-45, height-70, 187, 0);
    endShape();
    popMatrix();
     
     //siguiente
    pushMatrix();
    beginShape();
    texture(siguiente);
    noStroke();
    vertex(width/2+45, height-70, 0, 0);
    vertex(width/2+45, height-34, 0, 182);
    vertex(width/2+75, height-34, 187, 182);
    vertex(width/2+75, height-70, 187, 0);
    endShape();
    popMatrix();
     
    //retrocede
    pushMatrix();
    beginShape();
    texture(retroceder);
    noStroke();
    vertex(width/2-115, height-70, 0, 0);
    vertex(width/2-115, height-34, 0, 182);
    vertex(width/2-85, height-34, 187, 182);
    vertex(width/2-85, height-70, 187, 0);
    endShape();
    popMatrix();

    //avanza
    pushMatrix();
    beginShape();
    texture(avanzar);
    noStroke();
    vertex(width/2+85, height-70, 0, 0);
    vertex(width/2+85, height-34, 0, 182);
    vertex(width/2+115, height-34, 187, 182);
    vertex(width/2+115, height-70, 187, 0);
    endShape();
    popMatrix();
     
}


void cancionAnteriorSiguiente(){

  if( mouseX > width/2-75 && mouseX < width/2-45 && mouseY < height-34 && mouseY > height-70){      //anterior
    if(negativo){
      background[posicionLista].filter(INVERT);
      negativo=false;
    }
    posicionLista--;
    if(posicionLista < 0){
      posicionLista=nombre.length-1;
    }
    musica.pause();
    musica = new FilePlayer(minim.loadFileStream(nombre[posicionLista]));
    rateControl = new TickRate(1f);
    rateControl.setInterpolation( true );
    musica.patch( rateControl ).patch( output );
    if(!pause)musica.play();
    

  } else if (mouseX >= width/2+45 && mouseX <= width/2+75 && mouseY <= height-34 && mouseY >= height-70){  //siguiente
    if(negativo){
      background[posicionLista].filter(INVERT);
      negativo=false;
    }
    posicionLista++;
    if(posicionLista > nombre.length-1){
      posicionLista=0;
    }
    musica.pause();
    musica = new FilePlayer(minim.loadFileStream(nombre[posicionLista]));
    rateControl = new TickRate(1f);
    rateControl.setInterpolation( true );
    musica.patch( rateControl ).patch( output );
    if(!pause)musica.play();
    
  }


}

void cancionRetrocedeAvanza(){
  if(mouseX > width/2+85 && mouseX < width/2+115 && mouseY < height-34 && mouseY > height-70){      
    musica.skip(10000);
  } else if (mouseX > width/2-115 && mouseX < width/2-85 && mouseY < height-34 && mouseY > height-70){
    musica.skip(-10000);
  }
}
