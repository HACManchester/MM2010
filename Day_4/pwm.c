/*******************************************************************
 * March Madness - 2010 for HACMan.org.uk - 4th March entry
 * by Bob "parag0n" Clough (parag0n@ivixor.net)
 * Code released under the GNU General Public License version 3.0
 *******************************************************************
 * This program makes an RGB LED scroll through all the colours.
 *******************************************************************/


#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>

#define bit_get(p,m) ((p) & (m))
#define bit_set(p,m) ((p) |= (m))
#define bit_clear(p,m) ((p) &= ~(m))
#define bit_flip(p,m) ((p) ^= (m))
#define bit_write(c,p,m) (c ? bit_set(p,m) : bit_clear(p,m))
#define BIT(x) (0x01 << (x))
#define LONGBIT(x) ((unsigned long)0x00000001 << (x)) 
#define RED OCR0A
#define GREEN OCR1A
#define BLUE OCR1B
#define SPEED 5

int main(void)
{

	DDRB = BIT(2) | BIT(3) | BIT(4);

	TCNT0 = 0;
	OCR0A  = 255;
	TCCR0A = BIT(COM0A1) | BIT(WGM00) | BIT(WGM01);
	TCCR0B = BIT(CS01);	

	TCNT1  = 0;
	OCR1A  = 255;
	OCR1B  = 255;
	TCCR1A = BIT(COM1A1) | BIT(COM1B1) | BIT(WGM10) | BIT(WGM12);
	TCCR1B = BIT(CS11);


	while(1)
	{
		int x = 0;
		for (x=0; x<255; x++) 
		{
			BLUE = 255-x;
			RED = x;
			_delay_ms(SPEED);
		}
		for (x=0; x<255; x++) 
		{
			GREEN = 255-x;
			BLUE = x;
			_delay_ms(SPEED);
		}
		for (x=0; x<255; x++) 
		{
			RED = 255-x;
			GREEN = x;
			_delay_ms(SPEED);
		}		


	}
}
