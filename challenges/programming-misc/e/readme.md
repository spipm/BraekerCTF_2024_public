## Background

    Author: spipm
    Category: Programming / Misc
    Difficulty: Easy

## Technical

A challenge about how floats and the addition of floats work in cpp. There are three rounds, and in the third round a user adds a float to an array, then many random numbers are added, then the user gets to add a final number to the array. The total of the array must equal zero.

## Story

"Grrrrr". This robot just growls. The other bots tell you that it is angry because it can't count very high. Can you teach it how?

<img src="./Epsilon.jpg" width="500">

## Exploit

The first round is a simple overflow (393218), the second round is about float rounding (0.09999990463256836), third round is about adding arrays (300000000000,-300000000000). The large numbers in the third round fill up the float such that adding small numbers don't register. At the end you can then subtract the large number, so addition will end up being zero.

## Flag

brck{Th3_3pS1l0n_w0rkS_In_M15t3riOuS_W4yS}