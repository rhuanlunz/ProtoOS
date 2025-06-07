%define BACKSPACE       08h
%define ENTER           0dh
%define COLUMN_BEGIN    09h
%define BUFFSIZE        20h
    
keyboardBuffer times BUFFSIZE db 00h

; Get keys and put in keyboardBuffer
Shell.ReadCommand:
    call GetCursorpostion
    call ReadKeyboard

    ; Special chars
    cmp al, BACKSPACE
    je Shell.ReadCommand.backspace
    cmp al, ENTER
    je Shell.ReadCommand.enter

    ; Not overflow keyboardBuffer
    cmp di, BUFFSIZE
    jge Shell.ReadCommand

    mov [keyboardBuffer + di], al   ; Save char in keyboardBuffer
    inc di                          ; Go to next memory location in keyboardBuffer
    call Putchar                    ; Print char in screen

    jmp Shell.ReadCommand

    Shell.ReadCommand.backspace:
        cmp dl, COLUMN_BEGIN
        jl Shell.ReadCommand

        dec dl                  ; Decrement column
        call SetCursorPosition  ; Update cursor position

        mov ah, 0ah             ; Write Character Only at Current Cursor Position
        mov al, ' '             ; Write blank
        xor bh, bh              ; Display page
        int 10h

        dec di
    
        jmp Shell.ReadCommand

    Shell.ReadCommand.enter:
        mov [keyboardBuffer + di], byte 00h  ; Null terminator
        call AddNewLine
        
    ret
