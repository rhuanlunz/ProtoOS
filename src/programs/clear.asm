Program.clear:
    xor dh, dh
    xor dl, dl
    
    push 03h
    call SetVideoMode
    add sp, 02h
    
    call SetCursorPosition
    ret