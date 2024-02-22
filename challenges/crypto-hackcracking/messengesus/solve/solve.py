from pwn import *

context.log_level = 'error'

def get_encrypted_bytes():

    # io = process("./messengesus")
    io = remote("0.cloud.chals.io", 26265)
    ret = io.recvall()
    io.close()

    return ret


while True:

    encrypted_data = get_encrypted_bytes()

    test = []
    for i,x in enumerate(encrypted_data):
        test.append(x^0x0a)
    test = b''.join([chr(x).encode() for x in test])

    if b'brck{' in test:
        print(test)
        break
