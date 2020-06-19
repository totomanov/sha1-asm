# sha1-asm
Implementation of the SHA-1 hash function implementation in AT&amp;T syntax x86 Assembly. It works on the 512-bit data chunks directly, 
so the preprocessing and chunking phases of the algorithm are not implemented.
The program was created as a part of the Computer Organisation course at TU Delft.
The [pseudocode from Wikipedia](https://en.wikipedia.org/wiki/SHA-1#Examples_and_pseudocode) was very useful in the development process.

# Running on Linux
1. Clone this repo in a new directory.
```
git clone https://github.com/totomanov/sha1-asm.git
```
2. Assemble the program with GCC.
```
gcc -no-pie -o sha1 sha1.s
```
3. Execute the binary
```
./sha1
```

# Debugging
1. Pass the ```-g``` flag to GCC.
```
gcc -g -no-pie -o sha1 sha1.s
```
2. Start the debugger.
```
gdb ./sha1
```
