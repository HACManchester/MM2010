SHELL = /bin/sh
JAVAC = javac
HASKELL = ghc

target_files = chello cpphello Hello.class hshello

.SUFFIXES:
.SUFFIXES: .c .o .java .class

.PHONY: clean run

all: $(target_files)

chello: hello.c
	$(CC) -c $< -o $@

cpphello: hello.cpp
	$(CXX) -c $< -o $@

Hello.class: Hello.java
	$(JAVAC) $<

hshello: hello.hs
	$(HASKELL) -o $@ $<

clean:
	-rm -f $(target_files)
