## Background

    Author: spipm
    Category: Binaries / Reversing
    Difficulty: Medium

Credits for the small assembly ELF to go Brian Raiter [Teensy ELF article](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html).

## Technical

This 64 bit ELF binary decodes the flag, prints a smiley face, and then exits. The challenge is to figure out what the flag is, but the binary uses tricks to prevent debugging and even static analysis. Tricks used are:

- Bytecode in ELF magic padding to break gdb.
- Bytecode in segment headers breaks a bunch of stuff.
- Setting p_filesz and p_memsz to 1 to do almost any analyzer in.

## Story

After hearing about young computer problems, you have decided to become a computer shrink. Your first patient is a robot elf.

"A little machine dream I keep having, " she says. "But when it is over, I always forget the end. I've captured the dream's program, but I don't dare look".

Can you run the program for her? Are you able to figure out what's in her memory right before execution stops?

<img src="./robot_elf.jpg" width="500">

## Exploit

One can just manually reverse the binary because it is so small. I used readelf and objdump to 'debug' it (see Makefile), and I used core dumps by injecting 0xcc (int3) near the end to double-check if the binary would properly decode the flag.

## Flag

brck{4n_eLF_He4d_FuLL_0F_M4DNESS}