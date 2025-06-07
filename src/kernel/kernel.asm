[org 7e00h:0000h]
[bits 16]

jmp Kernel.Setup


%include "./src/drivers/video.inc"
%include "./src/drivers/keyboard.inc"
%include "./src/shell/input.asm"
%include "./src/shell/comands.asm"


; 80x25 16 color text (CGA,EGA,MCGA,VGA) mode
%define VIDEO_MODE      03h
%define ENDL            0ah

Kernel.Data:
    kernelMessage1 db "> Welcome to ProtoOS", 00h
    kernelMessage2 db "- Type 'help' to list all commands available", 00h
    shellString    db "kernel>", 00h


Kernel.Setup:
    ; Clear all registers
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    xor si, si
    xor di, di

    ; Set video mode
    push VIDEO_MODE
    call SetVideoMode
    add sp, 02h
    
    jmp Kernel.Intro

    
Kernel.Intro:
    push kernelMessage1
    call PrintString
    add sp, 02h
    call AddNewLine

    push kernelMessage2
    call PrintString
    add sp, 02h
    call AddNewLine
   
    jmp Kernel.Main


Kernel.Main:    
    push shellString
    call PrintString
    add sp, 02h
    
    call Shell.ReadCommand
    call Shell.ExecuteCommand

    xor di, di
    jmp Kernel.Main