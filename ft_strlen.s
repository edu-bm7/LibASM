global ft_strlen
section .text
ft_strlen:
    ;; Function prologue
    ;; Preserve the base pointer
    push rbp
    ;; Set the new frame base pointer
    mov rbp, rsp

    ;; size_t strlen(const char *s), so we'll return in rax register
    ;; the argument on rdi register(first argument)

    ;; First we set our counter register to 0
    xor rcx, rcx

.loop:
    ;; We then compare our characters in the string to the `\0` and loop it
    cmp byte [rdi], 0
    je .end
    add rdi, 1
    add rcx, 1
    jmp .loop

.end:
    ;; we then mov the value that our counter stored into the rax register
    mov rax, rcx
    ;; restore the base pointer
    ;; Function epilogue
    pop rbp
    ret


