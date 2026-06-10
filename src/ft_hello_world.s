global ft_hello_world

section .text

ft_hello_world:
    push rbp ; save callers base pointer onto the stack
    mov rbp, rsp ; set current stack pointer address as the local stack base pointer
    sub rsp, 0x4 ; allocate 4 bytes for an integer
    mov dword [rbp - 0x4], 5 ; set 'i' to 5
loop:
    cmp dword [rbp - 0x4], 0 ; check if 'i' is 0
    je done ; this will jump to done if the above i == 0, otherwise falltrough
    mov rax, 0x1 ; write opcode
    mov rdi, 0x1 ; fd
    lea rsi, [rel hello_world] ; char buffer
    mov rdx, hello_world_len ; len
    syscall
    sub dword [rbp - 0x4], 1
    jmp loop
done:
    mov rsp, rbp
    pop rbp
    ret

section .rodata

hello_world:
    db "Hello world!", 0x0A

hello_world_len equ $ - hello_world
