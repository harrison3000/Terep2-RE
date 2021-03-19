## Terep 2 reverse engineering effort

The repository is just me giving a shot at reverse engineering the awesome demo Terep 2 - Deformers by Nagymathe Denes

### Why?
* I want to learn Ghidra
* I like this game
* I want to make it run on a ESP32 or a STM32
* Why not?

### How?

First you have to build dosbox with the debugger enabled.

Then you have to run the terep2.exe with the dosbox debugger

The game is encrypted(?) by something called Guardian Angel, but it doesn't matter, just put a breakpoint on the very first instruction of the decrypted code (for me it was at 01ed:0000, your code segment may be elsewhere) and let it rip

Dump the code segment (23760 bytes) to a file named code.bin

Dump the data segment (62224 bytes) to a file named data.bin

Install the OpenWatcom C compiler and NASM, and then run `make`

???

Profit!
