## Background

 Author: spipm
 Category: Webservices
 Difficulty: Hard

## Technical

Challenge built around the memcached command deserialization [vulnerability](https://btlfry.gitlab.io/notes/posts/memcached-command-injections-at-pylibmc/).

## Story

One of the leaderbots tells you about the dashboard they have built. "Why was it built?" you ask.

"What do you mean, why was it built? It's a dashboard. You've got to build dashboards. It will show us the numbers."

"What will you do with the numbers?"

"Decide if it is a good dashboard or not, obviously. You're not quick to catch on are you? Plus, everyone knows adding more dashboards increases security by the percentage shown on the dashboard."

Convince the leaderbot that too much shadow IT might be decremental to security.

![Leaderbot](./leaderbot.jpeg "Leaderbot") 

## Exploit

1. Login via null pwd
2. Crack session secret, manually or with [Flask Unsign](https://github.com/Paradoxis/Flask-Unsign). Find that secret is 'Dashboard42!'.
3. Perform memcache rce; use payload from article, sign cookie and make a request to /success.

## Flag

brck{Cach3_Y0u_On_Th3_Fl1p_S1d3}
