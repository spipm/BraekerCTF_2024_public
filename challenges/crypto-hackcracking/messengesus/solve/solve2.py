from pwn import *

context.log_level = 'error'


def get_encrypted_bytes(fin, flag_length):
    return fin.read(flag_length)


def is_clear_dict(optionDict):
    for i in optionDict:
        if len(optionDict[i]) > 1:
            return False
    return True


def answer(optionDict):
    ans = []
    for i in optionDict:
        if len(optionDict[i]) == 0:
            continue
        ans.append(chr(optionDict[i][0] ^ 0x0a))
    return ''.join(ans)


for flag_length in range(7,40):
    fin = open('ciphertext','rb')

    optionDict = {}
    for i in range(flag_length):
        optionDict[i] = [x for x in range(1,256)]

    while True:
        encrypted_data = get_encrypted_bytes(fin, flag_length)

        if encrypted_data == b'':
            break

        for i,x in enumerate(encrypted_data):
            if x in optionDict[i]:
                optionDict[i].remove(x)

        if is_clear_dict(optionDict):
            ans = answer(optionDict)
            if 'brck' in ans:
                print(ans)
                fin.close()
                exit(0)
            break

    fin.close()