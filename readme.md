# BraekerCTF 2024

This is the source code from the [BraekerCTF](https://ctftime.org/event/2181) 2024 by spipm (Sipke). It is a jeopardy-style hacking competition, and it ran from 23 February 2024 to 24 February 2024. Over 700 teams participated (see [stats](./stats.md)), and 508 made it to the [scoreboard](https://ctftime.org/event/2181).

### Winners

Congrats to the teams [thehackerscrew](http://www.thehackerscrew.team/), [KITCTF](https://kitctf.de/) and [TeamMidwayAtoll](https://ctftime.org/team/282573) for winning the first, second and third place! They are awarded €769, €539 and €151!

## Background

### Background - Binaries and reversing

This CTF started while reading [Practical Binary Analysis](https://practicalbinaryanalysis.com/) by Daniel Andriesse. I wanted to create an [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) that's as small as possible, to test techniques for evading analysis. Luckily there was the awesome article ["Creating Really Teensy ELF Executables for Linux"](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html) by Brian Raiter. Porting Brian's binary to 64 bit already broke some disassembly tools. With a few more edits, objdump and GDB said "file format not recognized", ltrace, Radare2 and Angr lost track, Ghidra and Binja stopped functioning, ReDasm segfaulted and even IDA forfeited. After a few weeks the [binary_shrink](./challenges/binaries-reversing/binary-shrink/) challenge was born. [Embryobot](./challenges/binaries-reversing/embryobot/) and [fetusbot](./challenges/binaries-reversing/fetusbot/) use the same kind of tricks as binary_shrink, and I can now tweak them to disallow debugging with gdb, or to enable NX for the ROP challenge.

After playing with ELFs I continued with the [PE](https://en.wikipedia.org/wiki/Portable_Executable) format. As a base I used Alexander Sotirov's [tinyPE](http://www.phreedom.org/research/tinype/) and found that you can also easily jump into headers to confuse analyzers. At that time I took three malware development courses from [Sector7](https://institute.sektor7.net/red-team-operator-malware-development-essentials) which I can highly recommend. Mixing tinyPE with the courses created a small but nasty binary that is hard to analyze. It does cool things like resolve functions from kernel32 via PEB while checking IsBeingDebugged. It also creates a thread and it uses the [Beep](https://www.bleepingcomputer.com/news/security/new-stealthy-beep-malware-focuses-heavily-on-evading-detection/) function for timing across threads. This is the [Computer says Beep](./challenges/binaries-reversing/computer-says-beep/) challenge.

After PEs it was time for the [Macho](https://en.wikipedia.org/wiki/Mach-O) file format. A neat base was [this](https://stackoverflow.com/questions/32453849/minimal-mach-o-64-binary) code from Kamil.S on StackOverflow. Playing with code that exists only in the header commands (it's a Macho thing) caused all sorts of weirdness. Creating bogus LC_THREADs confuses Binja and IDA about the code's entry point. Other tools also have trouble finding the binary's entry point, and MacOViewer segfaults. The end result [Injecting commands](./challenges/binaries-reversing/injecting-commands/) is a work of madness.

Recently I was granted access to a testing environment of an IBM mainframe, so I got to play around with [z/OS](https://nl.wikipedia.org/wiki/Z/OS). It has this Unix subsystem called [USS](https://en.wikipedia.org/wiki/UNIX_System_Services) that can run IBM's [REXX](https://www.ibm.com/docs/en/zos/2.1.0?topic=guide-learning-rexx-language) scripting language. This access was used to build and run the challenge [The mainframe speaks](./challenges/binaries-reversing/the-mainframe-speaks), which is a pain to reverse, because of IBM's [EBCDIC](https://en.wikipedia.org/wiki/EBCDIC) encoding. Mainframes are far from dead, and knowledge about them is scarce. They are neat research targets, but the learning curve is steep.

### Background - Crypto and hashcracking

With the help of [Axel Koolhaas](https://axelkoolhaas.com/) (Shoaloak) we created [messengesus](./challenges/crypto-hashcracking/messengesus), a variation on the clever [babypad](https://ctftime.org/writeup/17069) challenge by plonk from the TastelessCTF 2019. 

The challenge [Flag-based key expansion](./challenges/crypto-hashcracking/flag-based-key-expansion/) was inspired by multiple things. First of all, some colleague dumped half his AD NTLM hash in Confluence, claiming that "you can't crack half a hash", and secondly because I made this [Depix](https://github.com/spipm/Depix) tool a couple of years ago. The tool was immensely overhyped on socials, but it's more neat than useful, just like deconvolution for the eye doctor challenge (see below). 

The challenge [Thus spoke machine](./challenges/crypto-hashcracking/thus-spoke-machine) is just a [Book cipher](https://en.wikipedia.org/wiki/Book_cipher) variation, which is a cipher I remembered from skimming [Codebreaking: A Practical Guide](https://codebreaking-guide.com/). [Block construction](./challenges/crypto-hashcracking/block-construction) is a trivial ECB decryption attack based on [Set 2](https://cryptopals.com/sets/2) from the Cryptopals challenges.

### Background - Programming and misc

While in the library, waiting for someone, I browsed [C++ en Numerieke Wiskunde](https://www.bol.com/nl/nl/p/c-en-numerieke-wiskunde/9200000063055974/) (C++ and numerical maths) and found a part about how you should sort an array of floats before summing it, so I made [e](./challenges/programming-misc/e/), which stands for Epsilon, the weird thing that makes floats weird.

[Microservices](./challenges/programming-misc/microservices) got started because I wanted to mimic the [Mitnick attack](http://wiki.cas.mcmaster.ca/index.php/The_Mitnick_attack), as a tribute to his passing, but it was hard to make this work over the internet. The initial challenge code was changed into a programming challenge that required contestants to catch packets that had sequence numbers that did not match their normal TCP stream.

Some challenges were taken from nominations for [best web hacking techniques](https://portswigger.net/research/top-10-web-hacking-techniques-of-2023-nominations-open) of 2023 from Portswigger's James Kettle. Adnan Khan's [article](https://adnanthekhan.com/2023/12/20/one-supply-chain-attack-to-rule-them-all/) on supply chain attacks via Github Actions was the basis for the [Workspace](./challenges/programming-misc/workspace/) challenge.

Last week I extracted blurred PII from a manual, which I thought was some neat Hollywood CSI stuff, so I created the [Eye doctor](./challenges/programming-misc/eye-doctor/) challenge around it. The idea is that blurring techniques, like a linear motion blur, are simple image convolution operations that sometimes can be reversed with a script like
[this](https://github.com/opencv/opencv/blob/3.2.0/samples/python/deconvolution.py).

### Background - Webservices

After reading about [phone number injections](https://book.hacktricks.xyz/pentesting-web/phone-number-injections) and [unicode normalization](https://book.hacktricks.xyz/pentesting-web/unicode-injection/unicode-normalization) on Carlos Polop's [Hacktricks](https://book.hacktricks.xyz/welcome/readme), I made the SQL-Injection challenge [a beacon dialing home](./challenges/webservices/a-beacon-dialing-home) to combine the two.

Inspiration for the [Leaderbot dashboard](./challenges/webservices/leaderbot-dashboard/) came from d4d's [article](https://btlfry.gitlab.io/notes/posts/memcached-command-injections-at-pylibmc/) about memcache injection. The challenge variant used signed cookies for which the secret had to be brute forced.

The [Empty execution](./challenges/webservices/empty-execution/) challenge is derived from a code execution vulnerability found in the wild, for which I also made a little spot-the-bug challenge on [Twitter](https://twitter.com/spibblez/status/1203295533584060418).

For a client I needed to check the security of a Java application that uses a JAXB unmarshaller. The [Marshallsec](https://github.com/mbechler/marshalsec) paper only says "JAXB implementations generally require that all types used are registered, " but it wasn't clear when an application is vulnerable or not. I found that if a class unmarshalls an Object from user input, the deserialization process allows the user to use setters from all registered classes, even when they don't have the XmlAccessorType set. The challenge [Node calculator](./challenges/webservices/node-calculator) was created as an example to show what a vulnerable application could look like.

[Stuffy](./challenges/webservices/stuffy/) is just a Request Smuggling challenge, because it's all the rage these days.

## Credits

Special thanks to [Axel Koolhaas](https://axelkoolhaas.com/) (Shoaloak) and [Gerard Arall](https://twitter.com/gerardarall) for their enthusiasm about the project, which was very motivating. 

[Ctfd.io](https://www.ctfd.io/) was used as a CTF platform. Both their service and their customer service are amazing, so I can highly recommend it.

AI images were generated with [DreamStudio](https://beta.dreamstudio.ai/), and ChatGPT was used for a bunch of things. For the mascot banner I used the Infinite image tool from [Runwayml](https://app.runwayml.com).

I'd also like to thank the creators of the [XMAS CTF 2022](https://gitlab.com/hecarii-tuica-si-paunii/x-mas-ctf-2022-challenges/-/tree/main/) for making their CTF open source, which made getting Docker to work a lot easier.

## Write-ups

- See [CTFTime](https://ctftime.org/event/2181) and [CTFWriteups](https://ctfwriteups.org/ctfs/65da3062ae8e3021f3d0612a) for most write-ups
- Some solve directories in this repo also include an writeups-chat directory with snippets thats were posted in the writeups Discord channel
- Multiple challenges by [D13David](https://github.com/D13David/ctf-writeups/blob/main/braekerctf24/README.md). Excellent write-up on The Mainframe Speaks.
- Multiple challenges by [M1sery](https://www.yuque.com/misery333/sz1apr/yzg2khgiaebotc5l?language=en-us). Includes Node Calculator and Stuffy.
- Binaryshrink by [Mahmoud Elfawair](https://mahmoudelfawair.medium.com/breakerctf-24-binaryshrink-4cc9feae0259)
- Empty execution by [Sumeet darekar](https://noobstain.medium.com/braekerctf-2024-243144d2a29e)
- Fetusbot by [rpm0618](https://gist.github.com/rpm0618/d873e9685f723b1b8f1bbdd490739377)
- Block construction by [wepfen](https://wepfen.github.io/posts/block_construction/)
- Eye doctor by [sealldev](https://seall.dev/posts/eyedoctorbraekerctf2024)
- Messengesus by [CrispLake](https://github.com/CrispLake/writeups/tree/master/braekerctf24/messengesus)
- Stuffy by [tahdjao](https://github.com/tahdjao/writeup/blob/main/braekerctf/stuffy_en.md)
- Injecting Commands by [Intrigus](https://intrigus.org/research/2024/03/03/braeker-ctf-2024-injecting-commands-writeup/)
