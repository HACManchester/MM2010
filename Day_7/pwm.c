/*******************************************************************
 * March Madness - 2010 for HACMan.org.uk - 7th March entry
 * by Bob "parag0n" Clough (parag0n@ivixor.net)
 * Code released under the GNU General Public License version 3.0
 *******************************************************************
 * This program makes an RGB LED change colour when a hex colour 
 * code is sent to it over the serial port.
 *******************************************************************/

#define F_CPU 8000000UL
#define USART_BAUDRATE 9600
#define BAUD_PRESCALE (((F_CPU / (USART_BAUDRATE * 16UL))) - 1) 

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define bit_get(p,m) ((p) & (m))
#define bit_set(p,m) ((p) |= (m))
#define bit_clear(p,m) ((p) &= ~(m))
#define bit_flip(p,m) ((p) ^= (m))
#define bit_write(c,p,m) (c ? bit_set(p,m) : bit_clear(p,m))
#define BIT(x) (0x01 << (x))
#define LONGBIT(x) ((unsigned long)0x00000001 << (x)) 

#define RED OCR0A
#define BLUE OCR1AL
#define GREEN OCR1BL

uint8_t cmdpos = 0;
uint8_t newr = 0;
uint8_t newg = 0;
uint8_t newb = 0;

void pwm_init (void)
{
	TCNT0 = 0;
	OCR0A  = 0;
	TCCR0A = BIT(COM0A1) | BIT(WGM00) | BIT(WGM01);
	TCCR0B = BIT(CS01);	

	TCNT1  = 0;
	OCR1A  = 0;
	OCR1B  = 0;
	TCCR1A = BIT(COM1A1) | BIT(COM1B1) | BIT(WGM10) | BIT(WGM12);
	TCCR1B = BIT(CS11);
}

void uart_init (void)
{
	UCSRB |= (1 << RXEN) | (1 << TXEN); 

	UBRRL = BAUD_PRESCALE; 
	UBRRH = (BAUD_PRESCALE >> 8);

	UCSRB |= (1 << RXCIE); 
	sei(); 
}

void uart_tx (unsigned char tx)
{
	while ((UCSRA & (1 << UDRE)) == 0) {};	
	UDR = tx;
}

// converts an ascii hex character to decimal
uint8_t hex2dec (unsigned char hex)
{
	if (hex < 57) return hex - 48; // 0-9
	else if (hex < 70) return hex - 55; //A-F
	else return hex - 87; // a-f
}

int main(void)
{
	uart_init();
	DDRB = BIT(2) | BIT(3) | BIT(4);
	pwm_init();
	while(1)
	{
		_delay_ms(100);
	}
}

ISR(USART_RX_vect) 
{
	uint8_t invert = 0; 
	char rx; 
	rx = UDR;
	uart_tx(rx);

	switch(cmdpos)
	{
		case 0:
			newr = hex2dec(rx)<<4;
			break;			
		case 1:
			newr += hex2dec(rx);
			break;
		case 2:
			newg = hex2dec(rx)<<4;
			break;			
		case 3:
			newg += hex2dec(rx);
			break;
		case 4:
			newb = hex2dec(rx)<<4;
			break;			
		case 5:
			newb += hex2dec(rx);
			break;
	}
	cmdpos++;
	if (rx == '#') cmdpos = 0;
	if (rx == 'i')
	{
		uart_tx('\r');
		uart_tx('\n');
		uart_tx('I');
		uart_tx('N');
		uart_tx('V');
		uart_tx('\r');
		uart_tx('\n');
		invert = !invert;
		cmdpos = 0;
	}
	if (rx == '\r')
	{
		if (!invert)
		{
			RED = 255-newr;
			GREEN = 255-newg;
			BLUE = 255-newb;
		}
		else
		{
			RED = newr;
			GREEN = newg;
			BLUE = newb;	
		}
		cmdpos = 0;
		uart_tx('\n');
		uart_tx('O');
		uart_tx('K');
		uart_tx('\r');
		uart_tx('\n');
	}
}
