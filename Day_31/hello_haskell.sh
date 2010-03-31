type -P ghc &>/dev/null || exit 1;

echo 'main = putStrLn "Hello from Haskell"' > hello.hs
ghc -o hello hello.hs && ./hello
rm hello.hs hello.hi hello.o hello
