; Read character from keyboard
; return ascii in AL register
ReadKeyboard:
    mov ah, 00h
    int 16h
    ret