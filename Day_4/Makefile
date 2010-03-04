CC=avr-gcc
CFLAGS=-g -Os -Wall -mcall-prologues -mmcu=attiny2313
OBJ2HEX=avr-objcopy 
TARGET=pwm

%.obj : %.o
	$(CC) $(CFLAGS) $< -o $@

%.hex : %.obj
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

clean :
	rm -f *.hex *.obj *.o


