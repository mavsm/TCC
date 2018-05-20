int N = 50, M = 50;
Gerador G;
float stepX, stepY;

void setup() {
  size(300, 300);
  //TYPES:
  //  RANDOM_CHOICE - escolhe 'rodadas' vezes um ponto que vira buraco
  //  SINGLE_CHANCE - cada ponto tem uma chance x de ser buraco
  //  BINARY_PARTITION - separa binariamente o espaco
  G = new Gerador(N, M, 5, "BINARY_PARTITION");
  stepX = (float)width/N;
  stepY = (float)height/M;
  noLoop();
  noStroke();
  rectMode(CORNER);

  G.generate();
}

void draw() {
  //draws actually
  G.draw();
}

void keyPressed() {
  if (key == ' ') {
    G.reset(G.maze);
    G.generate();
  } else if(key == 'c'){
    if(G.checkCompletion())
      print("Completável!!\n");
    else
      print("Não completável...\n");
  }
  redraw();
}
