global ft_strcpy

section .text

ft_strcpy:
    push rbx ; save the rbx because we ll use it
    xor rbx, rbx ; zero out the rbx register, this will be our index
.loop:
    mov byte al, [rsi + rbx] ; copy the offset byte in rsi to al (byte in rax)
    mov byte [rdi + rbx], al ; copy al to offset rdx...we can not copy from memory register to memory register
    cmp byte [rdi + rbx], 0
    je .done ; if we copied a 0 then we are done
    inc rbx ; otherwise continue and inc counter
    jmp .loop
.done:
    pop rbx ; reset rbx
    mov rax, rdi
    ret

