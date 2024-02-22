

# 0x43,0xd8,0x8b,0x98,0x47,0x67,0xe1,0x25,0x2,0x74,0xe2,0xe6,0x64,0xd3,0xea,0x0,0x52,0x41,0xf3,0x72,0x8f,0x23,0x71,0x42,0x2,0x8d,0x8,0x7c,0xb2,0xce,0xe,0x88

# ; (buffer_a xor 0x49) + (32-i):
# ; [42, 176, 224, 238, 42, 73, 194, 133, 99, 84, 193, 196, 65, 173, 181, 90, 43, 23, 200, 72, 210, 117, 66, 20, 83, 203, 71, 58, 255, 138, 73, 194]

flag = "brck{C0DE_1n_th3_B33p1nG_H43d3R}"

f = [ord(x) for x in flag]
a = [42, 176, 224, 238, 42, 73, 194, 133, 99, 84, 193, 196, 65, 173, 181, 90, 43, 23, 200, 72, 210, 117, 66, 20, 83, 203, 71, 58, 255, 138, 73, 194]

xored = []
for i,v in enumerate(a):
	xored.append(a[i] ^ f[i])


print()
print("db %s" % ','.join([hex(x) for x in xored]))
print(len(a))
print(len(f))
print([chr(x) for x in f])