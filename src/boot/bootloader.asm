[org 7c00h]
[bits 16]

setup:
    cli

    ; Setup data and extra segment
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Setup stack segment and stack pointer
    mov ax, 0050h
    mov ss, ax
    mov sp, 7bffh

    sti

load_kernel:
    mov ah, 02h    ; Read Disk Sectors function
    mov al, 05h    ; Number of sectors to read
    mov ch, 00h    ; Track/Cylinder number
    mov cl, 02h    ; Sector number
    mov dh, 00h    ; Head number
    mov dl, 00h    ; Drive number

    ; loading kernel in 7e00h:0000h (ES:BX) -> Physical Address = (Segment * 16) + Offset
    mov bx, 7e0h
    mov es, bx
    xor bx, bx

    int 13h

    jc error_disk        ; jmp if carry flag is set (CF = 1)

    jmp 7e00h

error_disk:
    lea si, error_disk_msg
    call print

halt:
    cli
    hlt

; load string offset in si register
print:
    mov ah, 0eh
    xor bh, bh
    mov bl, 0fh

    .loop:
        lodsb       ; load byte from si to al
        int 10h
        or al, al   ; verify if al is null
        jnz .loop
    ret

error_disk_msg db "Disk error!", 00h

times 510-($-$$) db 00h
dw 0AA55h