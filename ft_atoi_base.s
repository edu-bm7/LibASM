;; ft_atoi_base(char *str, char *base)
global ft_atoi_base
extern ft_strlen

TAB	equ 9
CR	equ 13
SPACE	equ 32
DEL	equ 126
PLUS	equ 43
MINUS	equ 45

section .text
ft_atoi_base:
    xchg rdi, rsi           ;; Swap RDI <-> RSI so we can call ft_strlen() with the base.
    mov rbx, rdi            ;; RBX is our scan ptr.
    call ft_strlen
    cmp rax, 2
    jb .error
    mov r12, rax            ;; Our base length in callee-saved register.
    mov rdi, rbx

.valid_base_loop:           ;; Check if we have a valid base.
    mov r9b, byte [rbx]
    test r9b, r9b
    je .base_ok             ;; End of loop NULL.

    cmp r9b, PLUS           ;; Forbids '+'.
    je .error
    cmp r9b, MINUS          ;; Forbids '-'.
    je .error

    ;; Forbids spaces
    cmp r9b, TAB            ;; '\t'
    jb .printable_ok
    cmp r9b, CR             ;; '\r'
    ja .printable_ok
    jmp .error

.printable_ok:
    cmp r9b, SPACE          ;; ' '
    je .error
    cmp r9b, DEL            ;; 'DEL'
    ja .error
    mov rcx, rdi            ;; RDI is our base here.

.dup_find_loop:
    ;; Check if all characters of RCX have been checked 
    ;; when it reaches the first character of RBX.
    cmp rcx, rbx
    je .dup_not_found       ;; If so, there isn't duplicates, move to the next RBX.
    mov al, byte [rcx]
    cmp al, r9b             ;; Test byte [RBX] against byte [RCX].
    je .error               ;; If its equal there is duplicates.
    add rcx, 1
    jmp .dup_find_loop

.dup_not_found:
    add rbx, 1              ;; Next base character to test.
    jmp .valid_base_loop

.base_ok:
    xchg rdi, rsi           ;; Swap RDI <-> RSI, in a way that base is RDI and, str is RSI.
    xor r13, r13            ;; Our Accumulator variable.
    mov rdx, 1              ;; Our Sign variable.

.skip_spaces:
    mov r14b, byte [rdi]
    ;; Skip all spaces before the base
    cmp r14b, TAB           ;; '\t'
    jb .not_space
    cmp r14b, CR            ;; '\r'
    ja .not_space

.is_space:
    add rdi, 1
    jmp .skip_spaces

.not_space:
    cmp r14b, SPACE         ;; ' '
    je .is_space

;; Handle multiple signs
.handle_sign:
    cmp byte [rdi], PLUS    ;; '+'
    jne .test_negative
    add rdi, 1
    jmp .handle_sign

.change_sign:
    neg rdx                  ;; Invert the sign.
    add rdi, 1
    jmp .handle_sign

.test_negative:
    cmp byte [rdi], MINUS    ;; '-'
    je .change_sign

.atoi_main_loop_preparation:
    ;; To call find_char_index(base, *str)
    ;; we need to swap their positions.
    xchg rdi, rsi           ;; RSI <-> RDI.
    mov r8, rdi             ;; Save RDI in R8 so we can restore our base later.

.outer_loop:
    mov rdi, r8             ;; Restore the base to continue the loop.
    xor rcx, rcx            ;; Zero out our counter.
    mov r9b, byte [rsi]     ;; Test if we reached end of string ('\0').
    test r9b, r9b
    jz .finish

.next_digit:
    mov rbx, rsi            ;; RBX is our base pointer, that we'll use in our loop.

.find_char:
    mov r10b, byte [rdi]    ;; Rest if we reached end of base string ('\0').
    test r10b, r10b
    jz .finish
    mov al, byte [rbx]      ;; Test if our str found an index in the base.
    test al, al
    jz .not_found
    cmp al, r10b
    je .found
    add rdi, 1
    add rcx, 1
    jmp .find_char

.found:
    imul r13, r12           ;; Multiply our accumulator * base_length.
    add r13, rcx            ;; Adds the base index to our accumulator.
    add rsi, 1
    jmp .outer_loop

.not_found:
    test r10b, r10b
    jz .finish
    add rsi, 1
    jmp .next_digit

.finish:
    imul r13, rdx           ;; Multiply our accumulator * sign.
    mov rax, r13            ;; Move it to the RAX register.
    ret

.error:
    xor rax, rax            ;; Zero out the RAX register on error.
    ret
