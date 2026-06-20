global ft_atoi_base

section .text

; we should skip spaces first
; check if we have a sign or not. There should be at most one sign or none
ft_atoi_base: ; (rdi = const char* arg, rsi = const char* base)
    push rsi ; save rsi
    push rdi ; save rdi
    mov rdi, rsi
    xor rax, rax
    call ft_strlen
    test rax, rax
    jz .done ; if the base len is 0 then we should stop
    pop rdi ; put back arg into rdi
.loop_skip_space:
    call ft_isspace
    test rax, rax
    jz .sign_check
    inc rdi
    jmp .loop_skip_space
.sign_check:
.done:
    ret

ft_strlen:
    xor rax, rax ; zero out rax
.loop:
    cmp byte [rdi + rax], 0 ; compare if current byte is 0 (\0)
    je .done ; if it is terminate and return, otherwise keep adding
    inc rax ; rax always is returned
    jmp .loop
.done:
    ret

ft_isspace:
    xor rax, rax ; zero the rax
    cmp qword [rdi], 0x9 ; compare with tab character '\t'
    je .done
    cmp qword [rdi], 0xa ; compare with space character '\n'
    je .done
    cmp qword [rdi], 0xb ; compare with space character '\v'
    je .done
    cmp qword [rdi], 0xc ; compare with space character '\v'
    je .done
    cmp qword [rdi], 0xd ; compare with space character '\r'
    je .done
    cmp qword [rdi], 0x20 ; compare with space character ' '
    je .done
.done:
    mov rax, 0x1
    ret
