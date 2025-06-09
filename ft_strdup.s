global ft_strdup
extern __errno_location
extern ft_strcpy
extern ft_strlen
extern malloc

section .text
ft_strdup:
    ;; Function Prologue
    ;; Preserve base pointer
    push rbp
    ;; Set new frame base pointer
    mov rbp, rsp
    ;; Reserve stack space for local variable
    sub rsp, 8
    mov [rbp-8], rdi ;; save rdi (our string) into local variable because malloc change the registers
    call ft_strlen
    add rax, 1 ;; space for null-terminator
    mov rdi, rax ;; prepare for malloc call
    call malloc wrt ..plt
    ;; xor rax, rax  ;; Uncomment this instruction to test malloc failure
    test rax, rax
    jz .error
    mov rdi, rax
    mov rsi, [rbp-8] ;; pass the variable to the rsi register so we can call strcpy
    call ft_strcpy
    add rsp, 8 ;; pop back the space taken by the variable, maintaining the stack aligned
    ;; Function Epilogue
    pop rbp
    ret

.error:
    mov edi, 12 ;; errno = (ENOMEM)
    call __errno_location wrt ..plt
    mov [rax], edi ;; write in memory the value of errno
    xor rax, rax ;; return NULL on error
    add rsp, 8 ;; alignment
    ;; Function Epilogue
    pop rbp
    ret
