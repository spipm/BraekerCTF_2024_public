# Workspace

PoW-keys for worker bots, or plebbots, are stored in this repository. Leaderbots can securely grep keys via the issue workflow. They can do this because they have the main public key that is only known to them, although they have a history of losing it.

## Commands for plebbots that might be handy

### Generate keypair

`openssl genpkey -algorithm RSA -out private_key.pem`

`openssl rsa -in private_key.pem -pubout -out public_key.pem`

Can also be done with `./gen_keypair.sh`

### Encrypt

`echo -n "Value to encrypt" | openssl rsautl -encrypt -pubin -inkey public_key.pem | base64 -w 0`

Can also be done with `./encrypt_data.sh value`

### Decrypt

`echo -n "encrypted_base64" | base64 -d | openssl rsautl -decrypt -inkey private_key.pem`

Can also be done with `./decrypt_data.sh base64_value`

### Test encryption / decryption

`./test.sh value`

### Generate key with PoW

`./PoW.sh 10`

## Forking this repository

To test this repo in a fork, create a PRIV_KEY secret for the Github Action (Settings->Secrets and variables->Actions). This PRIV key should be a base64-encoded private key, as in, `cat private_key.pem | base64 -w 0`.
