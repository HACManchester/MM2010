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
# Ruby
echo 'print "Hello from Ruby\n"' | ruby
perl -e 'print "Hello from Perl\n"'
# C++
echo '#include <iostream>' > hello.cpp
echo 'int main() { std::cout << "Hello from C++\n"; return 0;}' >> hello.cpp
g++ -o hello hello.cpp && ./hello

