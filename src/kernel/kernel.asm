[org 7e00h:0000h]
[bits 16]


; Print string with delay on screen
; 1: string
; 2: microseconds
%macro print 2
    pusha

    mov si, %1
    mov cx, %2

    .loop:
        mov ah, 0eh
        lodsb       ; load byte from si to al
        int 10h

        mov ah, 86h
        int 15h

        or al, al   ; verify if al is null
        jnz .loop

    popa
%endmacro

set_video_mode:
    xor ah, ah      ; Set video mode
    mov al, 03h     ; 80x25 16 color text mode
    int 10h

set_cursor_position:
    mov ah, 02h     ; Set cursor position
    xor bh, bh      ; Page number
    mov dh, 0ch     ; Row
    mov dl, 1bh     ; Column
    int 10h

kernel_main:
    print kernel_message, 01h
    
    cli
    hlt


kernel_message db "> Welcome to ProtoOS", 00h