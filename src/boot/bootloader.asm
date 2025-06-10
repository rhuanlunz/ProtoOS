[org 7c00h]
[bits 16]

Setup:
    cli

    mov [driveNumber], dl ; Save Drive number

    ; Setup data and extra segment
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Setup stack segment, base and stack pointer
    mov ss, ax
    mov bp, 7c00h
    mov sp, bp

    sti

LoadKernel:
    mov ah, 02h             ; Read Disk Sectors function
    mov al, 05h             ; Number of sectors to read
    mov ch, 00h             ; Track/Cylinder number
    mov cl, 02h             ; Sector number
    mov dh, 00h             ; Head number
    mov dl, [driveNumber]   ; Drive number

    ; loading kernel in 0000h:7e00h (ES:BX) -> Physical Address = (Segment * 16) + Offset
    xor bx, bx
    mov es, bx
    mov bx, 7e00h

    int 13h

    jc DiskError        ; jmp if carry flag is set (CF = 1)

    jmp 7e00h

DiskError:
    lea si, errorDiskMsg
    call Print
    cli
    hlt

Print:
    mov ah, 0eh
    xor bh, bh
    mov bl, 0fh

    .loop:
        lodsb       ; load byte from si to al
        int 10h
        or al, al   ; verify if al is null
        jnz .loop
    ret

errorDiskMsg    db "Disk error!", 00h
driveNumber     db 00h

times 510-($-$$) db 00h
dw 0AA55h