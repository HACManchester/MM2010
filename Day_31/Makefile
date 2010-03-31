SHELL = /bin/sh
JAVAC = javac

files = chello cpphello Hello.class

.SUFFIXES:
.SUFFIXES: .c .o .java .class

.PHONY: clean

all: $(files)

chello: hello.c
	$(CC) -c $< -o $@

cpphello: hello.cpp
	$(CXX) -c $< -o $@

Hello.class: Hello.java
	$(JAVAC) $<

clean:
	-rm -f $(files)

