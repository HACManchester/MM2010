# Bash
echo 'Hello from Bash'
# Python
echo 'print "Hello from Python"' | python
# PHP
php -r 'echo "Hello from PHP\n";' 2>/dev/null
# C
echo '#include <stdio.h>' > hello.c
echo 'int main() { printf("Hello from c\n"); return 0;}' >> hello.c
gcc -o hello hello.c && ./hello
rm hello.c hello
# Ruby
echo 'print "Hello from Ruby\n"' | ruby
perl -e 'print "Hello from Perl\n"'
# C++
echo '#include <iostream>' > hello.cpp
echo 'int main() { std::cout << "Hello from C++\n"; return 0;}' >> hello.cpp
g++ -o hello hello.cpp && ./hello
rm hello.cpp hello
# Java
echo 'class Hello { public static void main(String[] args) { System.out.println("Hello from Java"); }}' > hello.java
javac hello.java
java Hello
rm hello.java Hello.class
# brainfuck
echo '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<---------.++++++++++++.---.--.>.<<------.>+++++.-----------------.++++++++.+++++.--------.+++++++++++++++.------------------.++++++++.>+.>.' > hello.bf
bf hello.bf
rm hello.bf
# BASIC
yabasic -e 'PRINT "Hello from BASIC"'
# Haskell
echo 'main = putStrLn "Hello from Haskell"' > hello.hs
ghc -o hello hello.hs && ./hello
rm hello.hs hello.hi hello.o hello
