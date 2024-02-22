#!/bin/bash

echo -n $1 | openssl rsautl -encrypt -pubin -inkey public_key.pem | base64 -w 0
