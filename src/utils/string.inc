; Compare if strings are equal
; si = str1
; di = str2
; return:
;   equal -> ax = 1
;   not equal -> ax = 0
StrCompare:
    pusha

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
        jmp StrCompare.end
    
    StrCompare.equal:
    
    StrCompare.end:
    
    popa
    ret