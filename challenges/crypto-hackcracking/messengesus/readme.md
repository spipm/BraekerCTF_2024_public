## Background

 Author: Shoaloak and spipm
 Category: Crypto / Hackcracking
 Difficulty: Easy

The story of this challenge references the [RNGesus](https://knowyourmeme.com/memes/rngesus) meme.

## Technical

This is a variation of the clever [babypad](https://ctftime.org/writeup/17069) challenge by plonk from the TastelessCTF 2019. The idea is that plaintext gets xored with all bytes except one, so you can reverse the operation by xoring with the mising byte. The original challenge used null bytes, and we ported it to use newlines.

## Story

You encounter a bot meditating in the park. He opens his cameras and begins to speak.

"Hear the word of RNGesus. Complexity is the enemy of security. Let your encryption be as simple as possible, as to secure it, thusly". He hands you a flyer with a snippet of code. "Secure every message you have with it. Only those who see can enter."

What do you think? Is it simple enough to be secure?

![Messengesus](./messengesus.jpg "Messengesus") 

*Second part of the challenge*

The bot quickly turns away to scribble new lines in the holy code. He turns back, "Uh, well.. he..hear the word of RNGesus again! Praised be the secured code. No need to repeat what you've seen here."

Can you praise this secured code?

![Messengesus2](./messengesus2.jpeg "Messengesus2") 

## Exploit

*First part*

See solve.py. The idea is that on average, every ~128 request will have getline() return nothing but a newline, so you can just keep xoring the printed value with 0x0a and check if it is the flag.

*Second part*

See solve2.py. For the second part you know that the bytes never get xored with 0x0a, so you just keep getting bytes until there is 1 missing, and you xor that with 0x0a.

## Flag

brck{SiMPl1c1Ty_1s_K3Y_But_N0t_th3_4nSW3r}
brck{St1ll_n0th1ng_bUt_4_b4by_p4d}