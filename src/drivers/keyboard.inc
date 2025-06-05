; Read character from keyboard
; return ascii in AL register
%macro ReadKeyboard 0
    mov ah, 00h
    int 16h
%endmacro