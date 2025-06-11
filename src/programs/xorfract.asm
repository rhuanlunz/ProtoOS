%define ESCAPE  1bh

; 25
%define ROWS    19h

; 80
%define COLUMNS 50h 

Program.xorfract:
    push ax
    push cx
    push dx

Program.xorfract.begin:
    xor cx, cx
    xor dx, dx

    Program.xorfract.rows:
        Program.xorfract.columns:
            mov ax, cx          ; Save cx(column) value in ax

            xor ax, dx          ; Computate (x XOR y)

            mov ah, 0ch         ; Write graphics pixel at coordinate
            xor bh, bh          ; Page number
            mov al, 7
            int 10h

            inc cx              ; Increment column
            
            cmp cx, COLUMNS
            jle Program.xorfract.columns
        
        inc dx
        cmp dx, ROWS
        jle Program.xorfract.rows

    call ReadKeyboard
    cmp al, ESCAPE
    je Program.xorfract.end

    jmp Program.xorfract.begin

Program.xorfract.end:
    pop dx
    pop cx
    pop ax
    ret