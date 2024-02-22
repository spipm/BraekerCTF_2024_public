; Binary shrink challenge
;   spipm, BraekerCTF 2024
;
; Original teensy ELF at https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
;
;


BITS            64
                org         0x08048000                      

; Elf64_Ehdr, e_ident (2 = ELF64)

ehdr:           db          0x7F, "ELF", 2, 1, 1, 0         


; ELF magic padding = eight bytes for hidden bytescode
; First 0x00 to hide bytecode from objdump
; 5 byte call to next hidden bytecode section in header
; This part also breaks gdb, which expects normal nullbyte padding

                db          0x00                            
_start:         call         _start2                        
_start_from:    db          0x13, 0x37

                dw      2                               ;   e_type
                dw      0x003e                          ;   e_machine (62 = i386_64)
                dd      1                               ;   e_version
                dq      _start                          ;   e_entry
                dq      phdr - $$                       ;   e_phoff
                dq      0                               ;   e_shoff
                dd      0                               ;   e_flags
                dw      ehdrsize                        ;   e_ehsize
                dw      phdrsize                        ;   e_phentsize
                dw      1                               ;   e_phnum

;   Another six bytes for hiding bytescode (e_shentsize, e_shnum, e_shstrndx)

_start2:
                pop     rdx                             ;   1 byte;       Save address of _start_from
                mov     rax, rdx                        ;   3 byte copy;  Copy address of _start_from to rax
                jmp     start                           ;   2 byte;       Jump to start

ehdrsize        equ     $ - ehdr

phdr:                                                   ; Elf64_Phdr
                dd      1                               ;   p_type
                dd      3                               ;   p_flags; 
                dq      0                               ;   p_offset
                dq      $$                              ;   p_vaddr
                dq      $$                              ;   p_paddr

; Setting p_filesz and p_memsz to 1 seems to break all the analyzers
; The kernel doesn't seem to mind

                dq      1                               ;   p_filesz
                dq      1                               ;   p_memsz
                
                dq      0x1000                          ;   p_align

phdrsize        equ     $ - phdr

start:

    ; rdx and rax point to _start_from

    add rdx, dat - _start_from                ; rdx = dat
    sub rax, _start_from-ehdr                 ; rax = ehdr (0x08048000)
    mov rsi, rax                              ; save ehdr in rsi

    xor ecx, ecx                              ; clear counter register

    main_loop:                                ; main xor loop
      mov cl, 86                              ; rcx loop counter
      mov rax, rsi                            ; restore ehdr in rax

      sub_loop:                               ; sub loop
        mov sil, byte [rax]                   ; get byte from ehdr
        xor byte [rdx], sil                   ; xor with dat byte
        xor qword [rdx], 0x42                 ; xor with 0x42
        inc rdx                               ; inc header index
        inc rax                               ; inc dat index
        loop sub_loop


    ; dat = bottom_part.asm xored with ELF header and 0x42
    ; generated with python script

    dat:
    db 0xd6,0x26,0x6c,0x76,0x23,0x28,0x38,0x76,0x2c,0xf5,0xb,0xe,0x4,0x1d,0x19,0x10,0x74,0x26,0x23,0x4,0x36,0xe,0xe,0x1d,0x7b,0x84,0x19,0x7,0x76,0x6,0xc,0x7,0x51,0x11,0x3f,0xc2,0x78,0x42,0x37,0x83,0x1a,0x3,0xfa,0x7c,0x78,0x6b,0x48,0x3,0x12,0xa,0xbd,0x85,0x4a,0xcb,0x9c,0xa,0x72,0x90,0xaa,0x2,0xc4,0x97,0xe1,0x4b,0x83,0xa,0xbd,0x82,0xd1,0x8f,0xc2
