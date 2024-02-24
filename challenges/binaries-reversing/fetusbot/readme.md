## Background

    Author: spipm
    Category: Binaries / Reversing
    Difficulty: Medium

Credits for the small assembly ELF to go Brian Raiter [Teensy ELF article](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html). The ROP chain is a variant of [this](https://www.exploit-db.com/exploits/46907) exploit-db entry by rajvardhan.

## Technical

This 64 bit PE writes user input to the stack and immediately `ret`s. It also has NX enabled, making this a ROP challenge. 

## Story

Our android mother has reached her third trimester, where she started to experience some pain in the right lower back. Before the doctor advises pelvic tilt exercises, you get called on the job for a procedural check on the fetus's programming. 

In the code, you see that the fetus is indeed requesting input, but it also seems to have developed a protective mechanism to prevent execution of your data!

Can you hack the fetus and her mother back to health?

<img src="./fetal_stage.jpeg" width="500">

## Exploit

Users need to figure out that RAX is set by the amount of bytes that they send, and that RCX already points to a ret instruction. The idea for the ROP chain is:

```
(no need to set RAX, just send 59 bytes)
sar rsi, 63 		(zero rsi)
mov rdi, rsp 		(move rdi to stack)
add dil, 16 		(set rdi to bin/sh buffer)
jmp rcx 			(rcx = ret by default)
cdq 				(zero out rdx)
syscall 			(call sys_execve)
```

Also see the source code and solve.py.

## Flag

The flag and the challenge name are a play on words to match a ROP chain with the [Right Occiput Posterior (ROP)](https://www.spinningbabies.com/pregnancy-birth/baby-position/other-fetal-positions/right-occiput-posterior/) fetal position.

brck{Th4ts_A_h34ltHy_R1ght_0cc1put_P0st3r10r}