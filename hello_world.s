global _start

section .text

_start:
    mov rax, 1 ; 1 is opcode for sys call write
    mov rdi, 1 ; 1 is for stdout
    mov rsi, message ; fill up char buffer
    mov rdx, 13 ; set length
    syscall ; make the syscall
    mov rax, 60 ; exit syscall
    xor rdi, rdi
    syscall

section .data

message:
    db "Hello, world", 10
