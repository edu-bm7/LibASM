global ft_strcpy
;; char *ft_strcpy(char *dst,const char *src)
section .text
ft_strcpy:
    ;; Save a reference to the source pointer into our return value.
    mov rax, rdi

.loop:
    cmp byte [rsi], 0
    je .end
    movsb              ;; movsb moves a byte from rdi <- rsi src to dst
    jmp .loop

.end:
    movsb ;; copy the null-terminator '\0'
    ret

