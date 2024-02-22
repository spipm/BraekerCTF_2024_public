#!/bin/bash

./gen_keypair.sh
./decrypt_data.sh $(./encrypt_data.sh $1)
