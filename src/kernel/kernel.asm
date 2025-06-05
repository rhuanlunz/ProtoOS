[org 7e00h:0000h]
[bits 16]

jmp kernel_setup


%include "./src/drivers/video.inc"
%include "./src/drivers/keyboard.inc"

%define BACKSPACE       08h
%define ENTER           0dh
%define COLUMN_BEGIN    09h
%define BUFFSIZE        10h

data:
    kernel_message_1    db " > Welcome to ProtoOS", 00h
    kernel_message_2    db " - Type 'help' to list all commands available", 00h

    shell_string        db " kernel> ", 00h

    cmd_buffer          times BUFFSIZE db 00h


kernel_setup:
    SetVideoMode 03h
    jmp kernel_intro

    
kernel_intro:
    PutsWithDelay kernel_message_1, 00h, 00h, 00h
    PutsWithDelay kernel_message_2, 00h, 01h, 00h

    mov dh, 03h             ; Row
    mov dl, COLUMN_BEGIN    ; Column
   
    jmp kernel_main


kernel_main:
    xor si, si
    
    PutsWithDelay shell_string, 00h, dh, 00h
    SetCursorPosition dh, dl
    
    call get_input

    PutsWithDelay cmd_buffer, 00h, 10h, 00h
    
    jmp kernel_main
    

get_input:
    ReadKeyboard

    cmp al, BACKSPACE
    je .backspace
    cmp al, ENTER
    je .enter

    Putchar al, dh, dl
    inc dl

    mov [cmd_buffer + si], al
    inc si

    jmp get_input

    .backspace:
        cmp dl, COLUMN_BEGIN
        je get_input
        
        dec dl
        
        Putchar ' ', dh, dl
        SetCursorPosition dh, dl

        jmp get_input

    .enter:
        inc dh
        mov dl, COLUMN_BEGIN

        SetCursorPosition dh, dl
        
    ret