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

/*
void cells() {
  int[][] temp = new int[N][M];
  reset(temp);
  for (int i=1; i<maze.length-1; i++) 
    for (int j=1; j<maze[i].length-1; j++) {
      temp[i][j] = maze[i][j];
      int sum = maze[i+1][j] + maze[i][j+1] + maze[i-1][j] + maze[i][j-1];
      sum += maze[i+1][j+1] + maze[i-1][j+1] + maze[i-1][j-1] + maze[i+1][j-1];
      if (maze[i][j] == 1) {
        if (sum < 6)
          temp[i][j] = 0;
      } else if (sum > 5)
        temp[i][j] = 1;
    }
  maze = temp;
}*/
void keyPressed() {
  if (key == ' ') {
    G.reset(G.maze);
    G.generate();
  } else if(key == 'a'){
    G.smooth();
  }
  redraw();
}
