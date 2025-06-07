section .text
    global ft_strcmp
;; int strcmp(const char *s1, const char *s2);
;; It returns a positive number if s1 > s2, negative if s1 < s2 and 0 if they are equal
;; s1 is rdi, s2 is rsi
ft_strcmp:
    cmp byte [rdi], 0x00
    je .end
    mov dl, [rdi]
    cmp dl, [rsi]
    jne .end
    add rdi, 1
    add rsi, 1
    jmp ft_strcmp

.end:
    movzx edx, byte [rdi]
    movzx ecx, byte [rsi]
    sub edx, ecx
    mov eax, edx
    ret
