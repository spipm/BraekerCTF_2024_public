BITS            64

                org         0x01337000
ehdr:           db          0x7F, "ELF", 2, 1, 1, 0         ; Elf64_Ehdr, e_ident (2 = ELF64)


                db          0x13                            ; useless bytecode
                db          0x37
                xor eax, eax
                ret

                ; final gadget - 3 bytes
                cdq                           ; clears rdx
                syscall

                dw      2                               ;   e_type
                dw      0x003e                          ;   e_machine (62 = i386_64)
                dd      1                               ;   e_version
                dq      start                           ;   e_entry
                dq      phdr - $$                       ;   e_phoff
                dq      0                               ;   e_shoff
                dd      0                               ;   e_flags
                dw      ehdrsize                        ;   e_ehsize
                dw      phdrsize                        ;   e_phentsize
                dw      3                               ;   e_phnum

                dw      0                               ; section parameters (none)
                dw      0
                dw      0

ehdrsize        equ     $ - ehdr

phdr:                                                   ; Elf64_Phdr
                dd      1                               ;   p_type
                dd      1                               ;   p_flags
                dq      0                               ;   p_offset
                dq      $$                              ;   p_vaddr

                ; 3rd gadget, add 16 to rdi (to get to right stack position)
                ; 2 byte padding + 6 bytes              ;   p_paddr
                db 0x00, 0x00
                add dil, 16
                jmp rcx

                dq      filesize                        ;   p_filesz
                dq      filesize                        ;   p_memsz
                dq      0                               ;   p_align

phdrsize        equ     $ - phdr

phdr_GNU_STACK:
                dd      0x6474e551                ; p_type (NX stack protection)
                dd      0x4                       ; p_flags        

                ret                               ; useless ret 

                ; 5 bytes - first gadget          
                sar rsi, 63                       ; zero rsi
                pop r11                           ; useless pop, also is useless "pop rbx" gadget
                ret

                dq      0
                dq      0
                dq      0
                dq      0
                dq      0x20

phdr_GNU_RELRO:
                dd      0x6474e552                ; p_type (RELRO)
                dd      1

                ; second gadget
                mov rdi, rsp
                ret

                ; start: writes user input to stack and rets
      start:                                      ; rax = 0 (read), rdi = 0 (stdin)
                mov rsi, rsp                      ; buffer to read into
                mov dx, 250                       ; number of bytes to read
                syscall
                ret

                dq 0x00
                dq 0x00
                dq 0x00
                db 0x13, 0x37
                dq 0x00

filesize      equ     $ - $$