global ft_list_remove_if

extern free

section .text

ft_list_remove_if: ; (rdi = t_list **begin_list, rsi = void *data_ref, rdx = int (*cmp)(), rcx = void (*free_func)())
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi ; r12 = begin_list
    mov r13, rsi ; r13 = data_ref
    mov r14, rdx;  r14 = cmp
    mov r15, rcx ; r15 = free_func
    test r12, r12
    jz .done
.loop:
    cmp qword [r12], 0x0
    je .done
    mov rdi, [r12] ; rdi = current node t_list*
    mov rdi, [rdi] ; rdi = node->data
    mov rsi, r13
    call r14
    test eax, eax
    jnz .advance
    mov r9, [r12] ; r9 = current node
    mov rdi, [r9] ; rdi = node->data
    call r15
    mov r9, [r12] ; r9 = current node
    mov r8, [r9 + 0x8] ; r8 = node->next ---> r8 now has the address of the next node*
    mov [r12], r8 ; we dereference the address of whatever r12 is pointing to and set it to r8
    mov rdi, r9
    call free wrt ..plt
    jmp .loop
.advance:
    mov r12, [r12] ; r12 = current node
    lea r12, [r12 + 0x8] ; r12 = &node->next
    jmp .loop
.done:
    pop r15
    pop r14
    pop r13
    pop r12
    ret
