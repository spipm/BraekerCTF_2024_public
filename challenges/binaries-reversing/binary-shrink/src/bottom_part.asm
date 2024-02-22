; jump over flag
jmp next

db "brck{4n_eLF_He4d_FuLL_0F_M4DNESS}"

next:

; we should be landing on a nullbyte
cmp byte [rdx], 0x00

; exit main loop
jne main_loop

; pops rax = 1 (write for syscall)
pop rax                                       ; 1 byte; 

; insert smiley face
mov r8, 0x0a293a3e
push r8

; edi = 1, STDOUT_FILENO
; print smiley
inc rdi                                       
mov rsi, rsp
xor rdx, rdx 
mov dl, 8
syscall

; exit
xor rax, rax
inc rax
int 0x80