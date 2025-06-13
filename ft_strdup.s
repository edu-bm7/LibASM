global ft_strdup
extern __errno_location
extern ft_strcpy
extern ft_strlen
extern malloc

section .text
ft_strdup:
    ;; Since we need to call other functions inside this one, we can't omit the
    ;; frame-pointer
    ;; Function Prologue
    ;; Preserve base pointer
    push rbp
    ;; Set new frame base pointer
    mov rbp, rsp
    ;; Reserve stack space for local variable
    sub rsp, 8
    mov [rbp-8], rdi           ;; Save RDI (our string) into local variable
                               ;; because malloc change the caller-saved scratch registers.
    call ft_strlen
    add rax, 1                 ;; Space for null-terminator.
    mov rdi, rax               ;; Prepare for malloc call.
    call malloc wrt ..plt
    ;; xor rax, rax            ;; Uncomment this instruction to test malloc failure.
    test rax, rax
    jz .error
    mov rdi, rax
    mov rsi, [rbp-8]
    call ft_strcpy
    add rsp, 8                 ;; Pop back the space taken by the variable,
                               ;; maintaining the stack aligned.
    ;; Function Epilogue
    pop rbp
    ret

.error:
    mov edi, 12                 ;; errno = (ENOMEM)
    call __errno_location wrt ..plt
    mov [rax], edi
    xor rax, rax
    add rsp, 8
    ;; Function Epilogue
    pop rbp
    ret
