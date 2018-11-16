int N = 50, M = 50;
Gerador G;
float stepX, stepY;

int[] maxEnemies = {0, 1, 3, 4, 7, 10, 15, 16, 17, 19, 22, 30 };

void setup() {
  size(300, 300);
  G = new Gerador(N, M, 5);
  stepX = (float)width/N;
  stepY = (float)height/M;
  noLoop();
  noStroke();
  rectMode(CORNER);
  ellipseMode(CORNER);

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
  } else if (key == 'c') {
 //   if (G.checkCompletion())
      print("Completável!!\n");
   // else
      print("Não completável...\n");
  } else if (key == '1') {
    G.reset(G.maze);
    G.update(1, 1);
    G.generate();
  } else if (key == '2') {
    G.reset(G.maze);
    G.update(2, 2);
    G.generate();
  } else if (key == '3') {
    G.reset(G.maze);
    G.update(3, 3);
    G.generate();
  } else if (key == '4') {
    G.reset(G.maze);
    G.update(4, 4);
    G.generate();
  } else if (key == '5') {
    G.reset(G.maze);
    G.update(5, 5);
    G.generate();
  } else if (key == '0') {
    G.reset(G.maze);
    G.update(0, 0);
    G.generate();
  }
  redraw();
}
