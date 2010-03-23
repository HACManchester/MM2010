/***************************************************
 March Madness for HACMan.org.uk - 23rd March 
 entry by Bob "parag0n" Clough  (parag0n@ivixor.net)
 Released under the GNU General Public License v3.0

****************************************************

 Low Voltage Warning for attiny13

 This program monitors a voltage on ADC2 of an
 ATTINY13, and if its below 6v, turns an output
 on.  It is meant to be linked to an interrupt
 pin of a secondary microcontroller, to warn it
 when a lipo battery is about to die.

***************************************************/

#define F_CPU 10000000UL
#include <avr/io.h>
#include <util/delay.h>

// delay for up to 65k milliseconds
void delayms(uint16_t millis) 
{
	// loop, delaying 1ms each iteration
	while ( millis ) 
	{
		_delay_ms(1);
		millis--;
	}
}

// initialise the adc
void init_adc ( void )
{
	//select external (VCC) voltage as the reference voltage (x0xx xxxx) 
	ADMUX = 0x00;
	//enable ADC (1000 0000)
	ADCSRA |= 0x80;
}

// read the specified adc
int adc_read ( uint8_t n )
{
	// set the adc to the chosen channel
	ADMUX = n;
	// start the ADC conversion, set the ADC clock to cpu clock / 16 (0100 0100)
	ADCSRA |= 0x44;
	// wait for the adc conversion to be completed
	while((ADCSRA & 0x40) !=0){};
	// return the adc result
	return ADC;
}

int main(void) 
{
	// set PB0 to output
	DDRB |= 1<<PB3;
	// turn on the ADC
	init_adc();
	// set up our variables
	int reading = 0, prev = 0, temp = 0;
	// loop for ever
	while(1) {
		// take a new adc reading
		reading = adc_read(2);
		// average it with the previous reading
		temp = (reading + prev) / 2;		
		// if the voltage is less than 6
		if ( temp > 185 )
		{
			// turn the output pin on
			PORTB &= ~(1<<PB3);
		}
		else
		{
			// turn the output pin off
			PORTB |= 1<<PB3; /* LED off */
		} 
		// save the current reading
		prev = reading;
		// wait for 20ms
		delayms(20);
	}
	return 0;
}

