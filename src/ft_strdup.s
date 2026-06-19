global ft_strdup

extern malloc

ft_strdup: ; (rdi = const char *str)
    push rdi ; save pointer on stack in case it gets thrashed
    call ft_strlen ; get the len in rax
    lea rdi, [rax + 1] ; put len in rdi as argument for malloc
    push rdi ; save the len on the stack
    call malloc wrt ..plt
    test rax, rax ; AND rax to see if we got a nullptr
    jz .malloc_fail
    mov rdi, rax ; set the address of the dest
    pop rdx ; put len in rdx
    pop rsi ; put src in rsi
    push rdi ; put src on the stack in case it get thrashed
    call ft_memcpy ; copy the memory ofc
    pop rax
    ret
.malloc_fail:
    add rsp, 0x10 ; pop those two values that we ve added
    ret

ft_strlen: ; (rdi = const char* str)
    xor rax, rax
.loop:
    cmp byte [rdi], 0x0 ; check if null
    jz .done
    inc rdi
    inc rax
    jmp .loop
.done:
    ret

ft_memcpy: ; (rdi = void* dest, rsi = const void* src, rdx = size_t n)
.loop:
    test rdx, rdx
    jz .done
    mov al, [rsi]
    mov [rdi], al
    inc rdi
    inc rsi
    dec rdx
    jmp .loop
.done:
    ret
