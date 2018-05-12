// 1 = parede
// 0 = espaço livre

class Gerador {

  /////////// VARIÁVEIS //////////////
  int N, M;
  int[][] maze;
  int rodadas;
  String TYPE;
  int[] start = {0, 0}, end = {0, 0};

  /////////// INICIALIZADOR /////////
  Gerador(int N, int M, int rodadas, String TYPE) {
    this.TYPE = TYPE;
    this.N = N;
    this.M = M;
    this.rodadas = rodadas;
    maze = new int[N][M];
    reset(maze);
  }

  /////////// FUNÇÕES DE CONTROLE ///

  void draw() {
    for (int i=0; i<maze.length; i++)
      for (int j=0; j<maze[i].length; j++) {
        if (maze[i][j] == 1)
          fill(50);
        else
          fill(250, 250, 250 + maze[i][j]*2);
        rect(i*stepX, j*stepY, stepX, stepY);
      }
    fill(200, 20, 20);
    rect(stepX*end[0], stepY*end[1], stepX, stepY);

    fill(20, 200, 20);
    rect(stepX*start[0], stepY*start[1], stepX, stepY);
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

  /////////// FUNÇÕES GERADORAS ////////
  void generate() {
    switch(TYPE) {
    case "BINARY_PARTITION":
      partition(1, maze.length-1, 1, maze[0].length-1, 0);
      for (int i=1; i < maze.length-1; i++)
        for (int j=1; j<maze[0].length-1; j++) {
          if (maze[i][j] == 0) maze[i][j] = 1;
          else maze[i][j] = 0;
        }
      break;
    
    } // FIM DO SWICTH

    //gera começo e fim
    //while(maze[start[0]][start[1]] != 0)
    start[0] = (int)random(1, N-1); 
    start[1] = (int)random(1, M-1);
    //while(maze[end[0]][end[1]] != 0)
    end[0] = (int)random(1, N-1); 
    end[1] = (int)random(1, M-1);

    maze[start[0]][start[1]] = 0;
    maze[end[0]][end[1]] = 0;
  }

  char decideCut(int xs, int xe, int ys, int ye){
    int dify = ye-ys, difx = xe-xs;
    char decide = 'x';
    float path = random(1);
    if(difx == dify || path < 0.4) {//pega um axis qualquer
      if(random(1) < 0.5) decide = 'y';
    }
    else if(path < 1){ //pega o menor axis
      if (dify < difx) decide = 'y';
    } else { //pega o maior axis
      if(dify > difx) decide = 'y';
    }
    return decide;
  }

  void partition(int xs, int xe, int ys, int ye, int depth) {
    if(rodadas < depth) return;
    
    if (decideCut(xs, xe, ys, ye) == 'x') { //corto no axis x
      if(ye-ys<=5) return;
      
      int corte = ys + (int)random(ye-ys-2)+1;
      for(int i=xs; i<xe; i++)
        maze[i][corte] = 0;
      
      int door = (int)random(xs, xe);
      maze[door][corte] = 1; //passagem
      if(xs!=1 && maze[xs-1][corte]==1)
        maze[xs][corte] = 1; //passagem em t
      if(xe!=maze.length-1 && maze[xe][corte] == 1)
        maze[xe-1][corte] = 1; //passagem em t
      
      partition(xs, xe, corte+1, ye, depth+1);
      partition(xs, xe, ys, corte, depth+1);
      
    } else { //corto no axis y
      if(xe-xs<=3) return;
      
      int corte = xs + (int)random(xe-xs-2)+1;
      for(int i=ys; i<ye; i++)
        maze[corte][i] = 0;
      
      int door = (int)random(ys, ye);
      maze[corte][door] = 1; //passagem
      if(ys!=1 && maze[corte][ys-1]==1)
        maze[corte][ys] = 1; //passagem em t
      if(ye!=maze[0].length-1 && maze[corte][ye] == 1)
        maze[corte][ye-1] = 1; //passagem em t
      
      partition(corte+1, xe, ys, ye, depth+1);
      partition(xs, corte, ys, ye, depth+1);
    }
  }

  boolean checkCompletion() {
    int[][] stack = new int[(N-1)*(M-1)][2];
    int begin = 0, stop = 1;
    stack[0] = start;
    while (begin != stop) {
      int[] current = stack[begin];
      begin++;
      for (int i=-1; i<2; i+=2) {
        if (maze[current[0]+i][current[1]] == 0) {
          //if (current[0]+i == end[0] && current[1]== end[1]) return true;
          maze[current[0]+i][current[1]] = maze[current[0]][current[1]]-1;
          stack[stop][0] = current[0]+i;
          stack[stop][1] = current[1];
          stop++;
        }
      }
      for (int j=-1; j<2; j+=2) {
        if (maze[current[0]][current[1]+j] == 0) {
          //if (current[0] == end[0] && current[1]+j == end[1]) return true;
          maze[current[0]][current[1]+j] = maze[current[0]][current[1]]-1;
          stack[stop][0] = current[0];
          stack[stop][1] = current[1]+j;
          stop++;
        }
      }
    }
    return false;
  }
}
