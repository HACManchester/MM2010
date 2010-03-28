// LoL Shield Horizontal/Vertical Fill Test Program
// Simon Ward
// 28 March 2010
//
// Based on LoL Shield Program by Jimmie P Rodgers  www.jimmieprodgers.com
// LoL Shield Project: http://jimmieprodgers.com/kits/lolshield/
// Software: http://code.google.com/p/lolshield/

#include <avr/pgmspace.h>  //This is in the Arduino library 

int blinkdelay = 75; //This basically controls brightness. Lower is dimmer
int runspeed = 20;   //smaller = faster

int pin13 =13;
int pin12 =12;
int pin11 =11;
int pin10 =10;
int pin09 =9;
int pin08 =8;
int pin07 =7;
int pin06 =6;
int pin05 =5;
int pin04 =4;
int pin03 =3;
int pin02 =2;

const int pins[] = {
  pin13,pin12,pin11,pin10,pin09,pin08,pin07,pin06,pin05,pin04,pin03,pin02};

const int ledMap[126][2] ={
{pin13, pin05},{pin13, pin06},{pin13, pin07},{pin13, pin08},{pin13, pin09},{pin13, pin10},{pin13, pin11},{pin13, pin12},{pin13, pin04},{pin04, pin13},{pin13, pin03},{pin03, pin13},{pin13, pin02},{pin02, pin13},
{pin12, pin05},{pin12, pin06},{pin12, pin07},{pin12, pin08},{pin12, pin09},{pin12, pin10},{pin12, pin11},{pin12, pin13},{pin12, pin04},{pin04, pin12},{pin12, pin03},{pin03, pin12},{pin12, pin02},{pin02, pin12},
{pin11, pin05},{pin11, pin06},{pin11, pin07},{pin11, pin08},{pin11, pin09},{pin11, pin10},{pin11, pin12},{pin11, pin13},{pin11, pin04},{pin04, pin11},{pin11, pin03},{pin03, pin11},{pin11, pin02},{pin02, pin11},
{pin10, pin05},{pin10, pin06},{pin10, pin07},{pin10, pin08},{pin10, pin09},{pin10, pin11},{pin10, pin12},{pin10, pin13},{pin10, pin04},{pin04, pin10},{pin10, pin03},{pin03, pin10},{pin10, pin02},{pin02, pin10},
{pin09, pin05},{pin09, pin06},{pin09, pin07},{pin09, pin08},{pin09, pin10},{pin09, pin11},{pin09, pin12},{pin09, pin13},{pin09, pin04},{pin04, pin09},{pin09, pin03},{pin03, pin09},{pin09, pin02},{pin02, pin09},
{pin08, pin05},{pin08, pin06},{pin08, pin07},{pin08, pin09},{pin08, pin10},{pin08, pin11},{pin08, pin12},{pin08, pin13},{pin08, pin04},{pin04, pin08},{pin08, pin03},{pin03, pin08},{pin08, pin02},{pin02, pin08},
{pin07, pin05},{pin07, pin06},{pin07, pin08},{pin07, pin09},{pin07, pin10},{pin07, pin11},{pin07, pin12},{pin07, pin13},{pin07, pin04},{pin04, pin07},{pin07, pin03},{pin03, pin07},{pin07, pin02},{pin02, pin07},
{pin06, pin05},{pin06, pin07},{pin06, pin08},{pin06, pin09},{pin06, pin10},{pin06, pin11},{pin06, pin12},{pin06, pin13},{pin06, pin04},{pin04, pin06},{pin06, pin03},{pin03, pin06},{pin06, pin02},{pin02, pin06},
{pin05, pin06},{pin05, pin07},{pin05, pin08},{pin05, pin09},{pin05, pin10},{pin05, pin11},{pin05, pin12},{pin05, pin13},{pin05, pin04},{pin04, pin05},{pin05, pin03},{pin03, pin05},{pin05, pin02},{pin02, pin05}
};

void turnon(int led) {
  int pospin = ledMap[led][0];
  int negpin = ledMap[led][1];
  pinMode (pospin, OUTPUT);
  pinMode (negpin, OUTPUT);
  digitalWrite (pospin, HIGH);
  digitalWrite (negpin, LOW);
}

void turnoff(int led) {
  pinMode(ledMap[led][0], INPUT);
  pinMode(ledMap[led][1], INPUT);
}

void alloff() {
  // This port manipulation breaks on the Mega
  //DDRD = B00000010;
  //DDRB = B00000000; 
  for (int pin=2; pin<14; pin++) {
    pinMode(pin, INPUT);
  }
}

// Progressively light/unlight columns from left to right
// on: if true, turn on successive columns; if false, turn off successive
// columns
void ScanColumns(bool on)
{
  byte pin;
  for (byte col=1; col<=14; col++) {
    for (int run=0; run<runspeed; run++) {
      for (byte row=0; row<9; row++) {
        for (byte led=0; led<14; led++) {
          if ((on && led<col) || (!on && led>=col)) {
            pin = row*14 + led;
            turnon(pin);
            delayMicroseconds(blinkdelay);
            turnoff(pin);
          }
          else delayMicroseconds(blinkdelay);
        }
      }
    }
  }
}

// Progressively light/unlight rows from top to bottom
void ScanRows(bool on)
{
  byte pin;
  for (byte row=1; row<=9; row++) {
    for (int run=0; run<runspeed; run++) {
      for (byte col=0; col<14; col++) {
        for (byte led=0; led<9; led++) {
          if ((on && led<row) || (!on && led>=row)) {
            pin = led*14 + col;
            turnon(pin);
            delayMicroseconds(blinkdelay);
            turnoff(pin);
          }
          else delayMicroseconds(blinkdelay);
        }
      }
    }
  }
}

void blinkall(int numblink) {
  alloff();
  for(int n = 0;n < numblink;n++) {
    for(int i = 0; i < runspeed; i++) {
      for(int j = 0; j < 126; j++) {
        turnon(j);
        delayMicroseconds(blinkdelay);
        alloff();
      }
    }
    delay(500);
  }
}

void setup() {
  blinkall(2); // useful for testing
}

void loop() {
  // Horizontal on
  ScanColumns(true);
  delay(20);

  // Horizontal off
  ScanColumns(false);
  delay(20);

  // Vertical on
  ScanRows(true);
  delay(20);

  // Vertical off
  ScanRows(false);
  delay(20);
}
