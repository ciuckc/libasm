global ft_read

extern __errno_location

section .text

ft_read:
    mov rax, 0x0
    syscall
    test rax, rax
    jns .done
    neg rax
    push rax
    call __errno_location wrt ..plt
    pop rcx
    mov [rax], ecx
    mov rax, -1
.done:
    ret
