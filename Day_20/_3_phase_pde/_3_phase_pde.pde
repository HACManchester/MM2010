/*

3-phase controller.
 
This circuit fades 6 LED's in sequence, 
in a 3-phase diamond wave - a sine wave 
is a little difficult to accomplish in
the digital domain.  But a few capacitors 
will probably smooth things out.

I think it will still make a decent motor
controller though.  Just need to build
some seriously high power amps now.

Each LED is wired thus:
pin out
LED
resistor
ground

- lay out your green LED's along the top
and the red ones along the bottom.  
channels:
top row: 3, 5, 6
botom: 9, 10, 11

 */

// set the start positions of the various waves
int blueup = 255;
int bluedown = 0;
int blackup = 0;
int blackdown = 85;
int redup = 0;
int reddown = 85;

/* 
Set the directions of travel
You can change these values to 1  if 
you want a smoother wave - but you will 
also need to change them lower down,
otherwise you will break the program.

x's are for the upper half of the wave, 
y's are for the lower half of the wave
*/
int x1 = 5;
int x2 = 0;
int x3 = 0;
int y1 = 0;
int y2 =-5;
int y3 = 5;


//set the LED's to the various PWM channels
int ledPin3 = 3;    // LED connected to digital pin 3
int ledPin5 = 5;    // ...etc
int ledPin6 = 6;   
int ledPin9 = 9;   
int ledPin10 = 10; 
int ledPin11 = 11; 

void setup()  
{  
//  Serial.begin(9600);
}



void loop()
{
/* 
These lines are for if you want to monitor 
the output on the various values, check that
your waves are runnning the right way and to 
the correct values
*/

//  Serial.print("blueup, ");
//  Serial.println(blueup);
//  Serial.print("bluedown, ");
//  Serial.println(bluedown);
//  Serial.print(",x1, ");
//  Serial.print(x1);
//  Serial.print(",y1, ");
//  Serial.print(y1);

//  Serial.print("blackup, ");
//  Serial.println(blackup);
//  Serial.print("blackdown, ");
//  Serial.println(blackdown);
//  Serial.print(",x2, ");
//  Serial.print(x2);
//  Serial.print(",y2, ");
//  Serial.print(y2);


//  Serial.print("redup, ");
//  Serial.println(redup);
//  Serial.print("reddown, ");
//  Serial.println(reddown);
//  Serial.println("");
//  Serial.print(",x3, ");
//  Serial.print(x3);
//  Serial.print(",y3, ");
//  Serial.print(y3);

/* 
assign the various integers (above) 
to the various pins.
*/
  analogWrite(ledPin3, blueup);
  analogWrite(ledPin9, bluedown);
  analogWrite(ledPin5, blackup);
  analogWrite(ledPin10, blackdown);
  analogWrite(ledPin6, redup);
  analogWrite(ledPin11, reddown);

/*
this section checks whether you have 
reached the top or bottom of this half 
of the phase.  If you have, it then 
causes the other half of the phase to 
ramp up
*/

  if ((blueup == 255) & (x1 == 5))
    {
      x1 = -5;
    }

  if ((blueup == 0) & (x1 == -5))
    {
      x1 = 0;
      y1 = +5;
    }
    
  if ((blackup == 255) & (x2 == 5))
    {
      x2 = -5;
    }

  if ((blackup == 0) & (x2 == -5))
    {
      x2 = 0;
      y2 = + 5;
      
    }
    
  if ((redup == 255) & (x3 == 5))
    {
      x3 = -5;
    }

  if ((redup == 0) & (x3 == -5))
    {
      x3 = 0;
      y3 = +5;
    }
    
  if ((bluedown == 255) & (y1 == 5))
    {
      y1 = -5;
    }

  if ((bluedown == 0) & (y1 == -5))
    {
      y1 = 0;
      x1 = 5;
    }
    
  if ((blackdown == 255) & (y2 == 5))
    {
      y2 = -5;
    }

  if ((blackdown == 0) & (y2 == -5))
    {
      y2 = 0;
      x2 = 5;
    }
    
  if ((reddown == 255) & (y3 == 5))
    {
      y3 = -5;
    }

  if ((reddown == 0) & (y3 == -5))
    {
      y3 = 0;
      x3 = 5;
    }
 
/*
This section is where the waves are powered up or down. 
If you add a positive value to a number, it increments.
But if you add a negative number it /de/crements.  

In this way, the pos/neg flipping above makes the waves
travel in the right direction when we do the addition 
down here.
*/
blueup = blueup + x1;
blackup = blackup + x2;
redup = redup + x3;

bluedown = bluedown + y1;
blackdown = blackdown + y2;
reddown = reddown + y3;

/*
This delay is only here so that you can see your waves 
flowing across the board.  It runs /way/ faster without 
the delay instruction.

Later iterations will have a variable resistor controlling
the speed.
*/
// delay (40);

}
