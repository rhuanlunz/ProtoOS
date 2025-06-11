%include "./src/utils/string.inc"
%include "./src/programs/help.asm"
%include "./src/programs/clear.asm"
%include "./src/programs/hello.asm"
%include "./src/programs/exit.asm"

helpCmd     db "help", 00h
clearCmd    db "clear", 00h
helloCmd    db "hello", 00h
exitCmd     db "exit", 00h
notFound    db "Command not found!", 00h

Shell.ExecuteCommand:
    push si
    push di

    mov si, keyboardBuffer
    
    mov di, helpCmd
    call StrCompare
    jz Shell.ExecuteCommand.help
    
    mov di, clearCmd
    call StrCompare
    jz Shell.ExecuteCommand.clear

    mov di, helloCmd
    call StrCompare
    jz Shell.ExecuteCommand.hello

    mov di, xorfractCmd
    call StrCompare
    jz Shell.ExecuteCommand.xorfract

    mov di, exitCmd
    call StrCompare
    jz Shell.ExecuteCommand.exit

    jmp Shell.ExecuteCommand.notFound
    
    Shell.ExecuteCommand.help:
        call Program.help
        
        jmp Shell.ExecuteCommand.end

    Shell.ExecuteCommand.clear:
        call Program.clear
        
        jmp Shell.ExecuteCommand.end

    Shell.ExecuteCommand.hello:
        call Program.hello

        jmp Shell.ExecuteCommand.end

    Shell.ExecuteCommand.notFound:
        push notFound
        call PrintString
        add sp, 02h

        jmp Shell.ExecuteCommand.end

    Shell.ExecuteCommand.exit:
        call Program.exit

    Shell.ExecuteCommand.end:
        call AddNewLine

    pop di
    pop si
    ret