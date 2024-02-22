## Background

 Author: spipm
 Category: Binaries / Reversing
 Difficulty: Medium to Hard

Credits for the tiny PE to go Alexander Sotirov's [Tiny PE article](http://www.phreedom.org/research/tinype/).

## Technical

This PE binary xors the flag with user input and another buffer. It uses Beep for timing between threads. Besides jumping all over the headers to make analysis harder, it uses tricks like:

- Uses PEB to look up functions in kernel32
- Function lookup uses custom hash method to make static analysis harder
- Checks IsBeingDebugged at the same time to make dynamic analysis harder

See the source for details.

## Story

A confused PE binary has a bad case of the beeps. "It's hard being a beeping binary. Lately I've been beeping and I don't even know where the beeps are coming from. It's like I'm unconsciously beeping before my beeps even beep."
Can you figure out where the beeps are coming from? 

<img src="./Beep.jpg" width="500">

## Exploit

Reverse the binary, because it isn't that big. However, one needs to figure out how functions are resolved, or you need to disable the anti-debugging features. Decompilation tools have trouble understanding the execution in the header though.

## Flag

brck{C0DE_1n_th3_B33p1nG_H43d3R}