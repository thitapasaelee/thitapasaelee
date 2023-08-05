import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;
class Enemy{
  private char direction = 'u';
  private int x;
  private int y;
  private char name;
  private char temp = ' ';
  Timer timer = new Timer();
  private int time = 0;
  private boolean attackMode = true; // start with attack mode
  PImage imgAttack;
  PImage imgEscape;
  PImage img;
  
  public Enemy(String imgAttackName,String imgEscapeName,char name){
    imgAttack = loadImage(imgAttackName);
    imgEscape = loadImage(imgEscapeName);
    img = imgAttack;
    this.name = name;
  }
  
  // getter
  public char getName(){  return name;  }
  public char getDirection(){  return direction;  }
  public int getX(){  return x;  }
  public int getY(){  return y;  }
  public char getTemp(){  return temp; }

  // setter
  public void setDirection(char direction){ // set direction
    this.direction = direction;
  } 
  public void setPosition(int x,int y){
    this.x = x;
    this.y = y;
  }
  public void setTemp(char temp){ // set the temp variable, so the dots are not dissappear forever when enermies pass
    this.temp = temp;
  }
  
  public void moveUp(){  y-=1;  }
  public void moveDown(){  y+=1;  }
  public void moveLeft(){  x-=1;  }
  public void moveRight(){  x+=1;  } 
  
  public void randomMovement(){   // random movement
    Random rand = new Random();
    int number = rand.nextInt(4); // random numbers of 0, 1, 2, 3
    if(number==0){                // if num = 0 -> up
      direction='u';
    }else if(number==1){          // if num = 1 -> down
      direction='d';
    }else if(number==2){          // if num = 2 -> left
      direction='l';
    }else if(number==3){          // if num = 3 -> right
      direction='r';
    }
  }
  
  public boolean isAttackMode(){  // check if it is in attack mode
    return attackMode;
  };
  
  public void SwitchToEscapeMode(){
    attackMode = false; // no longer in an attack mode
    img = imgEscape;    // change banana peels -> peeled banana
    time = 8;           // 8 sec
  }
  
  void countDown(){    // countdown the time when they are peeled bananas
    timer.scheduleAtFixedRate(new TimerTask() {
      public void run() {
        if (time == 0){ // when time is up, returns to attack mode
          attackMode = true; 
          img = imgAttack;
        }
        time--;
      }
    }, 1000, 1000); // 1 sec or 1000 ms
  }
  
  public void show(int xCoreImage,int yCoreImage,int size){ // show pics
    image(img,xCoreImage,yCoreImage,size,size);
  }
  
}
