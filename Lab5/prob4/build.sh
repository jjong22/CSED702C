gcc -m32 -I /usr/include/x86_64-linux-gnu -c -o shellcode.o shellcode.S
objcopy -S -O binary -j .text shellcode.o shellcode.bin
rm shellcode.o