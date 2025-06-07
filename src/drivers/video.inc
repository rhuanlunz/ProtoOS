; Set video mode
; [bp + 2] = mode
SetVideoMode:
    mov bp, sp

    mov al, [bp + 2]    ; Video mode
    mov ah, 00h         ; Set video mode
    int 10h
    ret


; Set cursor position on screen
; dh = row
; dl = column
SetCursorPosition:
    mov ah, 02h         ; Set cursor position
    xor bh, bh          ; Page number
    int 10h
    ret


; Get current cursor position
GetCursorpostion:
    mov ah, 03h         ; Read cursor position
    xor bh, bh          ; Page number
    int 10h
    ret


; Add new line
AddNewLine:
    mov ah, 03h         ; Read cursor position
    xor bh, bh          ; Page number
    int 10h
    
    inc dh              ; Increment row
    xor dl, dl          ; Column 0
    mov ah, 02h         ; Set cursor position
    int 10h
    ret


; Print char on screen
; al = ascii char
Putchar:
    mov ah, 0eh
    int 10h
    ret


; Print string on screen
; [bp + 2] = string
PrintString:
    mov bp, sp

    mov si, [bp + 2]
    mov ah, 0eh
    PrintString.loop:
        lodsb
        int 10h
        or al, al
        jnz PrintString.loop
    ret