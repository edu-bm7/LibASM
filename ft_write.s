;; https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl
global ft_write
extern __errno_location
;; Number of the `sys_write` system call outside of data because is constant
;; And we'll never change it.
SYS_WRITE equ 1

section .text
;; ssize_t write(int fd, const void buf[count], size_t count);
;; For a system call the RAX register is the number of that syscall
;; The RDI, RSI, RDX, R10, R8, R9 are the arguments of that function in order RDI -> R9
ft_write:
    mov rax, SYS_WRITE
    syscall
    cmp rax, 0
    jl .error 
    ret

.error:
    ;; Linux system call conventions return a negative errno by convention
    ;; So we negate into a positive value it first
    neg rax,
    ;; we store our errno into EDI register to call the __errno_location
    ;; and store the address of our errno variable
    mov edi, eax
    ;; The needs of wrt ..plt has to do with the PIE(Position independent executable)
    ;; when __errno_location absolute address isn't known at link time, so we load it
    ;; into the Procedure Linkage Table (PLT) and the dynamic linker will patch it up for us
    ;; We call it at the PLT stub, otherwise we won't be able to compile our code with -fPIE
    ;; flags(only working with -no-pie!)
    call __errno_location wrt ..plt
    ;; RAX now have our C Library errno address (int *)
    ;; We then save it into the variable in memory *(__errno_location()) = errno
    mov [rax], edi
    mov rax, -1 ;; our return value
    ret
