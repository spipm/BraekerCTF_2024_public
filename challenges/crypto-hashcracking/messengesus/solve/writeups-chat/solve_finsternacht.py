# solve by finsternacht - posted in writeups chat

import string

alphabet = (string.ascii_letters+string.digits + '{}_').encode()

with open("ciphertext", 'rb') as f:
    ct = f.read()

for off in range(34):
    print(f'{off:2d} {"".join(chr(x) for x in alphabet if x not in xor(0xa, ct)[off::34])}')