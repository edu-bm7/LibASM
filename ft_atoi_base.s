;; ft_atoi_base(char *str, char *base)
;; After a refactor and taking into consideration that this is a leaf function and
;; to avoid the function call/return excessive overhead, I've taking the approach
;; to only use caller-saved registers 
;; 
global ft_atoi_base

;; Our Constants
TAB	equ 9
CR	equ 13
SPACE	equ 32
DEL	equ 126
PLUS	equ 43
MINUS	equ 45

section .text
ft_atoi_base:
    mov r10, rsi             ;; Our base pointer, save it into r10 so we can restore it later
    xor r11, r11             ;; Our base length
.find_base_len:
    cmp byte [rsi], 0
    je .prepare_to_valid_base
    add rsi, 1
    add r11, 1
    jmp .find_base_len

.prepare_to_valid_base:
    cmp r11, 2
    jb .error
    mov rsi, r10             ;; restore our base value value

.valid_base_loop:            ;; Check if we have a valid base.
    mov r9b, byte [r10]
    test r9b, r9b
    je .base_ok              ;; End of loop NULL.

    cmp r9b, PLUS            ;; Forbids '+'.
    je .error
    cmp r9b, MINUS           ;; Forbids '-'.
    je .error

    ;; Forbids spaces
    cmp r9b, TAB             ;; '\t'
    jb .printable_ok
    cmp r9b, CR              ;; '\r'
    ja .printable_ok
    jmp .error

.printable_ok:
    cmp r9b, SPACE           ;; ' '
    je .error
    cmp r9b, DEL             ;; 'DEL'
    ja .error
    mov rcx, rsi             ;; RDI is our base here.

.dup_find_loop:
    ;; Check if all characters of RCX have been checked 
    ;; when it reaches the first character of R10.
    cmp rcx, r10
    je .dup_not_found        ;; If so, there isn't duplicates, move to the next R10.
    mov al, byte [rcx]
    cmp al, r9b              ;; Test byte [RAX] against byte [R9].
    je .error
    ;; If its equal there is duplicates.
    add rcx, 1
    jmp .dup_find_loop

.dup_not_found:
    add r10, 1               ;; Next base character to test.
    jmp .valid_base_loop

.base_ok:
    xor r9, r9               ;; Our Accumulator variable.
    mov rdx, 1               ;; Our Sign variable.

.skip_spaces:
    mov al, byte [rdi]
    ;; Skip all spaces before the base
    cmp al, TAB              ;; '\t'
    jb .not_space
    cmp al, CR               ;; '\r'
    ja .not_space

.is_space:
    add rdi, 1
    jmp .skip_spaces

.not_space:
    cmp al, SPACE            ;; ' '
    je .is_space

;; Handle multiple signs
.handle_sign:
    cmp byte [rdi], PLUS     ;; '+'
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
    ;; ft_atoi_base main loop preparation
    ;; To call find_char_index(base, *str)
    ;; we need to swap their positions.
    xchg rdi, rsi            ;; RSI <-> RDI.
    mov r8, rdi              ;; Save RDI in R8 so we can restore our base later.

.outer_loop:
    mov cl, byte [rsi]       ;; Test if we reached end of string on RSI ('\0').
    test cl, cl
    jz .finish
    xor rcx, rcx             ;; Zero out our counter.

.find_char:
    mov r10b, byte [rdi]     ;; Rest if we reached end of base string ('\0').
    test r10b, r10b
    jz .finish
    mov al, byte [rsi]       ;; Test if our str found an index in the base.
    test al, al
    jz .not_found
    cmp al, r10b
    je .found
    add rdi, 1
    add rcx, 1
    jmp .find_char

.found:
    imul r9, r11            ;; Multiply our accumulator * base_length.
    add r9, rcx             ;; Adds the base index to our accumulator.
    add rsi, 1
    mov rdi, r8             ;; Restore the base to continue the loop.
    jmp .outer_loop

.not_found:
    test r10b, r10b
    jz .finish
    add rsi, 1
    jmp .find_char

.finish:
    imul r9, rdx            ;; Multiply our accumulator * sign.
    mov rax, r9             ;; Move it to the RAX register.
    ret

.error:
    xor rax, rax             ;; Zero out the RAX register on error.
    ret
