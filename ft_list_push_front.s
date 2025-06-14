;; void ft_list_push_front(t_list **begin_list, void *data);
;; typedef struct s_list
;; {
;;   void          *data;
;;   struct s_list *next;
;; } t_list;
global ft_list_push_front
extern __errno_location
extern malloc

section .text
    ;; RDI is our t_list **begin_list, RSI our void *data
    ;; We can assume the size of t_list by checking it's data fields
    ;; Field data 8 bytes(pointer) field next 8 bytes(pointer)
    ;; If there is no padding, we can assume that data lives at a 0x00 offset
    ;; And next at 0x08 offset, total size 16 bytes per node(our malloc size).
ft_list_push_front:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    mov [rbp-8], rdi ;; save begin_list so malloc doesn't clobber it
    mov [rbp-16], rsi ;; save the data so malloc doesn't clobber it
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz .error
    mov rdi, [rbp-8] ;; restore begin_list
    mov rsi, [rbp-16] ;; restore data
    mov [rax], rsi ;; move *(new_node) <- data (offset 0)
    mov rdx, [rdi] ;; load RDX <- *begin_list
    mov [rax+8], rdx ;; move *(new_node->next) <- *begin_list
    mov [rdi], rax ;; move *begin_list <- new_node
    add rsp, 24
    pop rbp
    ret

.error:
    mov edi, 12 ;; (ENOMEM)
    call __errno_location wrt ..plt
    mov [rax], edi
    xor rax, rax
    add rsp, 24
    pop rbp
    ret


