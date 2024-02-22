; Binary shrink challenge
;   spipm, BraekerCTF 2024
;
; Original teensy ELF at https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
;
;

BITS 32

              org     0x08048000

ehdr:
              db      0x7F, "ELF"             ; e_ident
              db      1, 1, 1

                ; 9 bytes space ! take 2 bytes from e_ident, 7 bytes header

                _read_user_bytes:
                    mov al, 3                   ; read; has to start like this, else get exec format error
                    pop ecx                     ; set buffer to address of ehdr
                    xor cl, cl
                    mov dl, 16+2                ; read 16 + 2 bytes

                    int 0x80

                                                ; here we are 16 bytes in

              dw      2                       ; e_type
              dw      3                       ; e_machine
              dd      1                       ; e_version
              dd      _call_readbytes                  ; e_entry
              dd      phdr - $$               ; e_phoff
              
              
              db 0x00, 0x00, 0x00                   ; padding required for call (first 3 bytes of e_shoff)
              ;dd      0x0000                       ; e_shoff
              ;dd      0x0000                       ; e_flags

              ; call overwrites e_shoff en e_flags
              _call_readbytes:
              call _read_user_bytes

              dw      ehdrsize                ; e_ehsize
              dw      phdrsize                ; e_phentsize
phdr:         dd      1                       ; e_phnum       ; p_type
                                              ; e_shentsize
              dd      0                       ; e_shnum       ; p_offset
                                              ; e_shstrndx
ehdrsize      equ     $ - ehdr
              dd      $$                                      ; p_vaddr
              dd      $$                                      ; p_paddr
              dd      filesize                                ; p_filesz
              dd      filesize                                ; p_memsz
              dd      7                                       ; p_flags
              dd      0x1000                                  ; p_align
phdrsize      equ     $ - phdr


filesize      equ     $ - $$