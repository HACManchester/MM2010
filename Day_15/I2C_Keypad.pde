#include <Wire.h>

void setup()
{
  Serial.begin(9600);
  Wire.begin();
  Wire.beginTransmission(0x20);
  Wire.send(0x01);
  Wire.send(0xF0);
  Wire.endTransmission();
}

void loop()
{
  int i = readKeypad();
  if(i != -3)
    Serial.println(i);
}

int readKeypad()
{
  
  //column 1
  byte data = 0;
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.send(0x01);
  Wire.endTransmission();
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.endTransmission();
  Wire.requestFrom(0x20, 1);
  data = Wire.receive();
  
  
  if(data==0x11)
  {
    delay(500);
    return 1;
  }
  else if(data==0x21)
  {
    delay(500);
    return 4;
  }
  else if(data==0x41)
  {
    delay(500);
    return 7;
  }
  else if(data==0x81)
  {
    delay(500);
    return -1;
  }
  
  
  //column 2
  data = 0;
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.send(0x02);
  Wire.endTransmission();
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.endTransmission();
  Wire.requestFrom(0x20, 1);
  data = Wire.receive();
  
  
  if(data==0x12)
  {
    delay(500);
    return 2;
  }
  else if(data==0x22)
  {
    delay(500);
    return 5;
  }
  else if(data==0x42)
  {
    delay(500);
    return 8;
  }
  else if(data==0x82)
  {
    delay(500);
    return 0;
  }
  
  //column 3
  data = 0;
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.send(0x04);
  Wire.endTransmission();
  Wire.beginTransmission(0x20);
  Wire.send(0x13);
  Wire.endTransmission();
  Wire.requestFrom(0x20, 1);
  data = Wire.receive();
  
  
  if(data==0x14)
  {
    delay(500);
    return 3;
  }
  else if(data==0x24)
  {
    delay(500);
    return 6;
  }
  else if(data==0x44)
  {
    delay(500);
    return 9;
  }
  else if(data==0x84)
  {
    delay(500);
    return -2;
  }
  
  else return -3;
}
