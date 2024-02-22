import binascii

import codecs

def ebcdic_encode(text):
    return codecs.encode(text, 'cp500')

def ebcdic_decode(data):
    return codecs.decode(data, 'cp500')


E = [0]*6
E[0]="9DA8ADAE9FB9BB0137108E8D11363D1DB0"
E[1]="8BBE98BD36021C32888E00350126231C9E2126301C2500000A251188B11D2BB31D"
E[2]="25BBAC3301243316302334002435163524330024321636233200153513351733072437B0B5B0813F"
E[3]="8B8EAD24021788240C3024260D882537348E12300704260A8E9DAF8E8BAE22A80989988D222100BD17981D1D"
E[4]="8B8EBEBD2631003F16122BBDA91C9B27370112371CABA8A888019F378D3421A80289AE8BBE98B89B25351D"
E[5]="2F0393B89D841303000A10313C888B8EA8A89D9FA8BBBBBEACB0370D23109361717C850E537783774266A6665B46B05256C1C7"


init_key = b'WELC0ME'
for x in E:
	encoded = x
	encoded = binascii.unhexlify(encoded)

	key = init_key * (len(encoded) // len(init_key))
	key += b' ' * (len(encoded) % len(init_key))
	encoded_key = ebcdic_encode(key.decode())

	C=b''
	for i,v in enumerate(encoded_key):
		C += bytes([encoded[i] ^ encoded_key[i]])

	# print("Len encoded", len(encoded))
	# print("Encoded encoded", binascii.hexlify(encoded))
	# print("Len key", len(encoded_key))
	# print("Encoded key", binascii.hexlify(encoded_key))
	# print("Len C", len(C))
	# print("Encoded C", C)

	C = ebcdic_decode(C)
	print(C)

