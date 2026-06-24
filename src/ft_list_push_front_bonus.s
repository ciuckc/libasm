global ft_list_push_front

extern malloc

section .text

ft_list_push_front: ; (t_list **begin_list = rdi, void* data = rsi)
    test rdi, rdi
    jz .done ; if list is null return
    push rsi
    push rdi
    mov rdi, 0x10 ; sizeof(t_list) == 16
    call malloc wrt ..plt
    test rax, rax
    jz .done ; if nullptr, we are done
    pop rdi ; get back the begin_list ptr
    pop rsi ; get back the data ptr
    mov [rax], rsi ; set new node data with data
    mov rcx, [rdi] ; save head of list into rcx -> rcx is a temp
    mov [rax + 0x8], rcx ; set the next to be the old head
    mov [rdi], rax ; set rax to be the head of list
.done:
    ret
