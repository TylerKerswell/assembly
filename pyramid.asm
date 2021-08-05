; the goal of this program is to make a pyramid with a height of whatever the user inputs
; we need to get user input, convert input to a number, and print the pyramid

global _start

; define some constants
SECTION .data
startmsg: db "Height: "
hash: db 35
space: db 32
newline: db 10

; reserve some space for out varibles
SECTION .bss
    height resb 16
    num resb 8
    i resb 8
    len resb 8
    count resb 8
    comp resb 8

SECTION .text

_start:
; first, we are going to ask the user for the height
    mov rax, 1
    mov rdi, 1
    mov rsi, startmsg
    mov rdx, 8
    syscall

; then, get the height input from the user
    mov rax, 0
    mov rdi, 0
    mov rsi, height
    mov rdx, 16
    syscall

; now, we get the lenght of the users input and store it in len
   mov rbx, height
.length:
    cmp [rbx], byte 10
    je .lengthend
    inc rbx
    inc qword [len]
    jmp .length
.lengthend:


; translate the characters from the users input into a number
    mov byte [num], 0
    mov qword [i], 0

.numget:
    inc qword [i] ; 'i' will be the counter for this loop

    ; get the pointer to the right byte in height
    mov rbx, height
    add rbx, qword [i]
    dec rbx

    ; take the character in height and subtract 48 to get the actual number
    mov rcx, 0
    mov cl, byte [rbx]
    sub rcx, 48
    
    ; take the number and shift the decimal one place to the right and then put the current number in the 1's collumn
    mov rax, 10
    mul qword [num]
    mov qword [num], rax
    add qword [num], rcx

    ; continue until we reach the end of the input
    mov rdx, qword [i]
    cmp rdx, qword [len]
    jl .numget


; now all we need to do is print the pyramid
mov qword [i], 0

.heightloop:

    inc qword [i] ; we will reuse 'i' as the counter in this loop too
    
    ; we want to print i - height number of spaces
    mov qword [count], 0
    mov rdx, qword [num]
    sub rdx, qword [i]
    mov qword [comp], rdx

    ; loop to print the spaces (making sure we don't always print a space)
    .spaceloop:
        inc qword [count]
        mov rdx, qword [comp]
        cmp rdx, qword [count]
        jl .spaceloopend
        call printspace
        jmp .spaceloop
    .spaceloopend:

    ; the formula for the number of #'s we want to print is i x 2 - 1
    mov rax, 2
    mul qword [i]
    mov qword [comp], rax
    sub qword [comp], 1
    mov qword [count], 0

    ; print the hashtags (it's ok to always print 1)
    .hashloop:
        call printhash
        inc qword [count]
        mov rdx, qword [count]
        cmp rdx, qword [comp]
        jl .hashloop

    ; and finally we print the newline character at the end of each layer
    call printnl

    ; repeat everything for the height the user inputted
    mov rcx, qword [i]
    cmp rcx, qword [num]
    jl .heightloop


; now that the pyramid is printed we can close the program
    mov rax, 60
    mov rdi, 0
    syscall


; function for printint a newline character
printnl:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

; function for printing a hashtag
printhash:
    mov rax, 1
    mov rdi, 1
    mov rsi, hash
    mov rdx, 1
    syscall
    ret

; function for printing a space
printspace:
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    ret