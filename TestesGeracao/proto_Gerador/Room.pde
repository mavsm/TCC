class Room{
   int xs, xe;
   int ys, ye;
   int difficultyLevel;
   
   int[][] area;
   
   int numEnemies;
   
   Room(int[] start, int[] end, int difficulty) {
     xs = start[0];
     xe = end[0];
     ys = start[1];
     ye = end[1];
     difficultyLevel = difficulty;

     numEnemies = ((xe-xs)*(ye-ys))/(10*(1 - difficultyLevel/12));
     if(numEnemies > maxEnemies[difficultyLevel])
       numEnemies = maxEnemies[difficultyLevel];
     //numEnemies = int(float(difficultyLevel/11)*numEnemies);
     //if(numEnemies < 3) numEnemies = 0;
     
     print(difficultyLevel + " : " + numEnemies + "\n" );
     
     area = new int[numEnemies][2];
     
   }
   
   void generate(){
     for(int i=0; i < numEnemies; i++) {
       area[i][0] = (int)random(xe-xs)+xs;
       area[i][1] = (int)random(ye - ys)+ys;
     }
   }
   
   void draw(float stepX, float stepY) {
     for(int i=0; i<numEnemies; i++) {
       fill(240, 0, 240);
       ellipse((area[i][0])*stepX, (area[i][1])*stepY, stepX, stepY);
     }
   }
   
   boolean contains(int x, int y) {
     return (xs <= x && x < xe && ys <= y && y< ye);
   }

}
