;; void ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *));
;; typedef struct s_list
;; {
;;   void          *data;
;;   struct s_list *next;
;; } t_list;
global ft_list_sort

section .text
    ;; Here we are dealing with function pointers as arguments.
    ;; There isn't nothing much complicated with them as is in high-level languages
    ;; they are just pointers that can be move to registers and be called direct
    ;; or inderectly.
    ;; t_list **begin_list is our RDI, int (*cmp)() is our RSI, cmp is our function
    ;; that will do the comparison between  2 data members so we can sort it accordingly.
    ;; Since this won't be a leaf function we need to use our prologue and epilogue.
    ;; We need to use callee-saved register so our registers don't get clobbered
    ;; by the function call
ft_list_sort:
    ;; Function Prologue
    push  rbp
    mov   rbp, rsp
    push  rbx         ;; our cmp function pointer
    push  r12         ;; our sorted pointer 
    push  r13         ;; our curr pointer
    push  r14         ;; our next pointer
    push  r15         ;; our prev pointer
    push  rdi         ;; save the state of rdi
    mov   rbx, rsi    ;; load our cmp function into rbx
    mov   r13, [rdi]  ;; curr pointer
    xor   r12, r12    ;; our sorted pointer

.loop:
    test  r13, r13      ;; curr == NULL ?
    jz    .end
    mov   r14, [r13+8]  ;; next = curr->next
    test  r12, r12      ;; sorted == NULL ?
    jz    .insert_head
    mov   r15, r12      ;; prev = sorted

.compare_data_values:
    mov   r10, [r15+8]  ;; load the next pointer into a register
    test  r10, r10      ;; prev->next == NULL ?
    jz    .splice
    mov   rdi, [r10]    ;; load prev->next into rdi so we can call cmp function
    mov   rsi, [r13]    ;; load curr into rsi so we can call cmp function
    call  rbx           ;; call cmp (void *, void *)
    test  rax, rax
    js    .walk_prev
    jmp   .splice

.insert_head:
    mov   [r13+8], r12  ;; curr->next = sorted = null
    mov   r12, r13      ;; sorted = curr
    mov   r13, r14      ;; curr = next
    jmp   .loop

.walk_prev:
    mov   r10, [r15+8]
    mov   r15, r10         ;; prev = prev->next
    jmp   .compare_data_values

.splice:
    mov   r10, [r15+8]
    mov   [r13+8], r10     ;; curr->next = prev->next
    mov   [r15+8], r13     ;; prev->next = curr
    mov   r13, r14         ;; curr = next
    jmp   .loop

.end:
    pop   rdi             ;; restore rdi so we can return in the original list
    mov   [rdi], r12
    pop   rbx             ;; restore all calee-saved registers
    pop   r15
    pop   r14
    pop   r13
    pop   r12
    pop   rbp
    ret
;; vim: sts=2 sw=2 et 



