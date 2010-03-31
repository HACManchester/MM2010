echo 'Hello from Bash'
echo 'print "Hello from Python"' | python
php -r 'echo "Hello from PHP\n";' 2>/dev/null
echo '#include <stdio.h>' > hello.c
echo 'int main() { printf("Hello from c\n"); return 0;}' >> hello.c
gcc -o hello hello.c && ./hello
echo 'print "Hello from Ruby\n"' | ruby
perl -e 'print "Hello from Perl\n"'
echo '#include <iostream>' > hello.cpp
echo 'int main() { std::cout << "Hello from C++\n"; return 0;}' >> hello.cpp
g++ -o hello hello.cpp && ./hello
