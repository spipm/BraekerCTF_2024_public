# Solve by Nolliv22 - posted in writeups chat
#  A clever solution that just uses the timestamp from the provided file

import os
import random
from string import printable

fpath = "./ciphertext"

random.seed(int(os.path.getmtime(fpath)))
rand_printable = [x for x in printable]
random.shuffle(rand_printable)

c = open(fpath).read()

C = [c[i:i+64] for i in range(0, len(c), 64)]
D = [C[i:i+100] for i in range(0, len(C), 100)]

for d in D:
    for i, e in enumerate(d):
        if e[:32] == e[32:]:
            print(rand_printable[i], end="")