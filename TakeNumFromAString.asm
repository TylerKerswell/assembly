; this is a program that will take a number from an inputted ascii character string that is 8 bytes long
global _start

SECTION .data

startmsg: db "Enter a number: "

SECTION .bss

    num resb 8

SECTION .text

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, startmsg
    mov rdx, 16
    syscall

    mov r11, 0
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 8
    syscall


    mov rax, qword [num]
    call intfromstr

    mov rdi, 0
    mov rax, 60
    syscall




; this function will take a string and convert that string into a number 
; takes an 8 byte string in the rax register and returns an int in the rax register
intfromstr:

    ; prologue to preserve registers
    push rcx
    push rbx 
    push rdx 
    push rsi 

    mov rcx, 0 ; counter
    mov rbx, rax ; inital string on bytes (because mul deletes rax)
    mov rdx, 0 ; mul deletes this one so we need to preserve it
    mov rsi, 0 ; finished number

    .started: ; this is where everything happens
        inc rcx

        cmp rcx, 8 ; check if finished
        jg .end

        cmp bl, 0x30 ; check if the next char is less than any number character 
        jl .rem

        cmp bl, 0x39 ; check if the next char is greater than any number character 
        jg .rem

        sub bl, 48 ; convert from ascii character to int

        mov rax, 10 ; multiply the current number that we have by 10
        mul rsi
        mov rsi, rax

        add sil, bl ; put this number into the first column in the number that we have
        shr rbx, 8 ; move on to the next number

        jmp .started ; go back to start
        

        .rem: ; remove the next character for when it isn't a number character
            shr rbx, 8
            jmp .started

    .end:
    
    mov rax, rsi ; put the finished number in rax to be handed back

    ; epilogue to preserve registers
    pop rsi
    pop rdx
    pop rbx
    pop rcx

    ; return to the caller
    ret