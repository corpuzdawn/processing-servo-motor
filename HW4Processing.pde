/* Created by: Dawn Christine P. Corpuz
 CIE 150 Homework 3
 SERVO MOTOR
 */
import processing.serial.*;
Serial myPort;

HScrollbar hs1;  //scrollbar
int angle; 

void setup() {
  size(377, 200);
  
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  
  noStroke(); 
  hs1 = new HScrollbar(0, height/2+30, width, 16, 16);
}
void draw() {
  background(235, 150, 130); 
  hs1.update();
  hs1.display();
  stroke(170);
  line(2, height/2+22, width, height/2+22);
  line(2, height/2+38, width, height/2+38);
  
  
  angle = ((int) hs1.getPos())/2;
  textAlign(CENTER);
  fill(255);
  textFont(createFont("Bebas Neue", 70));
  text(angle,width/2,height/2);
  
  myPort.write(angle);

}


class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = sw / widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(230);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
       fill(20, 170, 177);
    } else {
       fill(120, 170, 177);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
    
  }
}

/*//ARDUINO CODE
#include <Servo.h>
Servo myservo;              
int pos= 0;               

void setup()
{
  myservo.attach(9);        
  Serial.begin(9600);       
}

void loop()
{
 if (Serial.available())   
  {
    pos = Serial.read();   
  }
  myservo.write(pos);      
  delay(15);  
}
*/
