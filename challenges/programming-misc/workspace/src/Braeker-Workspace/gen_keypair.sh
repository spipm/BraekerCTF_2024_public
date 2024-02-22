#!/bin/bash

openssl genpkey -algorithm RSA -out private_key.pem
openssl rsa -in private_key.pem -pubout -out public_key.pem

