class Player{
  private final int MAX_LIFE = 3; // max life is 3
  private int life = 3;           // start with 3 lives
  private int score = 0;
  private char direction = 'l';   // set direction as left
  private int x;
  private int y;
  PImage img;
  
  public Player(String imgName){
    img = loadImage(imgName);
  }
  
  // getter
  public int getScore(){  return score;  }
  public int getLife(){  return life;  }
  public char getDirection(){  return direction;  }
  public int getX(){  return x;  }
  public int getY(){  return y;  }
  
  // setter
  public void setScore(int score){  
    this.score = score;  
  }
  public void setLife(int life){  
    this.life = life;    
  }
  public void setDirection(char direction){
    this.direction = direction;
  } 
  public void setPosition(int x,int y){
   this.x = x;
   this.y = y;
  }
  
  public void moveUp(){  y-=1;  }
  public void moveDown(){  y+=1;  }
  public void moveLeft(){  x-=1;  }
  public void moveRight(){  x+=1;  }
  
  public void show(int x,int y,int size){
   image(img,x,y,size,size);
  }

  public void pickUpDot(){
    score+=1; // 1 normal dot = 1 point
  }
  
  public void pickUpSpecialDot(){
    score+=10; // 1 special dot = 10 points
  }
  
  public void pickUpCherry(){
    if(life<MAX_LIFE){ // if it is less than 3 lives -> add a life
      life+=1;
    }
  }
  
  public void Attacked(){
    life-=1; // lose a life
  }
  
  public void makeAnAttack(){
    score+=50; // eat 1 peeled banana = get 50 points
  }
}
