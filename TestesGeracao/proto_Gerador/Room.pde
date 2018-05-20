class Room{
   int xs, xe;
   int ys, ye;
   int difficultyLevel;
   int area;
   
   Room(int[] start, int[] end, int difficulty) {
     xs = start[0];
     xe = end[0];
     ys = start[1];
     ye = end[1];
     difficultyLevel = difficulty;
     area = (xe-xs)*(ye-ys);
   }

}
