;; ft_atoi_base(char *str, char *base)
global ft_atoi_base
extern ft_strlen

section .text
ft_atoi_base:
    ;; Function Prologue
    ;; Preserve base pointer
    push rbp
    ;; Set the new frame base pointer
    mov rbp, rsp
    ;; Set enough space for our local variables
    sub rsp, 40
    mov [rbp-8], rdi ;; save our original str
    mov [rbp-24], rdi ;; rbp-8 will be lost, fix latter
    mov [rbp-16], rsi ;; save our original base
    mov rdi, rsi ;; move base to rdi so we can call strlen
    call ft_strlen
    cmp rax, 1
    jle error
    mov r8, rax ;; our base length
    mov rdi, [rbp-16]
    call ft_is_valid_base
    test rax, rax
    jz error
    mov rdi, [rbp-8] ;; original string
    mov rsi, [rbp-16] ;; base
    xor rdx, rdx ;; our sign variable
    xor r9, r9 ;; our num variable
    mov rdx, 1
    
.while_is_space:
    call ft_isspace
    test eax, eax
    jz .while_is_sign
    add rdi, 1
    jmp .while_is_space

.while_is_sign:

    cmp byte [rdi], 43
    jne .test_negative
    add rdi, 1
    jmp .while_is_sign
.test_negative:
    cmp byte [rdi], 45
    je .change_sign
    jne .atoi_main_loop_preparation

.change_sign:
    neg rdx
    add rdi, 1
    jmp .while_is_sign

.atoi_main_loop_preparation:
    ;; we need to call find_char_index(base, *str)
    ;; str in on rdi, and base on rsi, r8 also holds the base, r9 is our num value rbp-8 our base_length
    ;; we need to swap their positions
    mov [rbp-40], rsi
    xchg rdi, rsi
.atoi_main_loop:
    cmp byte [rsi], 0
    je .end
    call find_char_index
    cmp rax, -1
    je .end
    mov rdi, [rbp-40]
    imul r9, r8
    add r9, rax
    add rsi, 1
    jmp .atoi_main_loop

.end:
    imul r9, rdx
    mov rax, r9
    add rsp, 40
    pop rbp
    ret
    
ft_is_valid_base:
.alignment:
    push rbp
    mov rbp, rsp
    sub rsp, 40
    cmp r8b, 1
    jle .end
.main_loop:
    cmp byte [rdi], 0
    je .end
    cmp byte [rdi], 43 ;; '+' in ASCII table
    je .error
    cmp byte [rdi], 45 ;; '-' in ASCII table
    je .error
    mov [rbp-24], rdi
    call ft_isprint
    test eax, eax
    jz .error
    mov rdi, [rbp-24]
    call ft_isspace
    test eax, eax
    jnz .error
    mov rdi, [rbp-24]
    mov rsi, rdi
    add rdi, 1
    mov [rbp-24], rdi
    call find_char_index
    cmp eax, 0
    jge .error
    mov rdi, [rbp-24]
    jmp .main_loop

.error:
    xor rax, rax
    add rsp, 40
    pop rbp
    ret

.end:
    mov rax, 1
    add rsp, 40
    pop rbp
    ret

find_char_index:
    cmp byte [rsi], 0
    je .string_empty
    xor rcx, rcx ;; zero our counter

.loop_string:
    mov al, [rdi]
    test al, al
    jz .end_of_loop
    cmp al, byte [rsi]
    je .found
    add rcx, 1
    add rdi, 1
    jmp .loop_string

.found:
    mov rax, rcx
    ret

.end_of_loop:
    mov rax, -1
    ret

.string_empty:
    xor rax, rax
    ret

ft_isprint:
    cmp byte [rdi], 32 ;; ' ' in ASCII table
    jb .not_in_range
    cmp byte [rdi], 126 ;; '~' in ASCII table
    ja .not_in_range
    mov rax, 1
    ret

.not_in_range:
    xor rax, rax
    ret

ft_isspace: 
    cmp	byte [rdi], 9	;; '\t' in ASCII table
    jb .not_in_range
    cmp byte [rdi], 13 ;; '\r' in ASCII table
    ja .not_in_range
    mov rax, 1
    ret

.not_in_range:
    cmp byte [rdi], 32 ;; ' ' in ASCII table
    je .space
    xor rax, rax
    ret

.space:
    mov rax, 1
    ret

error:
    xor rax, rax
    add rsp, 40
    pop rbp
    ret


