;; https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
section .data
    SYS_READ equ 0

;; ssize_t read (int fd, void *buf, size_t count);
section .text


