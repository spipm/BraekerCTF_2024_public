## Background

 Author: spipm
 Categories: Crypto / Hackcracking
 Difficulty: Easy

## Technical

This is a book cipher where the book pages are Twitter post IDs.

## Story

"One of our bots loves to read. We don't get it. Why would you stare at paper when all proper knowledge is shared by bots on the internet? Lately she even started talking in ciphers. I think the poor bot is possessed!"

Can you figure out what she was trying to say?

brck{1746200913432170593.11_1740398198542172490.3_789837700517945346.13}

![Book cipher](./book-cipher.jpg "Book cipher") 

## Exploit

https://en.wikipedia.org/wiki/Book_cipher

https://twitter.com/JABDE6/status/1746200913432170593
1746200913432170593:11
= Code

https://twitter.com/JackRhysider/status/1740398198542172490
1740398198542172490:3
= is

https://twitter.com/schneierblog/status/789837700517945346
789837700517945346:13
= everywhere.

## Flag

Flag: brck{Code_is_everywhere.} or brck{Code_is_everywhere}
Flag can also be "brck{Code_is_reported}" if you count 's as the word "is". Both were correct.