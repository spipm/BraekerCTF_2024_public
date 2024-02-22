## Background

 Author: spipm
 Category: Binaries / Reversing
 Difficulty: Hard

Credits for the small Macho to go Kamil.S on [StackOverflow](https://stackoverflow.com/questions/32453849/minimal-mach-o-64-binary).

## Technical

This Macho binary lives in its header commands. Header commands are like Macho segment headers. During execution it xors the flag a bunch of times, and checks if it matches argv[0].

It has two bogus LC_THREAD commands for confusing the entry point for decompilers, and it uses ptrace() for anti debugging. It also does calls to itself all over the place so the call graph doesn't make sense.

Tested on 64-bit Macbook Pro (21.6.0 Darwin Kernel).

## Story

Another bot needs your help! This time a Macho robot started giving itself commands, lots of them! What's going on in its head?

![Injecting commands](./macho_robot.jpg "Injecting commands")

## Exploit

Reverse the binary. This is a work of madness, so it requires some madness. Because the binary is so small, one can statically reverse it, however, it's supposed to be a pain.

The program expects the flag to be in [argv[0]](https://jameshfisher.com/2017/02/05/how-do-i-use-execve-in-c/).

```
./solve "brck{Y0U_M4cho_C0mm4ndr}"
Main program started
🥰
```

## Flag

brck{Y0U_M4cho_C0mm4ndr}