exitOutputCmd db "Bye bye :( ...", 00h

Program.exit:
    push exitOutputCmd
    call PrintString
    add sp, 02h

    cli
    hlt