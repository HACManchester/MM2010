CC=avr-gcc
CFLAGS=-g -Os -Wall -mcall-prologues -mmcu=attiny13
OBJ2HEX=avr-objcopy 
TARGET=lvw

%.obj : %.o
	$(CC) $(CFLAGS) $< -o $@

%.hex : %.obj
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

clean :
	rm -f *.hex *.obj *.o


