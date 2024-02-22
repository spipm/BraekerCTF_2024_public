; orig https://stackoverflow.com/questions/32453849/minimal-mach-o-64-binary
BITS    64
%define __origin 0x1000
org __origin

; For changing the flag
%define flag 'brck{Y0U_M4cho_C0mm4ndr}'
%substr flag_1 flag 0,8
%substr flag_2 flag 9,8
%substr flag_3 flag 17,8

; For changing the xor values
%define xor_three_value 0x4839ff0f05e927fc
%define xor_two_value 0x0f054831c0ff0f05
%define xor_one_value 0x88d00f0550580f05

; Constants
%define MH_MAGIC_64                     0xfeedfacf
%define MH_MAGIC_CIGAM                  0xbebafeca
%define CPU_ARCH_ABI64                  0x01000000
%define LC_REQ_DYLD                     0x80000000
%define CPU_TYPE_I386                   0x00000007
%define CPU_TYPE_X86_64                 CPU_ARCH_ABI64 | CPU_TYPE_I386
%define CPU_SUBTYPE_LIB64               0x80000000
%define CPU_SUBTYPE_I386_ALL            0x00000003
%define MH_EXECUTE                      0x2
%define MH_NOUNDEFS                     0x1
%define LC_SEGMENT_32                   0x1
%define LC_SEGMENT_64                   0x19
%define LC_LOAD_DYLIB                   0x0c
%define LC_UNIXTHREAD                   0x5 
%define LC_THREAD                       0x4
%define VM_PROT_READ                    0x1
%define VM_PROT_WRITE                   0x2
%define VM_PROT_EXECUTE                 0x4
%define x86_THREAD_STATE64              0x4
%define x86_EXCEPTION_STATE64_COUNT     42
%define SYSCALL_CLASS_SHIFT             24
%define SYSCALL_CLASS_MASK              (0xFF << SYSCALL_CLASS_SHIFT)
%define SYSCALL_NUMBER_MASK             (~SYSCALL_CLASS_MASK)  
%define SYSCALL_CLASS_UNIX              2
%define SYSCALL_CONSTRUCT_UNIX(syscall_number) \
            ((SYSCALL_CLASS_UNIX << SYSCALL_CLASS_SHIFT) | \
             (SYSCALL_NUMBER_MASK & (syscall_number)))
%define SYS_exit                        1
%define SYS_write                       4
%define SYS_ptrace                       26

; Mach-O header
DD        MH_MAGIC_64                                        ; magic
DD        CPU_TYPE_X86_64                                    ; cputype
DD        CPU_SUBTYPE_LIB64 | CPU_SUBTYPE_I386_ALL        ; cpusubtype
DD        MH_EXECUTE                                        ; filetype
DD        32                                                ; ncmds
DD        __COMMANDSend  - __COMMANDSstart                ; sizeofcmds
DD        MH_NOUNDEFS                                        ; flags
DD        0x0                                                ; reserved

; Start of loader commands
__COMMANDSstart:


; Bogus UUID to store xor value and some emojis
___cmd___PAGEUUIDstart:
    DD 0x0000001B                                       ; LC_UUID
    dd ___cmd___PAGEUUIDend - ___cmd___PAGEUUIDstart    ; command size

    xor_three:
        dq xor_three_value
    fail_str:
        db '😕', 0x0a, 0x00, '🤸', 0x0a, 0x00, '🧘', 0x0a, 0x00, '🏳️‍🌈', 0x0a, 0x00
___cmd___PAGEUUIDend:


; Fake PAGEZERO segment, is actual TEXT segment
___cmd___TEXTstart:
    dd LC_SEGMENT_64
    dd ___cmd___TEXTend - ___cmd___TEXTstart
    db '__PAGEZERO',0x0,0,0,0,0,0                               ; segment name (pad to 16 bytes)
    DQ        __origin                                          ; vmaddr
    DQ        ___codeend - __origin                             ; vmsize
    DQ        0                                                 ; fileoff
    DQ        ___codeend - __origin                             ; filesize
    DD        VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE    ; maxprot
    DD        VM_PROT_READ | VM_PROT_EXECUTE                    ; initprot
    DD        0x0                                               ; nsects
    DD        0x0                                               ; flags
___cmd___TEXTend:


; Bogus command
___cmd_bogus_1_start:
  dd 4
  dd ___cmd_bogus_1_end - ___cmd_bogus_1_start

    dq 0xed753b83f092a9f7
    dq 0x3b802eb9993bffd5
___cmd_bogus_1_end:


; Bogus command
___cmd_bogus_4_start:
  dd 18
  dd ___cmd_bogus_4_end - ___cmd_bogus_4_start

    dq 0x40E951FFF050f774
    dq 0x22DD112CBB73BB44
    call do_ptrace
    dq 0x99fe0f05050f38C4
    dq 0x050f0f05c3c34241
    dq 0x558722DCCC7437F5
___cmd_bogus_4_end:


; Bogus thread command, confuses binja
___cmd__UNIX_THREADstart2:
    DD        LC_THREAD                                    ; cmd
    DD        ___cmd__UNIX_THREADend2 - ___cmd__UNIX_THREADstart2             ; cmdsize
    DD        x86_THREAD_STATE64                                ; flavor
    DD        x86_EXCEPTION_STATE64_COUNT                        ; count
    DQ        0x2000002, 0x0, 0x00, 0x00                                ; rax, rbx , rcx , rdx
    DQ        0x02, 0x7331, 0x00, 0x00                        ; rdi = STDOUT, rsi = address of hello_str,  rbp, rsp
    DQ        0x00, 0x00                                        ; r8 and r9
    DQ        0x00, 0x00, 0x00, 0x00, 0x00, 0x00                ; r10, r11, r12, r13, r14, r15
    DQ        0x1337, 0x00, 0x00, 0x00, 0x00            ; rip, rflags, cs, fs, gs
___cmd__UNIX_THREADend2:


; ACTUAL CODE Initial thread information
___cmd__UNIX_THREADstart:
    DD        LC_UNIXTHREAD                                    ; cmd
    DD        ___cmd__UNIX_THREADend - ___cmd__UNIX_THREADstart             ; cmdsize
    DD        x86_THREAD_STATE64                                ; flavor
    DD        x86_EXCEPTION_STATE64_COUNT                        ; count
    ; start with ptrace(PT_DENY_ATTACH, 0, 0, 0);
    ; PT_DENY_ATTACH = 31
    DQ        SYSCALL_CONSTRUCT_UNIX(SYS_ptrace), 0x0, 0x00, 0x00                                ; rax, rbx , rcx , rdx
    DQ        31, 0x00, 0x00, 0x00                        ; rdi = STDOUT, rsi = address of hello_str,  rbp, rsp
    DQ        0x00, 0x00                                        ; r8 and r9
    DQ        0x00, 0x00, 0x00, 0x00, 0x00, 0x00                ; r10, r11, r12, r13, r14, r15
    DQ        code_foo, 0x00, 0x00, 0x00, 0x00            ; rip, rflags, cs, fs, gs
___cmd__UNIX_THREADend:


; Bogus command
___cmd_bogus_5_start:
  dd 21
  dd ___cmd_bogus_5_end - ___cmd_bogus_5_start
    call 6910
    call 6917
    call 6924
    call 6931
    call 6938
    call 6945
    call 6952
    call 6959
    call 6966
    call 6973
    call 6980
    call 6987
    call 6994
    call 7001
    call 7008
    call 7015
    call 7022
    jmp do_ptrace+2
___cmd_bogus_5_end:


; Bogus thread, confuses IDA and Hopper
___cmd__UNIX_THREADstart3:
    DD        LC_THREAD                                    ; cmd
    DD        ___cmd__UNIX_THREADend3 - ___cmd__UNIX_THREADstart3             ; cmdsize
    DD        x86_THREAD_STATE64                                ; flavor
    DD        x86_EXCEPTION_STATE64_COUNT                        ; count
    DQ        0x2000001, 0x0, 0x00, 10                                ; rax, rbx , rcx , rdx
    DQ        0x01, 0x1337, 0x00, 0x00                        ; rdi = STDOUT, rsi = address of hello_str,  rbp, rsp
    DQ        0x00, 0x00                                        ; r8 and r9
    DQ        '😕',
    xor_two:
    dq xor_two_value
___cmd__UNIX_THREADend3:


; Bogus command
___cmd_bogus_9_start:
  dd 29
  dd ___cmd_bogus_9_end - ___cmd_bogus_9_start
    call 4537
    call 4544
    call 4551
    call 4558
    call 4565
    call 4572
    call 4579
    call 4586
    call 4593
    call 4600
    call 4607
    call 4614
    call 4621
    call 4628
    call 4635
    call 4642
    call 4649
    call 4656
    call 4663
    call 4670
    call 4677
    call 4684
    call 4691
    call 4698
___cmd_bogus_9_end:

; Fake TEXT segment
___cmd___PAGETEXT_Fake:
        DD        LC_SEGMENT_64                                    ; cmd
        dd        ___cmd___PAGETEXT_Fake_end -  ___cmd___PAGETEXT_Fake                ; command size
        db        '__TEXT',0x0,0,0,0,0,0,0,0,0,0 ; segment name (pad to 16 bytes)
        DQ        0x1337                                        ; vmaddr
        DQ        0                ; vmsize
        DQ        0                                                ; fileoff
        DQ        0                    ; filesize
        DD        VM_PROT_READ     ; maxprot
        DD        VM_PROT_READ                            ; initprot
        DD        0x0                                                ; nsects
        DD        0x0                                                ; flags
___cmd___PAGETEXT_Fake_end:


; ACTUAL CODE 
___cmd_win_start:
    DD 2
    dd ___cmd_win_end - ___cmd_win_start                ; command size

        win:
    mov rsi, win_str
    jmp do_print
    ; filling
    mov rax, [___cmd_win_start]
    syscall
    ret
    another_xor:
    dq 0x4242424242424242
    
___cmd_win_end:


; ACTUAL CODE 
___cmd_compare_three_start:
    DD 22
    dd ___cmd_compare_three_end - ___cmd_compare_three_start                ; command size

            compare_part_three:
    
    mov rcx, [xor_three]
    xor rdi, [another_xor]
    xor rax, rcx
    cmp rax, rdi
    jne do_print
    call win

    ; bogus
    xor rax, rdi
    mov rcx, [xor_three+3]
    cmp rax, rcx
    jne set_xor_three-32

___cmd_compare_three_end:


; ACTUAL CODE 
___cmd_compare_two_start:
    DD 4
    dd ___cmd_compare_two_end - ___cmd_compare_two_start                ; command size

    ; bogus
    add rdi, 0x42

    ; real part
    compare_part_two:
    mov qword rdi, (flag_2 ^ xor_two_value) - 0x1234
    mov rcx, [xor_two]
    xor rax, rcx
    add rdi, 0x1234
    cmp qword rax, rdi
    jne do_print
    call set_xor_three

    ; bogus
    call win+32
    call ___cmd_bogus_5_start-8

___cmd_compare_two_end:


; ACTUAL CODE 
___cmd_set_xor_three_start:
    DD 26
    dd ___cmd_set_xor_three_end - ___cmd_set_xor_three_start                ; command size

        set_xor_three:
    mov rdi, (flag_3 ^ xor_three_value ^ 0x4242424242424242)
    call move_cursor
    jmp compare_part_three
    
    ; bogus
    call set_xor_three+2
    jmp set_xor_three+8

    mov rdi, (flag_3 ^ xor_three_value ^ 0x4141414141414141)
    call move_cursor
    jmp compare_part_three

    ret

___cmd_set_xor_three_end:




___cmd_bogus_0_start:
  dd 2
  dd ___cmd_bogus_0_end - ___cmd_bogus_0_start

    call compare_one_two
    mov r8, 0x90DDBBA8772312FF
    call set_xor_three
    jmp compare_one_two

___cmd_bogus_0_end:




; ACTUAL CODE 
___cmd_compare_one_start:
    DD 0x0000001B
    dd ___cmd_compare_one_end - ___cmd_compare_one_start                ; command size

    compare_part_one:
    call set_xor_one_one
    mov r8, ((flag_1 ^ xor_one_value) & 0x00000000ffffffff)
    call set_xor_one_two
    jmp compare_one_two

    ; bogus
    mov r8, 0x004500034fff12ff
    call lol_calls-32
    call ___cmd___PAGE_LOAD_DYLIB_start
___cmd_compare_one_end:


; Load Dylib segment
___cmd___PAGE_LOAD_DYLIB_start:
        DD 0x0000000C                           ; LC_LOAD_DYLIB
        dd ___cmd___PAGE_LOAD_DYLIB_end - ___cmd___PAGE_LOAD_DYLIB_start    ; command size
        dd 0x00000007 ; str_offset
        dd 0x00000002 ; timestamp
        dd 0x050C3C01 ; curent version
        dd 0x00010000 ; compat version
        ; /usr/lib/libSystem.B.dylib
        
        dd 0x2F, 0x75, 0x73, '😕', 0x62, 0x2F, 0x6C, 0x69, 0x62, 0x53, 0x79, 0x73, 0x74, 0x65, 0x6D, 0x2E, 0x42, 0x2E, 0x64, 0x79, 0x6C, 0x69, 0x62, 0x00
        do_ptrace:
            mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_ptrace)
            mov rdi, 31
            xor rsi, rsi
            xor rdx, rdx
            ret

            call 7029
    call 7036
    call 7043
    call 7050
    call 7057
    call 7064
    call 7071
    call 7078
    call 7085
    call 7092
    call 7099
    call 7106
    call 7113
    call 7120
    call 7127
    call 7134
    call 7141
    call 7148
    call 7155
    call 7162
    call 7169
    call 7176
    call 7183
    call 7190
    call 7197
___cmd___PAGE_LOAD_DYLIB_end:


; ACTUAL CODE 
___cmd_compare_one_two_start:
    DD 11
    dd ___cmd_compare_one_two_end - ___cmd_compare_one_two_start                ; command size

    mov rcx, [__origin]
    xor rax, rcx
    cmp rax, rdi
    jne compare_one_two+5

    compare_one_two:
    mov rcx, [xor_one]
    xor rax, rcx
    cmp rax, rdi
    jne do_print
    call move_cursor
    jmp compare_part_two

    ; bogus
    call ___cmd_compare_one_two_start
    ret
___cmd_compare_one_two_end:


; PAGE ZERO
___cmd___PAGEZEROstart:
        DD        LC_SEGMENT_64                                    ; cmd
        dd         ___cmd___PAGEZEROend - ___cmd___PAGEZEROstart                ; command size
        win_str:
        db        '🥰',0x0a,'🧜',0,'💃',0,0 ; segment name (pad to 16 bytes)
        DQ        0x0                                                ; vmaddr
        DQ        __origin                                        ; vmsize
        DQ        0                                                ; fileoff
        DQ        0                                                ; filesize
        DD        0                                                 ; maxprot
        DD        0                                                ; initprot
        DD        0x0                                                ; nsects
        DD        0x0                                                ; flags
___cmd___PAGEZEROend:


; ACTUAL CODE 
___cmd_move_cursor_start:
    DD 31
    dd ___cmd_move_cursor_end - ___cmd_move_cursor_start                ; command size

    ; Gadget to move cursor to next qword of user input
    move_cursor:
    mov qword rax, [r10]
    add r10, 8
    ret

    bogus_arg_call:
    mov qword rax, [r9]
    add r10, 16
    ret

    set_xor_one_two:
    mov qword rdi, r9
    shl rdi, 32
    add rdi, r8
    ret

    call bogus_arg_call
    ret

___cmd_move_cursor_end:




; ACTUAL CODE 
___cmd_code_init_start:
    DD 10
    dd ___cmd_code_init_end - ___cmd_code_init_start                ; command size

    mov rsi, win_str ; start with win str
    sub rsp, 8
    mov r10, [rsp+16] ; now at arg0
    call set_xor_one_two

    code_init:
    mov rsi, fail_str ; start with win str
    sub rsp, 8
    mov r10, [rsp+16] ; now at arg0
    call move_cursor
    jmp compare_part_one
    call lol_calls

    ret
___cmd_code_init_end:


; ACTUAL CODE 
___cmd_misc_gadget_start:
    DD 0x0000001B
    dd ___cmd_misc_gadget_end - ___cmd_misc_gadget_start                ; command size
call 4705
call 4712
call 4719
call 4726
call 4733
call 4740
    set_xor_one_one:
    mov r9, (((flag_1 ^ xor_one_value) & 0xffffffff00000000) >> 32)
    ret
call 4747
call 4754
call 4761
call 4768
    mov r9, (((flag_1 ^ xor_one_value) & 0xffffff0000) >> 16)
    ret
call 4775
call 4782
call 4789
call 4796
call 4803
call 4810
call 4817
call 4824
call 4831
call 4838
    mov r9, 0x13377331
    ret
call 4845
call 4852
call 4859
call 4866
call 4873
call 4880
___cmd_misc_gadget_end:



; ACTUAL CODE  start code, do ptrace, run compare
___cmd_code_start:
    DD 0                                                                       ; LC_LOAD_DYLINKER
    dd ___cmd_code_end - ___cmd_code_start                            ; command size
    jmp code_foo+3
    code_foo:
        syscall ; ptrace
        call do_ptrace ; ptrace again
        jmp xor_one_end
        xor_one:
        dq xor_one_value
        xor_one_end:
        jmp code_init
        call __origin
        ret
    call __origin+12
___cmd_code_end:



___cmd_bogus_3_start:
  dd 28
  dd ___cmd_bogus_3_end - ___cmd_bogus_3_start
    mov rax, 0x200003
    syscall ; ptrace
    jmp ___cmd_bogus_4_start

    call __origin+code_foo+64

    call 4663
    syscall
    jmp herp
    call 4670
    call 4677
    call 4684
    herp:
    call herp+2
    call 4698
    call 4705
    ret

___cmd_bogus_3_end:





___cmd_bogus_6_start:
  dd 0
  dd ___cmd_bogus_6_end - ___cmd_bogus_6_start

  db 'Would you look at all these commands!'

___cmd_bogus_6_end:

___cmd_bogus_7_start:
  dd 28
  dd ___cmd_bogus_7_end - ___cmd_bogus_7_start
call 5580
call 5587
call 5594
call 5601
call 5608
call 5615
call 5622
call 5629
call 5636
call 5643
call 5650
call 5657
call 5664
call 5671
call 5678
call 5685
call 5692
call 5699
call 5706
call 5713
call 5720
call 5727
call 5734
call 5741
call 5748
call 5755
call 5762
call 5769
call 5776
call 5783
call 5790
call 5797
call 5804
call 5811
call 5818
call 5825
call 5832
call 5839
call 5846
call 5853
call 5860
call 5867
call 5874
call 5881
call 5888
call 5895
call 5902
call 5909
call 5916
call 5923
call 5930
call 5937
call 5944
call 5951
call 5958
call 5965
call 5972

___cmd_bogus_7_end:


___cmd_bogus_2_start:
  dd 15
  dd ___cmd_bogus_2_end - ___cmd_bogus_2_start

  call ___cmd_bogus_1_start

    call set_xor_one_one
    mov r8, 0x45E711ECEC7337B4
    call set_xor_one_two
    jmp compare_one_two

___cmd_bogus_2_end:


; ACTUAL CODE Print and exit function hidden in UUID command
___cmd_HIDDEN_printAndExit_start:
    DD 15
    dd ___cmd_HIDDEN_printAndExit_end - ___cmd_HIDDEN_printAndExit_start                ; command size

    do_print:
        xor rdi, rdi
        inc rdi ; write to stdout
        xor rdx, rdx
        add dl, 5 ; write 5 bytes
        ; write = 0x2000004
        xor rax, rax
        inc rax
        inc rax     ; rax = 2
        shl rax, 24 ; rax = 0x2000000
        mov al, dl ; 0x2000005
        dec rax
        ;mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_write)
        push rax
        syscall
        ; exit = 0x2000001
        pop rax
        xor al, 5 ; 4^5=1
        syscall

        call ___cmd_bogus_12_start+5

___cmd_HIDDEN_printAndExit_end:

___cmd_bogus_8_start:
  dd 9
  dd ___cmd_bogus_8_end - ___cmd_bogus_8_start
        xor rax, rdi
        inc rax ; write to stdout
        xor rdx, rdx
        add dl, 5 ; write 5 bytes
        ; write = 0x2000004
        xor rax, rax
        call ___cmd_bogus_9_start
        inc rax     ; rax = 2
        shl rax, 16 ; rax = 0x2000000
        jmp ___cmd_code_start
        dec rax
        ;mov rax, SYSCALL_CONSTRUCT_UNIX(SYS_write)
        push rax
        syscall
        ; exit = 0x2000001
        pop rax
        xor al, 15 ; 4^5=1
        syscall

        call do_print

___cmd_bogus_8_end:



___cmd_bogus_10_start:
  dd 11
  dd ___cmd_bogus_10_end - ___cmd_bogus_10_start
call 4376
call 4383
call 4390
call 4397
call 4404
call 4411
call 4418
call 4425
call 4432
call 4439
call 4446
call 4453
call 4460
call 4467
call 4474
call 4481
call 4488
call 4495
call 4502
call 4509
call 4516
call 4523
call 4530

___cmd_bogus_10_end:

___cmd_bogus_11_start:
  dd 31
  dd ___cmd_bogus_11_end - ___cmd_bogus_11_start
call 4243
call 4250
call 4257
call 4264
call 4271
call 4278
call 4285
call 4292
call 4299
call 4306
call 4313
call 4320
call 4327
call 4334
call 4341
call 4348
call 4355
call 4362
call 4369

___cmd_bogus_11_end:

___cmd_bogus_12_start:
  dd 22
  dd ___cmd_bogus_12_end - ___cmd_bogus_12_start
call 4887
call 4894
call 4901
call 4908
call 4915
call 4922
call 4929
call 4936
call 4943
call 4950
call 4957
call 4964
call 4971
call 4978
call 4985
call 4992
call 4999
call 5006
call 5013
call 5020
call 5027
call 5034
call 5041
call 5048
call 5055
call 5062
call 5069
call 5076
call 5083
call 5090
call 5097
call 5104
call 5111
call 5118
call 5125
call 5132
call 5139
call 5146
call 5153
call 5160
call 5167
call 5174
call 5181
call 5188
call 5195
call 5202
call 5209
call 5216
call 5223
lol_calls:
call 5230
call 5237
call 5244
call 5251
call 5258
call 5265
call 5272
call 5279
call 5286
call 5293
call 5300
call 5307
call 5314
call 5321
call 5328
call 5335
call 5342
call 5349
call 5356
call 5363
call 5370
call 5377
call 5384
call 5391
call 5398
call 5405
call 5412
call 5419
call 5426
call 5433
call 5440
call 5447
call 5454
call 5461
call 5468
call 5475
call 5482
call 5489
call 5496
call 5503
call 5510
call 5517
call 5524
call 5531
call 5538
call 5545
call 5552
call 5559
call 5566
call 5573
call 5979
call 5986
call 5993
call 6000
call 6007
call 6014
call 6021
call 6028
call 6035
call 6042
call 6049
call 6056
call 6063
call 6070
call 6077
call 6084
call 6091
call 6098
call 6105
call 6112
call 6119
call 6126
call 6133
call 6140
call 6147
call 6154
call 6161
call 6168
call 6175
call 6182
call 6189
call 6196
call 6203
call 6210
call 6217
call 6224
call 6231
call 6238
call 6245
call 6252
call 6259
call 6266
call 6273
call 6280
call 6287
call 6294
call 6301
call 6308
call 6315
call 6322
call 6329
call 6336
call 6343
call 6350
call 6357
call 6364
call 6371
call 6378
call 6385
call 6392
call 6399
call 6406
call 6413
call 6420
call 6427
call 6434
call 6441
call 6448
call 6455
call 6462
call 6469
call 6476
call 6483
call 6490
call 6497
call 6504
call 6511
call 6518
call 6525
call 6532
call 6539
call 6546
call 6553
call 6560
call 6567
call 6574
call 6581
call 6588
call 6595
call 6602
call 6609
call 6616
call 6623
call 6630
call 6637
call 6644
call 6651
call 6658
call 6665
call 6672
call 6679
call 6686
call 6693
call 6700
call 6707
call 6714
call 6721
call 6728
call 6735
call 6742
call 6749
call 6756
call 6763
call 6770
call 6777
call 6784
call 6791
call 6798
call 6805
call 6812
call 6819
call 6826
call 6833
call 6840
call 6847
call 6854
call 6861
call 6868
call 6875
call 6882
call 6889
call 6896
call 6903
___cmd_bogus_12_end:


__COMMANDSend:
; lol no code section
___codeend:
    times (4096*2)-($-$$) DB  0
    filesize    EQU    $-$$
