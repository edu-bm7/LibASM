;; typedef struct s_list
;; {
;;   void          *data;
;;   struct s_list *next;
;; } t_list;
;; void
;; ft_list_remove_if (t_list **begin, void *data_ref, int (*cmp) (),
;;                    void (*free_fct) (void *))
;; {
;;   t_list **link = begin;
;;   while (*link)
;;     {
;;       t_list *node = *link;
;;       if (!cmp (node->data, data_ref))
;;         {
;;           *link = node->next;
;;           free_fct (node->data);
;;           free (node);
;;         }
;;       else
;;         {
;;           link = &node->next;
;;         }
;;     }
;; }
global ft_list_remove_if
extern free

section .text
ft_list_remove_if:
    ;; Here we just iterate throughout the whole list looking for a match between
    ;; data_ref and *begin_list->data, in C we used a pointer-to-pointer to make it easier
    ;; to delete and move around the Single-linked-list
    push  rbp
    mov   rbp, rsp
    push  rbx
    push  r12
    push  r13
    push  r14
    push  r15
    mov   r15, rsi      ;; save our data_ref so it doesn't get clobbered
    xor   r14, r14      ;; our t_list *node pointer
    mov   r12, rdi      ;; t_list **link = begin
    mov   rbx, rdx      ;; save our cmp() function into a callee-saved register
    mov   r13, rcx      ;; save our free_fct into a callee-saved register

.loop:
    mov   r14, [r12]
    test  r14, r14
    jz    .end
    mov   rdi, [r14]     ;; t_list *node = *link
    mov   rsi, r15
    call  rbx
    jz    .delete_node
    lea   r12, [r14+8]     ;; link = &node->next
    jmp   .loop

.delete_node:
    mov   r10, [r14+8]
    mov   [r12], r10
    mov   rdi, [r14]
    call  r13
    mov   rdi, r14
    call  free wrt ..plt
    jmp   .loop

.end:
    pop   r14
    pop   r13
    pop   r12
    pop   rbx
    pop   rbp
    ret




;; vim: sts=2 sw=2 et 

