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
    xchg rdi, rsi ;; move base to rdi so we can call strlen
    mov rbx, rdi ;; rbx is our scan ptr
    call ft_strlen
    cmp rax, 2
    jb .error
    mov r12, rax ;; our base length in callee-saved register
    mov rdi, rbx
.valid_base_loop: ;; Check if we have a valid base
    mov r9b, [rbx]
    test r9b, r9b
    je .base_ok ; End of loop NULL

    cmp r9b, PLUS ;; forbids '+'
    je .error
    cmp r9b, MINUS ;; forbids '-'
    je .error
    
    ;; Forbids range \t <-> /r (spaces)
    cmp r9b, TAB ;; '\t'
    jb .printable_ok
    cmp r9b, CR ;; '\r'
    ja .printable_ok
    jmp .error
.printable_ok:
    cmp r9b, SPACE ;; ' '
    je .error
    cmp r9b, DEL ;; 'DEL'
    ja .error
    mov rcx, rdi ;; rdi is our base here

.dup_find_loop:
    ;; Checks if all characters of rcx already been checked before been equal to first char of rbx
    cmp rcx, rbx
    je .dup_not_found ;; if so, there isn't duplicates, move to the next rbx
    mov al, byte [rcx]
    cmp al, r9b ;; test [rcx] against [rbx] 
    je .error ;; if its equal there is duplicates
    add rcx, 1
    jmp .dup_find_loop

.dup_not_found:
    add rbx, 1 ;; next base character to test
    jmp .valid_base_loop

    
.base_ok:
    xchg rdi, rsi ;; revert rdi <-> rsi so base is rdi str is rsi
    xor r13, r13 ;; our accumulator variable
    mov rdx, 1 ;; our sign variable

.skip_spaces:
    mov r14b, byte [rdi]
    ;; Skip all spaces before the base
    cmp r14b, TAB ;; '\t'
    jb .not_space
    cmp r14b, CR ;; '\r'
    ja .not_space

.is_space:
    add rdi, 1
    jmp .skip_spaces

.not_space:
    cmp r14b, SPACE ;; ' '
    je .is_space

;; Handle multiple signs
.handle_sign:
    cmp byte [rdi], PLUS ;; '+'
    jne .test_negative
    add rdi, 1
    jmp .handle_sign

.change_sign:
    neg rdx ;; invert the sign
    add rdi, 1
    jmp .handle_sign

.test_negative:
    cmp byte [rdi], MINUS ;; '-'
    je .change_sign

.atoi_main_loop_preparation:
    ;; we need to call find_char_index(base, *str)
    ;; we need to swap their positions
    xchg rdi, rsi ;; rsi <-> rdi
    mov r8, rdi ;; save rdi to r8 so we can restore our base later

.outer_loop:
    mov rdi, r8 ;; restore the base to continue the loop
    xor rcx, rcx ;; zero our counter
    ;; move the rsi character into r9b to test if we reach the end of string \0
    mov r9b, byte [rsi] 
    test r9b, r9b
    jz .finish

.next_digit:
    mov rbx, rsi ;; RBX is our base pointer, that we'll use in our loop
    
.find_char:
    mov r10b, byte [rdi] ;; test if we already checked all our base
    test r10b, r10b
    jz .finish
    mov al, byte [rbx] ;; test if our str found an index in the base
    test al, al
    jz .not_found
    cmp al, r10b
    je .found
    add rdi, 1
    add rcx, 1
    jmp .find_char

.found:
    imul r13, r12 ;; multiply our accumulator * base_length
    add r13, rcx ;; adds the base index to our accumulator
    add rsi, 1
    jmp .outer_loop

.not_found:
    test r10b, r10b
    jz .finish
    add rsi, 1
    jmp .next_digit

.finish:
    imul r13, rdx
    mov rax, r13
    ret

.error:
    xor rax, rax
    ret
