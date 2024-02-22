#!/bin/bash

echo -n $1 | base64 -d | openssl rsautl -decrypt -inkey private_key.pem
