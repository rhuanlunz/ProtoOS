; Compare if strings are equal
; %1 = str1
; %2 = str2
; return:
;   equal -> ax = 1
;   not equal -> ax = 0
%macro StrCompare 2
    pusha

    mov si, %1 ; str1
    mov di, %2 ; str2

    StrCompare.repeat:
        mov al, [si]
        mov bl, [di]
        
        cmp al, bl
        jne StrCompare.notequal

        cmp al, 00h
        je StrCompare.equal

        inc si
        inc di

        jmp StrCompare.repeat


    StrCompare.notequal:
        mov ax, 00h
        jmp StrCompare.end
    
    StrCompare.equal:
        mov ax, 01h
    
    StrCompare.end:
    
    popa
%endmacro
