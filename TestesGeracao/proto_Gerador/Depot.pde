/*
case "RANDOM_CHOICE":
      for (int i=0; i<rodadas*300; i++) {
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
            
            
            
            
  void changeMode() {
    switch(TYPE) {
    case "BINARY_PARTITION":
      TYPE = "RANDOM_CHOICE";
      break;
    case "RANDOM_CHOICE":
      TYPE = "SINGLE_CHANCE";
      break;
    case "SINGLE_CHANCE":
      TYPE = "BINARY_PARTITION";
      break;
    }
    print("Tipo de geração mudado para " + TYPE + "\n");
  }
*/
