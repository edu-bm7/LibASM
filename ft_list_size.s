;; int ft_list_size(t_list *begin_list);
;; typedef struct s_list
;; {
;;   void          *data;
;;   struct s_list *next;
;; } t_list;
global ft_list_size

section .text
    ;; RDI is t_list *begin_list.
    ;; We can assume that the size of t_list struct is 16 bytes
    ;; void *data(pointer) 8 bytes + struct s_list *next(pointer) 8 bytes
    ;; No need to call extern functions, so we can
    ;; treat this function as a leaf funtion and adopt frame-pointer omission.
ft_list_size:
    xor rax, rax     ;; our counter/return value
.loop:
    test rdi, rdi
    jz .end
    add rax, 1
    mov rdi, [rdi+8]  ;; load our next variable -> list = list->next
    jmp .loop

.end:
    ret


