global _start
SECTION .text

_start:
    mov rbx, 0

loop:
# divide
    xor rdx, rdx ; set every byte in rdx to 0
    mov rax, rbx ; set rax to the counter
    mov rcx, 10 ; set the divisor to 10
    div rcx ; divide

# first digit
    add rax, 48
    mov [msg], byte al

# second digit
    add rdx, 48
    mov [msg+1], byte dl

# print
    mov rax, 1 ; make a sys_write call
    mov rdi, 1 ; make call to stdout
    mov rsi, msg
    mov rdx, 3 
    syscall

# loop
    inc rbx
    cmp rbx, 100
    jl loop

exit:
    mov rax, 60 ; make a sys_exit call
    mov rdi, 0
    syscall

SECTION .data

msg: db "00", 10