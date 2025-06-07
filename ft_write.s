section .data
    ;; https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
    ;; Number of the `sys_write` system call
    SYS_WRITE equ 1
section .text
    global ft_write

;; ssize_t write(int fd, const void buf[count], size_t count);
;; For a system call the RAX register is the number of that syscall
;; The RDI, RSI, RDX, R10, R8, R9 are the arguments of that function in order RDI -> R9
ft_write:
    mov rax, SYS_WRITE
    syscall
    jc .error ;; Carry Flag setted (error)
    ret

.error:
    xor rax, rax
    mov rax, -1
    ret
