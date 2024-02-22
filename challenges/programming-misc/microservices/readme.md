## Background

 Author: spipm
 Category: Programming / Misc
 Difficulty: Medium to Hard

## Technical

In this challenge the flag is divided into bits, and a port is created for every bit. It sends a value related to the bit in a seperate TCP packet that is not aligned with the rest of the handshake. One needs to recover the flag, use binary search, and it requires some network programming and memory sharing between applications.

The challenge is not docker friendly. To run, backup your iptables, and do the following so your kernel doesn't reply to the SYNs:
```
sudo iptables -A INPUT -p tcp --dport 1000:1550 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --tcp-flags RST RST --sport 1000:1550 -j DROP
```

## Story

"Oops I dropped the flag! Better not let the other bots know. I'll send it to you OOB so they won't see the traffic." 

![Dropped](./dropped.jpg "Dropped") 

## Exploit

See solve files. I made an ugly solution that uses a text file for intra-process communication, but shm would be faster.

## Flag

brck{M1cr0services_c4Use_m4cR0_pR0bl3ms}