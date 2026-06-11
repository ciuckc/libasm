global ft_strcmp

section .text

ft_strcmp:
    push rbp
    mov rbp, rsp
    xor rax, rax
.loop:
    mov byte al, [rdi] ; put curr s1 byte into lower byte register al (rax)
    cmp byte al, 0x0 ; check s1 is null terminator
    je .done
    cmp byte [rsi], 0x0 ; check s2 is null terminator
    je .done
    cmp byte [rsi], al ; compare s1 byte with s2 byte
    jne .done ; if not equal be done, otherwise continue
    inc rdi
    inc rsi
    jmp .loop
.done:
    sub al, [rsi] ; substract the value of s2 from s1
    movsx rax, al ; then we move the signed value into rax to extend the sign
    mov rsp, rbp ; restore the base pointer
    pop rbp
    ret
