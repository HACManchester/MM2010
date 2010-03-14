void tree(float x, float y, float angle, float h, float twist)
{
  if(h<4) return;
  float endX = x + h*cos(radians(angle));
  float endY = y - h*sin(radians(angle));
  line(x,y,endX,endY);
  tree(endX,endY,angle+random(0,45)+twist,h*0.6,twist);
  tree(endX,endY,angle+random(-45,0)+twist,h*0.6,twist);
  if(h>10) 
    tree(endX,endY,angle+random(-10,10)+twist,h*0.6,twist);  
}

int frameCount;
int seed;

void setup()
{
    size(640,480);
    frameCount = 0;
    seed = int(random(256));
}

void draw()
{
  randomSeed(seed);
  background(0);
  frameCount++;
  stroke(0,255,0);
  float twist =  5*sin(radians(frameCount*3))
               + 5*sin(radians(frameCount*7))
               + 5*sin(radians(frameCount*8));
  tree(320,480,90,180,twist);
}
