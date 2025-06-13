;; https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
global ft_read
extern __errno_location

;; Our constants
SYS_READ equ 0
;; ssize_t read (int fd, void *buf, size_t count);
section .text
ft_read:
    mov rax, SYS_READ
    syscall
    cmp rax, 0
    jl .error
    ret

.error:
    ;; same procedure as ft_write.s
    neg rax
    mov edi, eax
    call __errno_location wrt ..plt
    mov [rax], edi
    mov rax, -1
    ret

