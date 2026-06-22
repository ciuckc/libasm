global ft_list_size

section .text

ft_list_size: ; (t_list* begin_list)
    xor eax, eax
.loop:
    test rdi, rdi
    jz .done
    inc eax
    mov rdi, [rdi + 0x8]
    jmp .loop
.done:
    movsx rax, eax
    ret
