;; char *ft_strcpy(char *dst,const char *src)
section .text
    global ft_strcpy
;; rdi will be our buffer, and rsi our source, rax our return value.
ft_strcpy:
    ;; Save a reference to the source pointer into our return value.
    mov rax, rdi

.loop:
    cmp byte [rsi], 0
    je .end
    movsb
    jmp .loop

.end:
    movsb ;; copy the null-terminator '\0'
    ret

