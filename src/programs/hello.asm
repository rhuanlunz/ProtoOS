helloOutputCmd db "Hello, Kernel!", 00h

Program.hello:
    push helloOutputCmd
    call PrintString
    add sp, 02h
    ret