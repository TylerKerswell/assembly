global _start
SECTION .text

_start:
    mov rax, 1 ; make a sys_write call
    mov rdi, 1 ; make call to stdout
    mov rsi, msg
    mov rdx, [len]
    syscall
    mov rax, 60 ; make a sys_exit call
    mov rdi, 0
    syscall

SECTION .data

msg: db "Hello, world!!", 10
len: db 0x0f