extern __errno_location

global ft_write

section .text

ft_write:
    mov rax, 0x1 ; write opcode
    syscall ; call write
    test rax, rax ; set all flags in order to see if SignedFlag was set
    jns .done ; if the flag is not signed then that means the result was >= 0
    neg rax ; otherwise negate the negative value to make it positive, this is the err code
    push rax ; save it onto the stack
    call __errno_location ; get the pointer to errno
    pop rcx ; load the previous error code into rcx
    mov [rax], rcx ; set the errno with the err code
    mov rax, -1 ; set the return value to -1
.done:
    ret

