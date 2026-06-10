global _start

section .text

_start:
    mov rax, 0x01 ; 1 is opcode for sys call write
    mov rdi, 0x01 ; 1 is for stdout
    mov rsi, message ; fill up char buffer
    mov rdx, len ; set length
    syscall ; make the syscall
    mov rax, 0x3C ; exit syscall
    syscall

section .data

message:
    db "Hello, world", 0x0A ; db is data bytes, and 0x0A is the new line char

len equ $ - message
