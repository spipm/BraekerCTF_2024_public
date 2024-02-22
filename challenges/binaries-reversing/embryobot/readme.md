## Background

 Author: spipm
 Category: Binaries / Reversing
 Difficulty: Easy to Medium

Credits for the small assembly ELF to go Brian Raiter [Teensy ELF article](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html).

## Technical

This 32 bit PE binary is a 76 byte pwnable that immediately overwrites itself with input from stdin. Users only get two bytes, which they can use to jmp back to the start of their input.

## Story

"This part will be the head, " the nurse explains. The proud android mother looks at her newborn for the first time. "However, " the nurse continues, "we noticed a slight growing problem in its code. Don't worry, we have a standard procedure for this. A human just needs to do a quick hack and it should continue to grow in no time." 

The hospital hired you to perform the procedure. Do you think you can manage? 

The embryo is:
f0VMRgEBAbADWTDJshLNgAIAAwABAAAAI4AECCwAAAAAAADo3////zQAIAABAAAAAAAAAACABAgAgAQITAAAAEwAAAAHAAAAABAAAA==

![Robot ELF](./robot_elf.jpg "Robot ELF")

## Exploit

User can only write 2 bytes, which they have to use to jmp to ecx, which points to the start of their input. Then they either use very compact code to read the flag (if possible) or they just overwrite the program again and write whatever shellcode they want.

## Flag

brck{Th3_C1rcl3_0f_l1f3}
