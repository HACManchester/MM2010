#!/usr/bin/python

##################################################################
# March Madness - 2010 for HACMan.org.uk - 21st March entry
# by Bob "parag0n" Clough (parag0n@ivixor.net)
# Code released under the GNU General Public License version 3.0
##################################################################
# This program sends the rgb colour code of the bottom left pixel
# of the screen to an RGB sphere every second!  Yaay!
##################################################################

import gtk.gdk threading serial

def get_colour():
	w = gtk.gdk.get_default_root_window()
	sz = w.get_size()
	pb = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB,False,8,1,1)
	pb = pb.get_from_drawable(w,w.get_colormap(),0,sz[1]-1,0,0,1,1)
	pa = pb.get_pixels()
	colour = "#%02x%02x%02x\r" % (ord(pa[0]), ord(pa[1]), ord(pa[2]))
        ser = serial.Serial("/dev/rfcomm0", 9600)
	ser.write(colour)
	ser.close()
	t = threading.Timer(1, get_colour).start()

t = threading.Timer(1, get_colour).start()
