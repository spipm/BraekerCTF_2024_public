#!/bin/bash

difficulty=$1

while :
do
	{
		./gen_keypair.sh
		pub_raw=$(cat public_key.pem | base64 -d -i)
		echo "Generated key bytes:"
		echo $pub_raw | xxd
		spaces=$(echo $pub_raw | grep -a -o -P '\x20' | tr -d '\n' | wc -c)
	} 2>/dev/null

	echo "Correct bytes:"
	echo $spaces
	echo "Difficulty:"
	echo $difficulty

	if [[ $spaces -ge $difficulty ]]; then
		echo "Proof of work completed!"
	break
	else
		rm private_key.pem public_key.pem
	fi
done


