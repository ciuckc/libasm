global ft_list_sort

ft_list_sort: ; (t_list** begin_list = rdi, int (*cmp)() = rsi)
    push r12
    push r13
    push r14
    push r15
    test rdi, rdi ; if begin_list == NULL
    jz .done
    cmp qword [rdi], 0x0 ; if *begin_list == NULL
    jz .done
    mov r12, [rdi] ; head
    mov r14, rsi ; func ptr
.outer_loop:
    xor r15, r15 ; did_swap = 0
    mov r13, r12 ; current = head
.inner_loop:
    cmp qword [r13 + 0x8], 0x0 ; if next is NULL
    je .check_done
    mov rdi, [r13] ; rdi = current->data
    mov rsi, [r13 + 0x8]
    mov rsi, [rsi] ; rsi = current->next->data
    call r14 ; call the cmp function pointer
    cmp rax, 0x0
    jle .advance_current
    mov rax, [r13 + 0x8] ; rax = current->next
    mov rcx, [rax] ; rcx = current->next->data
    mov r8, [r13]; r8 = current->data
    mov [r13], rcx ; current->data = current->next->data
    mov [rax], r8 ; current->next->data = current->data (temp)
    inc r15
.advance_current:
    mov r13, [r13 + 0x8]
    jmp .inner_loop
.check_done:
    test r15, r15
    jnz .outer_loop
.done:
    pop r15
    pop r14
    pop r13
    pop r12
    ret
