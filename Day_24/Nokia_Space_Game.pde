#include <nokia_3310_lcd.h>
// ****************************************************************
// March Madness - 2010 for HacMan.org.uk - 24th March entry
// Entry by Paul 'Tallscreen' Plowman    madstunts@hotmail.com
// Code released under the GNU General Public License version 3.0
//
// This is a simple game for the Arduino with a Nokia 3310 LCD
// Shield as produced by Nu Electronics (www.nuelectronics.com)
//
// Fly your 'Spaceship' and avoid the 'Asteroids'
//
// ****************************************************************


// joystick number
#define UP_KEY 3
#define LEFT_KEY 0
#define CENTER_KEY 1
#define DOWN_KEY 2
#define RIGHT_KEY 4

Nokia_3310_lcd lcd=Nokia_3310_lcd();

int pos[15];
int shipy;
int conseckey;

// ======================================================
void setup() {
  lcd.LCD_3310_init();
  lcd.LCD_3310_clear();

  // Fill the asteroid array with 10 (offscreen)
  for(int n=0;n<13;n++)
    {
    pos[n]=10;
    }

  // Vertical position of ship
  shipy = 3;

  // No. of loops with same consecutive keypress
  conseckey = 0;
  }
  
// ======================================================
void loop() {
  int n;
  char keypress;
  char oldkeypress;
  
  // Move asteroids
  lcd.LCD_3310_set_XY(0,pos[0]);
  if(pos[0]<7) { lcd.LCD_3310_write_char(32, MENU_NORMAL); }

  // For each horizontal 'column'
  for(int n=0;n<13;n++)
    {
    // move asteroid from previous 'column'
    pos[n] = pos[n+1];
    // Blank old asteroid
    lcd.LCD_3310_set_XY((n+1)*6,pos[n]);
    if(pos[n]<7) { lcd.LCD_3310_write_char(32, MENU_NORMAL); }
    // Draw new asteroid (letter 'o')
    lcd.LCD_3310_set_XY((n)*6,pos[n]);
    if(pos[n]<7) { lcd.LCD_3310_write_char(111, MENU_NORMAL); }
    }
  // Randomize next asteroid on screen
  pos[13] = random(6);
  lcd.LCD_3310_set_XY(78,pos[13]);
  lcd.LCD_3310_write_char(111, MENU_NORMAL);


  // If there's a collision
  if (pos[0]==shipy)
    {
    // Print random chars 10000 times for poor man's explosion
    for(n=0;n<10000;n++)
      {
      lcd.LCD_3310_set_XY(0,shipy);
      lcd.LCD_3310_write_char(48+random(64), MENU_NORMAL);
      }
    // Clear screen
    lcd.LCD_3310_clear();
    // Reset ship
    shipy=3;
    // Reset asteroids
    for(int n=0;n<13;n++)
      {
      pos[n]=10;
      }
    }

  // Draw ship
  drawship();

  // Pause loop
  for(n=0;n<3000;n++)
    {
    oldkeypress = keypress;
    keypress = get_key();

  // If the input is same as last time round the loop, increment conseckey
    if(keypress==oldkeypress)
      { conseckey++; }
     else
      { conseckey=0; }
     
  // This is so once the ship has moved, it doesn't move again until you release the joystick and press it again
    if(conseckey>2000) { conseckey=2000; }

   // If Up has been pressed for last 500 loops, then move up
    if((keypress==UP_KEY)&&(conseckey==500)&&(shipy>0))
      {
      shipy--;
      drawship();
      // Then blank old ship
      lcd.LCD_3310_set_XY(0,shipy+1);
      lcd.LCD_3310_write_char(32, MENU_NORMAL);
      }

   // If Down has been pressed for last 500 loops, then move up
    if((keypress==DOWN_KEY)&&(conseckey==500)&&(shipy<5))
      {
      shipy++;
      drawship();
      // Then blank old ship
      lcd.LCD_3310_set_XY(0,shipy-1);
      lcd.LCD_3310_write_char(32, MENU_NORMAL);
      }
    }

  }

// ======================================================

// The joystick is on an analogue input which returns a different voltage for each direction
char get_key() {
  char k;
  int  adc_key_val[5] ={30, 150, 360, 535, 760 };
  unsigned int input = analogRead(0);
  for (k = 0; k < 5; k++)
    {
    if (input < adc_key_val[k]) { return k; }
    }
    if (k >= 5) { k = -1; }    // No joystick direction pressed
    return k;
  }

// Custom graphic for ship
void drawship()
  {
  unsigned int shipgfx[6] ={62, 28, 127, 54, 28, 8 };
  for(int n=0;n<6;n++)
    {
    lcd.LCD_3310_set_XY(n,shipy);
    lcd.LCD_3310_write_byte(shipgfx[n],1);
    }
  }

