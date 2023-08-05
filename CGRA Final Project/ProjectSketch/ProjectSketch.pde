// The Monkey Bananies
boolean start = false; // game start = true
boolean rectOver = false; // if press 'START' button = true 

//size of the maze map
final int X_SIZE = 29;
final int Y_SIZE = 31;

// player class
Player monkey;

// enermy class 
Enemy redBanana;
Enemy blueBanana;
Enemy pinkBanana;
Enemy yellowBanana;

PImage cherry;  // cherry icon
PImage life;    // monkey character
int state;      // state 0, 1, 2
boolean gameOver; // gameover = true
int level = 1;    // start with lvl 1
int delaySpeed = 70;     // monkey speed 70 ms
boolean movement = true; // speed of bananas: at the start, slow then fast (enemy movement)
/*
  MAP is use to reset map 
    'w' is wall
    'd' is dot
    'D' is special dot
    'm' is monkey
    'r' is red banana
    'b' is blue banana
    'p' is pink banana
    'y' is yellow banana
    ' ' is footpath
*/
final char MAP[][]={
  {'w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w'},
  {'w','d','d','d','d','d','d','d','d','d','d','d','d','w','w','w','d','d','d','d','d','d','d','d','d','d','d','d','w'},
  {'w','d','w','w','w','w','d','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','d','w','w','w','w','d','w'},
  {'w','D','w',' ',' ','w','d','w',' ',' ',' ','w','d','w','w','w','d','w',' ',' ',' ','w','d','w',' ',' ','w','D','w'},
  {'w','d','w','w','w','w','d','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','d','w','w','w','w','d','w'},
  {'w','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','w'},
  {'w','d','w','w','w','w','d','w','w','d','w','w','w','w','w','w','w','w','w','d','w','w','d','w','w','w','w','d','w'},
  {'w','d','w','w','w','w','d','w','w','d','w','w','w','w','w','w','w','w','w','d','w','w','d','w','w','w','w','d','w'},
  {'w','d','d','d','d','d','d','w','w','d','d','d','d','w','w','w','d','d','d','d','w','w','d','d','d','d','d','d','w'},
  {'w','w','w','w','w','w','d','w','w','w','w','w',' ','w','w','w',' ','w','w','w','w','w','d','w','w','w','w','w','w'},
  {' ',' ',' ',' ',' ','w','d','w','w','w','w','w',' ','w','w','w',' ','w','w','w','w','w','d','w',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ','w','d','w','w',' ',' ',' ',' ',' ','r',' ',' ',' ',' ',' ','w','w','d','w',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ','w','d','w','w',' ','w','w','w',' ',' ',' ','w','w','w',' ','w','w','d','w',' ',' ',' ',' ',' '},
  {'w','w','w','w','w','w','d','w','w',' ','w',' ',' ',' ',' ',' ',' ',' ','w',' ','w','w','d','w','w','w','w','w','w'},
  {' ',' ',' ',' ',' ',' ','d','c',' ',' ','w','b',' ',' ','p',' ',' ','y','w',' ',' ',' ','d',' ',' ',' ',' ',' ',' '},
  {'w','w','w','w','w','w','d','w','w',' ','w',' ',' ',' ',' ',' ',' ',' ','w',' ','w','w','d','w','w','w','w','w','w'},
  {' ',' ',' ',' ',' ','w','d','w','w',' ','w','w','w','w','w','w','w','w','w',' ','w','w','d','w',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ','w','d','w','w',' ',' ','z',' ',' ',' ',' ',' ',' ',' ',' ','w','w','d','w',' ',' ',' ',' ',' '},
  {' ',' ',' ',' ',' ','w','d','w','w',' ','w','w','w','w','w','w','w','w','w',' ','w','w','d','w',' ',' ',' ',' ',' '},
  {'w','w','w','w','w','w','d','w','w',' ','w','w','w','w','w','w','w','w','w',' ','w','w','d','w','w','w','w','w','w'},
  {'w','d','d','d','d','d','d','d','d','d','d','d','d','w','w','w','d','d','d','d','d','d','d','d','d','d','d','d','w'},
  {'w','d','w','w','w','w','d','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','d','w','w','w','w','d','w'},
  {'w','d','w','w','w','w','d','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','d','w','w','w','w','d','w'},
  {'w','D','d','d','w','w','d','d','d','d','d','d','d',' ','m',' ','d','d','d','d','d','d','d','w','w','d','d','D','w'},
  {'w','w','w','d','w','w','d','w','w','d','w','w','w','w','w','w','w','w','w','d','w','w','d','w','w','d','w','w','w'},
  {'w','w','w','d','w','w','d','w','w','d','w','w','w','w','w','w','w','w','w','d','w','w','d','w','w','d','w','w','w'},
  {'w','d','d','d','d','d','d','w','w','d','d','d','d','w','w','w','d','d','d','d','w','w','d','d','d','d','d','d','w'},
  {'w','d','w','w','w','w','w','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','w','w','w','w','w','d','w'},
  {'w','d','w','w','w','w','w','w','w','w','w','w','d','w','w','w','d','w','w','w','w','w','w','w','w','w','w','d','w'},
  {'w','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','d','w'},
  {'w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w','w'},
}; // constant, so MAP can NOT be changed

char[][] map = new char[X_SIZE][Y_SIZE];  // map is use to update MAP // load MAP and put it inside map to update when movement occurs


/*
  setup is show main window and reset (initial value)
*/
void setup() {
  size(1000, 1000);  // window size
  showMain();        // menu page at the start of the game
  reset();           // reset the game - initialise all the value
}

/*
  draw is draw with different game conditions
*/
void draw() {
  if(start){           // when click start button
  
    if(state<=1){      // if state 0 or state 1
      showMap();       // show map
    }else{             // state 2
      updateMap();     // update map
    }
    if(state==1){      // if state is 1
      delay(3000);     // delay 3 sec/3000 ms for show "Ready!" after you clicked 'START'
      state++;         // inrease to state 2
    }
    
    if(state<=1){                // state 0 or state 1
      textSize(35);              // text size
      fill(255, 244, 28);        // text colour
      text("Ready!",480,600);    // text "Ready!" at position (x,y) = (480,600)
      state++;                   // increase to state 1
    }else if(state==2){          // state 2
      if(!gameOver){             // when game not over
        delay(delaySpeed);       // delay when drawing 
        playerMovement();        // monkey movement that we want
        if(level==1){                            // level 1
          if(movement){                          // enemy slow movement (2x slower than player)
            enemyMovement(redBanana);            // red banana movement
            enemyMovement(blueBanana);           // blue banana movement
            enemyMovement(pinkBanana);           // pink banana movement
            enemyMovement(yellowBanana);         // yellow banana movement
            movement = false;                    // stop moving then
          }else{        
            movement = true;                     // move now - 2x slower
          }
        }else if(level==2){  // level 2
          // enemy fast movement (enermy and player move at the same pace)
          enemyMovement(redBanana);              // red banana movement
          enemyMovement(blueBanana);             // blue banana movement
          enemyMovement(pinkBanana);             // pink banana movement
          enemyMovement(yellowBanana);           // yellow banana movement
        }
        if(win()){                                        // if win
          gameOver = true;                             
          if(level==1){                                   // win at level 1
            levelUp(monkey.getScore(),monkey.getLife());  // next level starts // with current score and current life
          }else{                                          // win at level 2
            showWin();                                    // show the final score and text "You Win!"
            start=false;
          }
        }else if(monkey.getLife()==0){                    // lose (life is zero)
          gameOver = true;                                // game over
          showLose();                                     // show "You Lose!" "Game Over!"
          start=false;
        }
      }
    }
  }else{ // if have not started
    update();    // update mouse click start button
  }
}

/*  
  showMain is menu page at the start of the game
*/
void showMain(){
  background(0, 140, 70); // background colour : green
  
  // yellow rectangle size=200*100
  fill(250, 222, 10); // yellow box  
  rect((width/2)-100, (height/2)-50, 200, 100);  // at (x,y) = ((1000/2)-100,(1000/2)-50) = (400,450)
  
  // "The Monkey Bananies" 
  textSize(70);  // text size 70       
  fill(247, 255, 3); // yellow colour
  text("The Monkey Bananies",width/5,height/6); // at (x,y) = (1000/5,1000/6) = (200,166)
  
  //image player and enemy
  int imgSize = 150; // image size = 150*150
  image(loadImage("red_banana_peel.PNG"),width/2-420,height/4,imgSize,imgSize);   // red banana at (x,y) = (1000/2-420,1000/4) = (80,250)
  image(loadImage("blue_banana_peel.PNG"),width/2-250,height/4,imgSize,imgSize);  // blue banana at (x,y) = (1000/2-250,1000/4) = (250,250)
  image(loadImage("monkey.PNG"),width/2-50,height/4,imgSize,imgSize);             // monkey at (x,y) = (1000/2-50,1000/4) = (450,250)
  image(loadImage("pink_banana_peel.PNG"),width/2+150,height/4,imgSize,imgSize);  // pink banana at (x,y) = (1000/2+150,1000/4) = (650,250)
  image(loadImage("yellow_banana_peel.PNG"),width/2+320,height/4,imgSize,imgSize);// yellow banana at (x,y) = (1000/2+320,1000/4) = (820,250)
  
  // write "START"
  textSize(75); // text size 75 
  fill(0);     // black colour
  text("START",(width/2)-100,(height/2)+25); // at (x,y) = ((1000/2)-100,(1000/2)+25) = (400,525)
  
  // write "Control by" 
  fill(255);  //white colour
  textSize(60); // text size 60
  text("Control by",(width/4)-100,height-(height/4)+100);  // show "Control By" at (x,y) = ((1000/4)-100,1000-(1000/4)+100) = (150,850)
  
  // Control Button
  btnControlShow((width/4)+400, height-(height/2)+175,100,'u');     // display up button // u : arrow up
  btnControlShow((width/4)+300, height-(height/3)+100,100,'l');     // display left button // l : arrow left
  btnControlShow((width/4)+400, height-(height/3)+100,100,'d');     // display down button // d : arrow down
  btnControlShow((width/4)+500, height-(height/3)+100,100,'r');     // display right button // r : arrow right
}

/*  Draw Control Button */
void btnControlShow(int x,int y,int size,char direction){
  //yellow rectangle 
  fill(250, 222, 10);      // yellow colour
  rect(x,y,size,size);     // draw rectangle // size=size*size at (x,y)
  
  // black triangle point1=(x1,y1) point2=(x2,y2) point3==(x3,y3)
  int x1 = -1;
  int y1 = -1;
  int x2 = -1;
  int y2 = -1;
  int x3 = -1;
  int y3 = -1;
  
  if(direction=='u'){        // triangle pointing up
    x1 = x+(size/2);
    y1 = y+(size/4);
    x2 = x+(size/4);
    y2 = y+size-(size/4);
    x3 = x+size-(size/4);
    y3 = y+size-(size/4);
  }else if(direction=='d'){  // triangle pointing down
    x1 = x+(size/2);
    y1 = y+size-(size/4);
    x2 = x+(size/4);
    y2 = y+(size/4);
    x3 = x+size-(size/4);
    y3 = y+(size/4);      
  }else if(direction=='l'){  // left-pointing triangle
    x1 = x+size-(size/4);
    y1 = y+(size/4);
    x2 = x+(size/4);
    y2 = y+(size/2);
    x3 = x+size-(size/4);
    y3 = y+size-(size/4);
  }else if(direction=='r'){  // right-pointing triangle
    x1 = x+(size/4);
    y1 = y+(size/4);
    x2 = x+size-(size/4);
    y2 = y+(size/2);
    x3 = x+(size/4);
    y3 = y+size-(size/4);       
  }
  fill(0); // black colour of triangle
  triangle(x1,y1,x2,y2,x3,y3); // draw each triangle
}

/*
  reset is reset game by initialise all of the value again  
*/
void reset(){
  // Copy MAP to map
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      map[i][j]=MAP[j][i]; 
    }
  }
  
  // initialise all value at the MAP
  state = 0;
  gameOver = false;
  
  monkey = new Player("monkey.PNG");
  monkey.setPosition(14,23); // array position at the MAP (x,y)
  
  redBanana = new Enemy("red_banana_peel.PNG","red_peeled_banana.PNG",'r');
  redBanana.setPosition(14,11); // array position at the MAP 
  redBanana.countDown();
  
  blueBanana = new Enemy("blue_banana_peel.PNG","blue_peeled_banana.PNG",'b');
  blueBanana.setPosition(11,14); // array position at the MAP 
  blueBanana.countDown();
  
  pinkBanana = new Enemy("pink_banana_peel.PNG","pink_peeled_banana.PNG",'p');
  pinkBanana.setPosition(14,14); // array position at the MAP
  pinkBanana.countDown();
  
  yellowBanana = new Enemy("yellow_banana_peel.PNG","yellow_peeled_banana.PNG",'y');
  yellowBanana.setPosition(17,14); // array position at the MAP  
  yellowBanana.countDown();
  
  cherry = loadImage("cherry.PNG");
  life = loadImage("monkey.PNG");
}

/*
  levelUp is when a player passes level 1, they will move on to the next level (level 2)
*/
void levelUp(int score,int life){
  reset();               
  level = 2;               // level up to level 2
  monkey.setScore(score);  // scores/point are counted continuously from level 1 score
  monkey.setLife(life);    // number of remaining lives continued from level 1 life
}

/*
  showLose is show "You Lose! Game Over!"
*/
void showLose(){
  // black rectangle size 1000*1000 at (x,y) = (0,0)
  stroke(0);
  fill(0);
  rect(0,0,width,height);
  
  // "You Lose!" text size=100 red colour at (x,y) = ((1000/4)+50,(1000/3)) = (300,333)
  // "Game Over" text size=100 red colour at (x,y) = ((1000/4),(1000/2)) = (250,500)
  textSize(100);
  fill(245,28,12);  // red colour
  text("You Lose!",(width/4)+50,(height/3));
  text("Game Over",(width/4),(height/2));
}

/*  
  showWin is show "You Win! Score XXX"  
*/
void showWin(){
  // black rectangle size 1000*1000 at (x,y) = (0,0)
  stroke(0);
  fill(0);
  rect(0,0,width,height);
  
  // "You Win!" text size=100 yellow colour at (x,y) = ((1000/2)-150,(1000/3)) = (350,333)
  // "Score" text size=100 yellow colour at (x,y) = ((1000/2)-100,(1000/2)) = (400,500)
  // "XXX" text size=100 yellow colour at (x,y) = ((1000/2)-50,(1000/2)+(1000/6)) = (450,666)
  textSize(100);
  fill(255,244,28);  // yellow colour
  text("You Win!",(width/2)-150,(height/3));
  text("Score",(width/2)-100,(height/2));  
  text(String.format("%03d",monkey.getScore()),(width/2)-50,(height/2)+(height/6));
}

/*
  showLevel is show "Level X"
*/
void showLevel(){
  // "Level" text size=35 white colour at (x,y) = ((1000/2)-(1000/8),(1000/6)) = (375,166)
  // "X" text size=35 white colour at (x,y) = ((1000/2)-(1000/8)+30,(1000/6)+50) = (405,216)
  textSize(35);
  fill(255);  // white colour
  text("Level",(width/2)-(width/8),(height/6)); // "Level" 
  text(level,(width/2)-(width/8)+30,(height/6)+50); // "X"
}

/*
  showScore is show "Score XXX"
*/
void showScore(){
  // "Score" text size=35 white colour at (x,y) = ((1000/2)+(1000/8),(1000/6)) = (625,166)
  // "XXX" text size=35 white colour at (x,y) = ((1000/2)+(1000/8)+15,(1000/6)+50) = (640,216)
  textSize(35);
  fill(255);  // white colour
  text("Score",(width/2)+(width/8),(height/6)); // "Score"
  text(String.format("%03d",monkey.getScore()),(width/2)+(width/8)+15,(height/6)+50); // "XXX"
}

/*
  updateScore is update score "XXX"
*/
void updateScore(){
  // black colour rectangle size=60*35 at (x,y) = ((1000/2)+(1000/8)+15,(1000/6)+25) = (640,191)
  stroke(0);  // stroke black colour 
  fill(0);    // fill black colour
  rect((width/2)+(width/8)+15,(height/6)+25,60,35);
  // "XXX" text size=35 white colour at (x,y) = ((1000/2)+(1000/8)+15,(1000/6)+50) = (640,216)
  textSize(35);
  fill(255);  // white colour
  text(String.format("%03d",monkey.getScore()),(width/2)+(width/8)+15,(height/6)+50);
}

/*
  showLife is draw remaining monkey life
*/
void showLife(){
  // image of monkey size = 35*35
  stroke(0); // stroke black 
  fill(0);   // fill black 
  rect((width/2)-40,height-(height/8),150,35);
  int dist=monkey.getLife()*10;
  for(int i=0;i<monkey.getLife();i++){  // loop draw 3 monkeys
    image(life,(i*35)+(width/2)-dist,height-(height/8),35,35);
  }
}

/*
  showMap is draw the original map (start the game)
*/
void showMap(){
  //  black background, which is rectangle size=1000*1000 at (x,y) = (0,0)
  stroke(0);  
  fill(0);   
  rect(0,0,width,height);
  
  showLevel();
  showScore();
  showLife();
  
  // Draw wall in map with draw line from 2 point is point1=(x1,y1) and point2=(x2,y2)
  int x1=-1;
  int y1=-1;
  int x2=-1;
  int y2=-1;
  stroke(22,5,255);  // blue colour
  
  // draw vertical line 
  for(int i=0;i<X_SIZE;i++){  
    for(int j=0;j<Y_SIZE-1;j++){  
      if(map[i][j]=='w' && map[i][j+1]=='w'){ // if another 'w' is below to 'w' |
        x1=(i*20)+(width/4);
        y1=(j*20)+(height/4);
        x2=(i*20)+(width/4);
        y2=((j+1)*20)+(height/4);
        line(x1,y1,x2,y2);
      }
    }
  }
  // draw horizontal line 
  for(int i=0;i<X_SIZE-1;i++){
    for(int j=0;j<Y_SIZE;j++){
     if(map[i][j]=='w' && map[i+1][j]=='w'){ // if another 'w' is on the right side of 'w' -
        x1=(i*20)+(width/4);
        y1=(j*20)+(height/4);
        x2=((i+1)*20)+(width/4);
        y2=(j*20)+(height/4);
        line(x1,y1,x2,y2);
      }
    }
  }
  
  // draw all objects in map
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      if(map[i][j]=='D'){             // when in the map at (i,j) is special dot 
        // draw big orange circle with radius of 13 
        fill(255,188,87);             // orange colour
        stroke(255,188,87);           // orange colour
        circle((i*20)+(width/4),(j*20)+(height/4),13);  // x, y, radius = 13
      }else if(map[i][j]=='d'){       // when in the map at (i,j) is normal dot
        // draw small orange circle with radius of 3
        fill(255,188,87);            // orange colour
        stroke(255,188,87);          // orange colour
        circle((i*20)+(width/4),(j*20)+(height/4),3);  // x, y, rad = 3
      }else if(map[i][j]=='m'){                                              // when in the map at (i,j) is monkey
        monkey.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);        // draw monkey
      }else if(map[i][j]=='r'){                                              // when in the map at (i,j) is red banana
        redBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);     // draw red banana
      }else if(map[i][j]=='b'){                                              // when in the map at (i,j) is blue banana
        blueBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);    // draw blue banana
      }else if(map[i][j]=='p'){                                              // when in the map at (i,j) is pink banana
        pinkBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);    // draw pink banana
      }else if(map[i][j]=='y'){                                              // when in the map at (i,j) is yellow banana
        yellowBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);  // draw yellow banana
      }else if(map[i][j]=='c'){                                              // when in the map at (i,j) is cherry
        image(cherry,((i*20)+(width/4))-10,((j*20)+(height/4))-10,20,20);    // draw cherry
      }
    }
  }
}

/*
  updateMap is update object in map
*/
void updateMap(){
  // separates loops, so that the images do not overlap
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      if(map[i][j]=='d'){  // when in the map at (i,j) is normal dot
        // black rectangle
        stroke(0);
        fill(0);
        rect((i*20)+(width/4)-18,(j*20)+(height/4)-18,33,33);
        
        // draw small orange circle with radius = 3
        fill(255,188,87); 
        stroke(255,188,87); 
        circle((i*20)+(width/4),(j*20)+(height/4),3);       
      }else if(map[i][j]==' '){  // when in the map at (i,j) is footpath
        // black rectangle
        stroke(0);  
        fill(0);   
        rect((i*20)+(width/4)-18,(j*20)+(height/4)-18,33,33);  
      }
    }
  }
  
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      if(map[i][j]=='D'){  // when in the map at (i,j) is special dot
        // black rectangle
        stroke(0);  
        fill(0);    
        rect((i*20)+(width/4)-18,(j*20)+(height/4)-18,33,33);
        
        // draw big orange circle with radius = 13
        fill(255,188,87);    
        stroke(255,188,87);  
        circle((i*20)+(width/4),(j*20)+(height/4),13); 
      }else if(map[i][j]=='c'){
        // black rectangle
        stroke(0);  
        fill(0);    
        rect((i*20)+(width/4)-18,(j*20)+(height/4)-18,33,33);
        // draw cherry
        image(cherry,((i*20)+(width/4))-10,((j*20)+(height/4))-10,20,20);    
      }
    }
  }
  
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      if(map[i][j]=='m'){                                                    // when in the map at (i,j) is monkey
        monkey.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);        // draw monkey
      }else if(map[i][j]=='r'){                                              // when in the map at (i,j) is red banana
        redBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);     // draw red banana
      }else if(map[i][j]=='b'){                                              // when in the map at (i,j) is blue banana
        blueBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);    // draw blue banana
      }else if(map[i][j]=='p'){                                              // when in the map at (i,j) is pink banana
        pinkBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);    // draw pink banana
      }else if(map[i][j]=='y'){                                              // when in the map at (i,j) is yellow banana
        yellowBanana.show(((i*20)+(width/4))-15,((j*20)+(height/4))-15,30);  // draw yellow banana
      }
    }
  }
}

/*
  playerMovement is player movement when encountering various events and conditions 
*/
void playerMovement(){
 if(monkey.getX()>=0 && monkey.getX()<=X_SIZE && monkey.getY()>=0 && monkey.getY()<=Y_SIZE){ // if it is in the range of x and y axis
   boolean move = false;
   if(monkey.getDirection()=='u'){                               // when direction of monkey is up
      if(!isWall(monkey.getX(),monkey.getY()-1)){                // when above is not wall // -1 on y axis = above
        map[monkey.getX()][monkey.getY()]=' ';                   // set current position on map as footpath // update on the map
        monkey.moveUp();                                         // monkey move up // update the monkey
        move = true;                                             // and move
      }
    }else if(monkey.getDirection()=='d'){                        // when direction of monkey is down
      if(!isWall(monkey.getX(),monkey.getY()+1)){                // when below is not wall // +1 on y axis = below
        map[monkey.getX()][monkey.getY()]=' ';                   // set current position on map as footpath
        monkey.moveDown();                                       // monkey move down
        move = true;                                             // and move
      }
    }else if(monkey.getDirection()=='l'){                        // when direction of monkey is left
      if(!isWall(monkey.getX()-1,monkey.getY())){                // when left side is not wall // -1 on x axis = left
        map[monkey.getX()][monkey.getY()]=' ';                   // set current position on map as footpath
        if((monkey.getX()-1)==0 && monkey.getY()==14){           // when (x,y) is at (0,14) on the left --> then
          monkey.setPosition(28,14);                             // monkey's position appear on the right (28,14)
        }else{                                                   // Otherwise
          monkey.moveLeft();                                     // monkey moves left
        }
        move = true;                                             // and move
      }
    }else if(monkey.getDirection()=='r'){                        // when direction of monkey is right
      if(!isWall(monkey.getX()+1, monkey.getY())){                // when right side is not wall // +1 on x axis = right
        map[monkey.getX()][monkey.getY()]=' ';                   // set current position on map as footpath
        if((monkey.getX()+1)==28 && monkey.getY()==14){          // when (x,y) is at (28,14) on the right --> then
          monkey.setPosition(0,14);                              // monkey's position appear on the left (0,14)
        }else{                                                   // Otherwise
          monkey.moveRight();                                    // Monkey moves right
        }
        move = true;                                             // and move
      }
    }
    
    if(move){   // when moving
      if(isDot(monkey.getX(),monkey.getY())){                  // current position of the monkey on map is normal dot
        monkey.pickUpDot();                                    // in player class : 1 point for normal dot
        updateScore();
      }else if(isSpecialDot(monkey.getX(),monkey.getY())){     // current position of the monkey on map is special dot
        monkey.pickUpSpecialDot();                             // in player class : 10 points for special dot
        updateScore();
        // all enemies switch from attack mode ->  escape mode (banana peels -> peeled bananas) // in enermy class
        redBanana.SwitchToEscapeMode();
        blueBanana.SwitchToEscapeMode();
        pinkBanana.SwitchToEscapeMode();
        yellowBanana.SwitchToEscapeMode();
      }else if(isCherry(monkey.getX(),monkey.getY())){        // current position of monkey on map is Cherry
        monkey.pickUpCherry();                                // in player class : add extra life
        showLife();
      }else if(isEnemy(monkey.getX(),monkey.getY())){         // current position of monkey on map is enemy/banana
        if(redBanana.isAttackMode() && blueBanana.isAttackMode() && pinkBanana.isAttackMode() && yellowBanana.isAttackMode()){   // if enemy is in the attack mode
          monkey.Attacked();                                  // in player class : lose a life
          showLife();                                         // show current lives left
          monkey.setPosition(14,23);                          // monkey reborn at this position
          monkey.setDirection('l');                           // monkey start direction to left
        }else{                                                // enemy is escape mode
          if(map[monkey.getX()][monkey.getY()]=='r'){
            redBanana.setPosition(-1,-1);                     // red banana got eaten -> set a new position outside of the map, so we can't see
          }else if(map[monkey.getX()][monkey.getY()]=='b'){
            blueBanana.setPosition(-1,-1);                   // blue banana got eaten -> set a new position outside of the map
          }else if(map[monkey.getX()][monkey.getY()]=='p'){
            pinkBanana.setPosition(-1,-1);                   // pink banana got eaten -> set a new position outside of the map
          }else if(map[monkey.getX()][monkey.getY()]=='y'){
            yellowBanana.setPosition(-1,-1);                 // yellow banana got eaten -> set a new position outside of the map
          }
          monkey.makeAnAttack();                             // in player class : eat a peeled banana -> get 50 points
          updateScore();                                     // update new score
        }
      }
      map[monkey.getX()][monkey.getY()]='m';                // set monkey to the current position on map that satisfied all the conditions
    }
  }
}

/*
  enemyMovement is enemy movement when encountering various events and conditions 
*/
void enemyMovement(Enemy enemy){
 if(enemy.getX()>=0 && enemy.getX()<=X_SIZE && enemy.getY()>=0 && enemy.getY()<=Y_SIZE){
   if(enemy.getX()==14 && enemy.getY()==13){   // forces enemies to exit the spawn block when passing through (x,y) = (13,14)
     enemy.setDirection('u'); 
   }
   boolean move = false;
   if(enemy.getDirection()=='u'){                                  // when direction of enemy is up
      if(!isEnemy(enemy.getX(),enemy.getY()-1) && !isWall(enemy.getX(),enemy.getY()-1)){   // when above is not a wall and not one of the enermies
        map[enemy.getX()][enemy.getY()]=enemy.getTemp();           // set current position on map to value in temp variable // so when banana passes the dot, it doesn't dissapear forever
        enemy.setTemp(map[enemy.getX()][enemy.getY()-1]);          // keep above position to the temp variable
        enemy.moveUp();                                            // enemy moves up // in enermy class
        move = true;                                               // and move
      }else{                                                       // Otherwise 
        enemy.randomMovement();                                    // random enemy direction
      }
    }else if(enemy.getDirection()=='d'){                           // when direction of enemy is down
      if(!isEnemy(enemy.getX(),enemy.getY()+1) && !isWall(enemy.getX(),enemy.getY()+1)){  // when below is not a wall and not one of the enermies
        map[enemy.getX()][enemy.getY()]=enemy.getTemp();          // set current position on map is value in temp variable
        enemy.setTemp(map[enemy.getX()][enemy.getY()+1]);         // keep below position to the temp variable
        enemy.moveDown();                                         // enemy moves down // in enermy class
        move = true;                                              // and move
      }else{                                                      // Otherwise 
        enemy.randomMovement();                                   // random enemy direction
      }
    }else if(enemy.getDirection()=='l'){                          // when direction of enemy is left
      if(!isEnemy(enemy.getX()-1,enemy.getY()) && !isWall(enemy.getX()-1,enemy.getY())){  // when left side is not a wall and not one of the enermies
        map[enemy.getX()][enemy.getY()]=enemy.getTemp();          // set current position on map as value in temp variable
        enemy.setTemp(map[enemy.getX()-1][enemy.getY()]);         // keep left position to the temp variable
        if((enemy.getX()-1)==0 && enemy.getY()==14){              // when (x,y) is at (0,14) on the left --> then
          enemy.setPosition(28,14);                               // enemy's position appears on the right (28,14)
        }else{                                                    // Otherwise
          enemy.moveLeft();                                       // enemy moves left
        }
        move = true;                                              // and move
      }else{                                                      // Otherwise 
        enemy.randomMovement();                                   // random enemy direction
      }
    }else if(enemy.getDirection()=='r'){                          // when direction of enemy is right
      if(!isEnemy(enemy.getX()+1,enemy.getY()) && !isWall(enemy.getX()+1,enemy.getY())){  // when right side is not a wall and not one of the enermies
        map[enemy.getX()][enemy.getY()]=enemy.getTemp();          // set current position on map is value in temp variable
        enemy.setTemp(map[enemy.getX()+1][enemy.getY()]);         // keep right position to the temp variable
        if((enemy.getX()+1)==28 && enemy.getY()==14){             // when (x,y) is at (28,14) on the right --> then
          enemy.setPosition(0,14);                                // enemy's position appears on the left (0,14)
        }else{                                                    // Otherwise
          enemy.moveRight();                                      // enemy moves right
        }
        move = true;                                              // and move
      }else{                                                      // Otherwise 
        enemy.randomMovement();                                   // random enemy direction
      }
    }
    
    if(move){  // when moving
      if(isPlayer(enemy.getX(),enemy.getY())){                   // when the one of the enermies found a player
        if(redBanana.isAttackMode() && blueBanana.isAttackMode() && pinkBanana.isAttackMode() && yellowBanana.isAttackMode()){ // if the bananas are in the attack mode
          map[enemy.getX()][enemy.getY()]=enemy.getName();       // in enermy class
          enemy.setTemp(' ');                                    // set to temp variable as footpath
          monkey.Attacked();                                     // monkey got attacked
          showLife();
          monkey.setPosition(14,23);                             // monkey reborn position
          monkey.setDirection('l');                              // start direction to left
        }else{                                                   // if banana is in escape mode
          enemy.setPosition(-1,-1);                              // enemy got eaten -> set a new position outside of the map, so we can't see
        }
      }else{
        map[enemy.getX()][enemy.getY()]=enemy.getName();        // in enermy class
      }
    }
  }
}

/*  
  win is Win by pick up all dot and all special dot
*/
boolean win(){
  for(int i=0;i<X_SIZE;i++){
    for(int j=0;j<Y_SIZE;j++){
      if(isDot(i,j) || isSpecialDot(i,j)){   // if there are any dot and special dot appears in thr map still
        return false;                      
      }
    }
  }
  return true;                              // if the map has no more dot
}

/*  
  isWall is check if in the map at x y is wall or not
*/
boolean isWall(int x,int y){ 
  if(map[x][y]=='w'){
    return true;      
  }
  return false;
}

/*  
  isDot is check if in the map at x, y is dot or not
*/
boolean isDot(int x,int y){
  if(map[x][y]=='d'){
    return true;      
  }
  return false;
}

/*  
  isSpecialDot is check if in the map at x, y is special dot or not
*/
boolean isSpecialDot(int x,int y){
  if(map[x][y]=='D'){
    return true;      
  }
  return false;
}

/*  
  isCherry is check if in the map at x,y is cherry or not
*/
boolean isCherry(int x,int y){
  if(map[x][y]=='c'){
    return true;      
  }
  return false;
}

/*  
  isFootPath is check if in the map at x,y is footPath or not
*/
boolean isFootPath(int x,int y){
  if(map[x][y]==' '){
    return true;      
  }
  return false;
}

/*  
  isPlayer is check if in the map at x, y is monkey or not
*/
boolean isPlayer(int x,int y){
  if(map[x][y]=='m'){
    return true;      
  }
  return false;
}

/*  
  isEnemy is check if in the map at x, y is it one of the enemies or not
*/
boolean isEnemy(int x,int y){
  if(map[x][y]=='r' || map[x][y]=='b' || map[x][y]=='p' || map[x][y]=='y'){
      return true;
  }
  return false;
}

/*  
  update is to check if the button has been clicked or not
*/
void update() {
  if ( overRect((width/2)-100, (height/2)-50, 200, 100) ) { // click within the rect
    rectOver = true; // when player pressed the "START" at the rectangle box 
  } else {
    rectOver = false;
  }
}

/*
  overRect is when click mouse to x,y of the "START" button
*/
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

/*
  mousePressed is the mouse pressed button to start game
*/
void mousePressed() {
  if (rectOver) { 
    start = true; // when player pressed the "START" = start the game
  }
}

/*
  keyPressed is get input key pressed control direction monkey
*/
void keyPressed() {
  if(key == CODED){
    if(keyCode == UP){                               // key up
      if(map[monkey.getX()][monkey.getY()-1]!='w'){  // if above is not a wall
        monkey.setDirection('u');
      }
    }else if(keyCode == DOWN){                       // key down
      if(map[monkey.getX()][monkey.getY()+1]!='w'){  // if below is not a wall
        monkey.setDirection('d');
      }
    }else if(keyCode == LEFT){                       // key left
      if(map[monkey.getX()-1][monkey.getY()]!='w'){  // if the left side is not a wall
        monkey.setDirection('l');
      }
    }else if(keyCode == RIGHT){                     // key right
      if(map[monkey.getX()+1][monkey.getY()]!='w'){ // if the right side is not a wall
        monkey.setDirection('r');
      }
    } 
  }
}
