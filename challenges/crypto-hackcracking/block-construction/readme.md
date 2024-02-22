## Background

 Author: spipm
 Category: Crypto / Hashcracking
 Difficulty: Easy to Medium

## Technical

This challenge encrypts every byte of the flag with AES in ECB mode. It randomizes printable characters with the current time, and it uses those characters to pad the AES blocks. The padding continues for a block, making it easy to match blocks with the same plaintext.

## Story

"Sir, sir! This is a construction site." You look up at what you thought was a building being constructed, but you realize it is a construction bot.  "Sir please move aside. I had to have these blocks in order since last week, but some newbie construction bot shuffled them." "I can move aside, " you tell the bot, "but I might be able to help you out."

Can you help the bot get the blocks in order?

<img src="./block_construction.jpeg" width="500">

## Exploit

One can perform a known plaintext attack, because it is known that the plaintext starts with 'brck{'. This can be used to recover the right seed to find the rest of the sequence.

## Flag

The flag includes Penguins because the dangers of ECB mode are commonly explained with the picture of [Tux](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_(ECB)).

brck{EZP3n9u1nZ}