# bytecode for bottom part from objdump
# added a 0x90 to allow easy error injection (using core dumps for debugging)

pre_bytecode_test = """
eb 21
62 72
63 6b 7b
34 6e
5f
65 4c
46 5f
48
65 34 64
5f
46 75 4c
4c 5f
30 46 5f
4d 34 44
4e
45 53
53
7d 80
3a 00
75 c1
58
41 b8 3e 3a 29 0a
41 50
48 ff c7
48 89 e6
48 31 d2
b2 08
0f 05
48 31 c0
48 ff c0
90
cd 80
"""

# get bytes for bottom part
pre_bytes = []
for x in pre_bytecode_test.split():
  pre_bytes.append(int(x,16))

# elf binary
header_data = open('./output/binary_shrink','rb').read()

# xor
new_bytes = []
for i,v in enumerate(pre_bytes):
  newbyte = v ^ (header_data[i%84] ^ 0x42)
  new_bytes.append(newbyte)

print(len(new_bytes))
# write for nasm use
print("db " + "%s" % (','.join(['%s' % hex(x) for x in new_bytes])))