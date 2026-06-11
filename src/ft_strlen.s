global ft_strlen

section .text

ft_strlen:
    xor rax, rax ; zero out rax
.loop:
    cmp byte [rdi + rax], 0 ; compare if current byte is 0 (\0)
    je .done ; if it is terminate and return, otherwise keep adding
    inc rax ; rax always is returned
    jmp .loop
.done:
    ret
