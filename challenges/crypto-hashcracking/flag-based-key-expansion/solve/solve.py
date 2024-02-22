from hashlib import md5

partial_hashes = [
	"e7__35ef8458e44________2_e6068ce",
	"_4_9_a1f_9_____98eb2___94____397",
	"_41___8__46_97c6_2____7__9__251_",
	"_b6ded3_5b___3_2_5_____f504__dc_"
]

init_key = "aabacadaeafa0a1a2a3a4a5a6a7a8a9bbcbdbebfb0b1b2b3b4b5b6b7b8b9ccdcecfc0c1c2c3c4c5c6c7c8c9ddedfd0d1d2d3d4d5d6d7d8d9eefe0e1e2e3e4e5e6e7e8e9ff0f1f2f3f4f5f6f7f8f90010203040506070809112131415161718192232425262728293343536373839445464748495565758596676869778798899"

words = open('rockyou.txt','rb').read().split(b'\n')

def compare_parthash(full_hash,partial_hash):
	for i,v in enumerate(partial_hash):
		if v == '_':
			continue
		if full_hash[i] != v:
			return False
	return True

found_words = []
for partial_hash in partial_hashes:
	for word in words:

		if word == b'':
			continue

		m = md5()
		m.update(init_key.encode())

		for w in found_words:
			m.update(w)

		m.update(word)

		if compare_parthash(m.hexdigest(),partial_hash):
			found_words.append(word)
			print("found word for %s: %s" % (partial_hash, word.decode()))
			break

print("brck{%s}" % "_".join([x.decode() for x in found_words]))
