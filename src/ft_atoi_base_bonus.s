global ft_atoi_base

section .text

; we should skip spaces first
; check if we have a sign or not. There should be at most one sign or none
ft_atoi_base: ; (rdi = const char* arg, rsi = const char* base)
    push rdi
    mov rdi, rsi
    mov rcx, 1 ; rcx will be our sign
    call ft_strlen
    mov r8, rax ; save the base len in r8
    xor rax, rax ; clean up rax
    pop rdi ; pop back the rdi from stack
    cmp r8, 0x1 ; if base len if less or equal than 1 then we need to return
    jle .done
.loop_skip_space:
    call ft_isspace
    test rax, rax
    jz .sign_check
    inc rdi
    jmp .loop_skip_space
.sign_check:
    cmp byte [rdi], 0x2B ; compare with '+' char
    je .skip_sign
    cmp byte [rdi], 0x2D ; compare with '-' char
    jne .loop_numbers
    mov rcx, -1 ; save the negative sign
.skip_sign:
    inc rdi ; move to the next byte it should be a number
.loop_numbers:
    movzx rbx, byte [rdi] ; save the char into rbx with sign extended
    xor r9, r9 ; we ll use r9 as index for base
.find_in_base:
    movzx rdx, byte [rsi + r9] ; save the cuurent offset base char into rdx
    cmp dl, bl ; compare the current arg char with the base char
    je .found ; if they are equal then we found one
    inc r9
    cmp r9, r8
    jl .find_in_base ; if it s less then we can continue searching
    jmp .done ; otherwise it's equal so we didn't find a valid char in the base so we can return
.found:
    imul rax, r8 ; we multiply the current value with the base length ex: i * 10
    add rax, r9 ; we add the offset from the base
    inc rdi
    jmp .loop_numbers
.done:
    imul rax, rcx ; multiply value with sign
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
    cmp byte [rdi], 0x9 ; compare with tab character '\t'
    je .done
    cmp byte [rdi], 0xa ; compare with space character '\n'
    je .done
    cmp byte [rdi], 0xb ; compare with space character '\v'
    je .done
    cmp byte [rdi], 0xc ; compare with space character '\v'
    je .done
    cmp byte [rdi], 0xd ; compare with space character '\r'
    je .done
    cmp byte [rdi], 0x20 ; compare with space character ' '
    je .done
    ret
.done:
    mov rax, 0x1
    ret
