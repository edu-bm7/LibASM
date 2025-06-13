global ft_strlen
section .text
ft_strlen:
    ;; ft_strlen is a leaf function so we can do frame-pointer omission (no push rbp...)
    ;; because we don't make any calls to other functions, so we don't need to
    ;; restore the frame pointer for our callees
    ;; size_t strlen(const char *s), 
    ;; We'll return in RAX register the argument in RDI register(first argument)

    ;; First we set our counter to 0
    xor rax, rax

.loop:
    ;; We then compare our characters in the string to the `\0` and loop it
    cmp byte [rdi], 0
    je .end
    add rdi, 1
    add rax, 1
    jmp .loop

.end:
    ret


