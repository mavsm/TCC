// 1 = parede
// 0 = espaço livre

class Gerador {
  int N, M;
  int[][] maze;
  int rodadas;
  String TYPE;

  Gerador(int N, int M, int rodadas, String TYPE) {
    this.TYPE = TYPE;
    this.N = N;
    this.M = M;
    this.rodadas = rodadas;
    maze = new int[N][M];
    reset(maze);
  }

  void reset(int[][] array) {
    for (int i=0; i<array.length; i++) {
      for (int j=0; j<array[i].length; j++)
        array[i][j] = 1; //inicializa tudo como parede
    }
  }

  void smooth() {  
    int[][] temp = new int[N][M];
    reset(temp);
    for (int i=1; i<maze.length-1; i++) 
      for (int j=1; j<maze[i].length-1; j++) {
        temp[i][j] = maze[i][j];
        int sum = maze[i+1][j] + maze[i][j+1] + maze[i-1][j] + maze[i][j-1];
        sum += maze[i+1][j+1] + maze[i-1][j+1] + maze[i-1][j-1] + maze[i+1][j-1];
        if (maze[i][j] == 1) {
          if (sum < 5)
            temp[i][j] = 0;
        } else if (sum > 6)
          temp[i][j] = 1;
      }
    maze = temp;
  }

  void generate() {
    switch(TYPE) {
    case "BINARY_PARTITION":
      partition(1, maze.length-1, 1, maze[0].length-1, 0);
      for(int i=1; i < maze.length-1; i++)
        for(int j=1; j<maze[0].length-1; j++){
          if(maze[i][j] == 0) maze[i][j] = 1;
          else maze[i][j] = 0;
        }
      break;
    case "RANDOM_CHOICE":
      for (int i=0; i<rodadas; i++) {
        int x = (int)random(1, maze.length - 1);
        int y = (int)random(1, maze[0].length - 1);
        maze[x][y] = 0;
      }
      break;
    case "SINGLE_CHANCE":
      for (int i=1; i<maze.length-1; i++)
        for (int j=1; j< maze[0].length-1; j++)
          if (random(1) > .55)
            maze[i][j] = 0;
    } // FIM DO SWICTH
  }

  void partition(int xs, int xe, int ys, int ye, int depth) {
    if (depth%2 == 0) {
      int nx = xs + (int)random(xe-xs);
      for (int i=ys; i<ye; i++)
        maze[nx][i] = 0;
      if (depth < rodadas) {
        partition(xs, nx, ys, ye, depth+1);
        partition(nx, xe, ys, ye, depth+1);
      }
    } else {
      int ny = ys + (int)random(ye-ys);
      for (int i=xs; i<xe; i++)
        maze[i][ny] = 0;
      if (depth < rodadas) {
        partition(xs, xe, ny, ye, depth+1);
        partition(xs, xe, ys, ny, depth+1);
      }
    }
  }

  void draw() {
    for (int i=0; i<maze.length; i++)
      for (int j=0; j<maze[i].length; j++) {
        if (maze[i][j] == 1)
          fill(10);
        else
          fill(250);
        rect(i*stepX, j*stepY, stepX, stepY);
      }
  }
}
