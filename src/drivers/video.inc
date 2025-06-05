; Set video mode
; 1 = mode
%macro SetVideoMode 1
    pusha

    mov al, %1

    xor ah, ah      ; Set video mode
    int 10h

    popa
%endmacro

; Set cursor position
; 1 = row
; 2 = column
%macro SetCursorPosition 2
    pusha

    mov dh, %1      ; Row
    mov dl, %2      ; Column

    mov ah, 02h     ; Set cursor position
    xor bh, bh      ; Page number
    int 10h

    popa
%endmacro

; Print string with delay in specific position
; 1 = string
; 2 = microseconds
; 3 = row
; 4 = col
%macro PutsWithDelay 4
    pusha

    SetCursorPosition %3, %4

    push %2    ; microseconds
    push %1    ; string
    call _puts_with_delay
    
    add sp, 04h
    
    popa
%endmacro

_puts_with_delay:
    mov bp, sp

    mov si, [bp + 2]    ; string
    mov cx, [bp + 4]    ; microseconds

    .print:
        mov ah, 0eh
        lodsb       ; load byte from si to al
        int 10h

        mov ah, 86h ; Elapsed Time Wait
        int 15h

        or al, al   ; verify if al is null
        jnz .print
    ret

; Print char in specific position
; 1 = char
; 2 = row
; 3 = col
%macro Putchar 3
    pusha

    SetCursorPosition %2, %3
    
    mov al, %1  ; char
    
    mov ah, 0eh
    int 10h

    popa
%endmacro