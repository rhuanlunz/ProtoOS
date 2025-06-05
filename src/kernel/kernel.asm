[org 7e00h:0000h]
[bits 16]

jmp kernel_setup


%include "./src/drivers/video.inc"
%include "./src/drivers/keyboard.inc"
%include "./src/utils/string.inc"

%define BACKSPACE       08h
%define ENTER           0dh
%define COLUMN_BEGIN    09h
%define BUFFSIZE        50h
%define ENDL            0ah

data:
    kernel_message_1    db " > Welcome to ProtoOS", 00h
    kernel_message_2    db " - Type 'help' to list all commands available", 00h

    shell_string        db " kernel> ", 00h

    cmd_buffer          times BUFFSIZE db 00h
    help_cmd            db "help", 00h
    not_found           db " Command not found!", 00h

    help_message        db "Listing commands", ENDL, 00h
                        ; db "help    - list available commands", ENDL
                        ; db "hello   - say 'hello!'", 00h


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
    
    PutsWithDelay shell_string, 00h, dh, 00h    ; Print shell string
    SetCursorPosition dh, dl
    
    call get_command
    call execute_command

    jmp kernel_main
    

; Get keys and put in cmd_buffer
get_command:
    ReadKeyboard

    cmp al, BACKSPACE
    je get_command.backspace
    cmp al, ENTER
    je get_command.enter

    ; Verify if si not overflow buffsize
    cmp si, BUFFSIZE
    jge get_command

    Putchar al, dh, dl          ; Write key in screen
    inc dl                      ; Increment x cursor position

    mov [cmd_buffer + si], al   ; Save key in cmd_buffer
    inc si                      ; Go to next memory location in cmd_buffer

    jmp get_command

    get_command.backspace:
        cmp dl, COLUMN_BEGIN
        je get_command
        
        dec dl
        dec si
        
        Putchar ' ', dh, dl
        SetCursorPosition dh, dl

        jmp get_command

    get_command.enter:
        inc dh
        mov dl, COLUMN_BEGIN
        
        mov [cmd_buffer + si], byte 00h  ; Null terminator

        SetCursorPosition dh, dl
        
    ret

execute_command:
    StrCompare cmd_buffer, help_cmd
    jz execute_command.help
    
    jmp execute_command.not_found
    
    execute_command.help:
        PutsWithDelay help_message, 00h, dh, 00h
        jmp execute_command.end

    execute_command.not_found:
        PutsWithDelay not_found, 00h, dh, 00h
        jmp execute_command.end

    execute_command.end:
        inc dh
        SetCursorPosition dh, dl

    ret