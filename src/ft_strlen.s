global ft_strlen

section .text

ft_strlen:
    push rbp ; save callers stack base pointer
    mov rbp, rsp ; set the current stack pointer as the base pointer
    xor rax, rax ; zero out rax
loop:
    cmp byte [rdi + rax], 0 ; compare if current byte is 0 (\0)
    je done ; if it is terminate and return, otherwise keep adding
    add rax, 1 ; rax always is returned
    jmp loop
done:
    mov rsp, rbp
    pop rbp
    ret
