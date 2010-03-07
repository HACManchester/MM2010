#!/usr/bin/python

##################################################################
# March Madness - 2010 for HACMan.org.uk - 7th March entry
# by Bob "parag0n" Clough (parag0n@ivixor.net)
# Code released under the GNU General Public License version 3.0
##################################################################
# This program sends a rgb colour code chosen by the user to the
# serial port when.
##################################################################


import pygtk, gtk, sys, serial

def dec2hex(n):
	"""return the hexadecimal string representation of integer n"""
	n = int(n)
	if n == 0:
		return "00"
	return "%0.2X" % n

class ColourSel:
	def __init__(self, ser):
		self.ser = ser

		window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		window.set_title("Colour changer")
		window.set_resizable(False)
		window.connect("delete_event", self.destroywindow)

		self.colourchooser = gtk.ColorSelection()
		self.colourchooser.connect("color-changed", self.changecolour)		

		window.add(self.colourchooser)

		self.colourchooser.show()
		window.show()

	def destroywindow(self, widget, event):
		gtk.main_quit()

	def changecolour(self, widget, data=None):
		colour = widget.get_current_color()
		string = "#"	
		string = string + dec2hex(int( (float(colour.red) / 65535)*255))
		string = string + dec2hex(int( (float(colour.green) / 65535)*255))
		string = string + dec2hex(int( (float(colour.blue) / 65535)*255))
		self.ser.write(string + "\r")

def main():
	gtk.main()
	return 0

if __name__ == "__main__":
	ser = serial.Serial("/dev/rfcomm0", 9600)
	ColourSel(ser)
	main()
