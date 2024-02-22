import random
from time import time
from string import printable

seed = int(time())-10000

# read blocks
data = open('ciphertext','r').read()

block_size = 64
num_blocks = (len(data) + block_size - 1) // block_size
data = [data[i * block_size : (i + 1) * block_size] for i in range(num_blocks)]


# find matching blocks
hit_entries = []
count = 0

for line in data:

	a,b = line[32:], line[:32]
	if a == b:
		# print(a,b)
		hit_entries.append(count)

	count += 1

	if count == 100:
		count = 0


# find seed from known plaintext
should_mapping = {
	'b':hit_entries[0],
	'r':hit_entries[1],
	'c':hit_entries[2],
	'k':hit_entries[3],
	'{':hit_entries[4]
}

while seed < int(time()):
	seed += 1
	random.seed(seed)
	a = [x for x in printable]
	random.shuffle(a)

	found = True
	for y in should_mapping:
		if a[should_mapping[y]] != y:
			found = False
			break

	if found:
		# print("Seed:", seed)
		break


# recreate flag
flag = ''
for x in hit_entries:
	flag += a[x]
	if a[x] == '}':
		break

print(flag)