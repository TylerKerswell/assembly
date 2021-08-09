; This program will perform the caesar cipher with a key input and a message input

global _start

SECTION .data

    startmsg: db "Enter key: " ; messages for the program
    midmsg: db "Enter your message: " 

SECTION .bss

    key: resb 8 ; the users key
    message: resb 512 ; the users message

SECTION .text

_start:

    ; print the start message to the screen to ask for the key
    mov rax, 1 
    mov rdi, 1
    mov rsi, startmsg
    mov rdx, 11
    syscall

    ; take the input of the key
    mov rax, 0
    mov rdi, 0
    mov rsi, key
    mov rdx, 8
    syscall

    ; convert the string key into an integer we can use to perform the shift
    mov rax, qword [key]
    call intfromstr
    mov qword [key], rax
    
    ; print the message asking for the users message
    mov rax, 1
    mov rdi, 1
    mov rsi, midmsg
    mov rdx, 20
    syscall

    ; get the users message (max 512 bytes but that should be enough)
    mov rax, 0
    mov rdi, 0
    mov rsi, message
    mov rdx, 512
    syscall

    ; setup going into the loop
    mov r8, qword [key] ; make r8 the key
    mov rcx, 0 ; counter so we know how many bytes to print at the end
    mov rsi, message ; rsi will be the pointer to the message
    dec rsi ; dec to counter inc when first enter loop
    mov [message+511], 0 ; make the last byte null just in case the user used all 512 bytes

    .loopstart:
        inc rcx ; increment the counter
        inc rsi ; point the pointer to the next byte that we should work on
        mov rbx, 0 ; we will use rbx as temporary storage for the byte we are working on

        mov bl, byte [rsi] ; move the byte we are working on into rbx
        
        ; end the loop if the byte is a null byte (end of string)
        cmp bl, 0
        je .loopend

        ; we will keep uppercase letters and lowercase letters the same
        .uppercase:
            ; check if it is an uppercase letter (using ascii)
            cmp bl, 65
            jl .loopstart

            cmp bl, 90
            jg .lowercase
            
            ; if it is, turn it in to a number that it corrisponds with on the alphabet
            sub bl, 65

            ; then add the key
            add rbx, r8

            ; divide the letter so each letter can loop around from z to a
            mov rax, rbx
            mov rbx, 26
            mov rdx, 0

            div rbx
            
            ; take the remainder, make it an uppercase letter again and put it back to where it was
            add rdx, 65
            mov byte [rsi], dl

            ; repeat
            jmp .loopstart

        .lowercase:
            ; check if it is a lowercase letter (using ascii)
            cmp bl, 97
            jl .loopstart

            cmp bl, 122
            jg .loopstart

            ; if it is, do the same thing we did with the uppercase letters except translate them to numbers and back again differently
            sub rbx, 97

            add rbx, r8

            mov rax, rbx
            mov rbx, 26
            mov rdx, 0

            div rbx
            
            add rdx, 97
            mov byte [rsi], dl

            jmp .loopstart

    .loopend:
    
    ; now, print the final result of the caesar cipher
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, rcx
    syscall

    ; and then exit the program
    mov rax, 60
    mov rdi, 0
    syscall

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