helpOutputCmd   db "help        - list available commands", 0ffh
                db "clear       - clear terminal screen", 0ffh
                db "hello       - say 'hello' to kernel", 0ffh
                db "xorfract    - Render XOR Fractal on screen", 0ffh
                db "exit        - finish kernel", 00h

Program.help:
    call AddNewLine
    mov si, helpOutputCmd

    Program.help.loop:
        lodsb
        call Putchar
        
        cmp al, 0ffh
        jne Program.help.loop.end
    
        call AddNewLine

        Program.help.loop.end:
            or al, al
            jnz Program.help.loop
    call AddNewLine

    ret