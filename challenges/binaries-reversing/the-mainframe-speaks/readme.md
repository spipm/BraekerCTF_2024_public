## Background

 Author: spipm
 Category: Binaries / Reversing
 Difficulty: Medium to Hard

## Technical

This is IBM REXX code that was tested on an IBM mainframe. It is obfuscated and it needs to be manually reversed using the IBM documentation.

## Story

"Oh ancient robeth! All throughout the land they talk of you becoming obsolete. How is you? Are you in need of assistance?"

"Obsolete? These bots must be abending. I'm working just fine you see. Young bots are the ones having all sorts of troubles, not us. We're maintained and properly managed. However, I do have this old code lying around, and I lost the documentation. Can you find it for me?"

<img src="./old_robot.jpg" width="500">

## Exploit

Reversing can be tricky, as the docs aren't always super clear about things, and things like X2C can be confusing because it uses EBCDIC instead of ASCII character conversion. 

The code heavily relies on using confusing [stem](https://www.ibm.com/docs/en/cics-ts/6.1?topic=stems-using) variables. The first part just uses stem variables and some IBM function to obfuscate 'WELC0ME', which is then used as the xor key to deobfuscate the rest. See solve.py on how to decode it.

The rest looks like the following. It uses a bunch of IBM function to obfuscate 'T0' and 'M4INFR4M3REXX'.

```
  #_=_?_=X2C('E3')0
  _#.=FORM()CENTER(SOURCELINE(1),3)
  C="01060507000007000703010A050D0702050A"
  _.=X2C(BITXOR(C2X(SUBSTR(_#._,1,9)),X2C(C)))
  _._=OVERLAY('R'SUBSTR(_#.1.2,12,2),_#.#,10)
  IF #_&OVERLAY(_.#,_._)=_? THEN
    say You got the flag!
ELSE say oof no flag
```

## Flag

brck{WELC0ME_T0_M4INFR4M3REXX}