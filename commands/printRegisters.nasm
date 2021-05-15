printRegisters:
    mov si, registerName
    mov word [registerName+2], 'DI'
    call print
    call printHex

    mov word [registerName+2], 'SI'
    call print
    mov dx, si
    call printHex

    mov word [registerName+2], 'AX'
    call print
    mov dx, ax
    call printHex

    mov word [registerName+2], 'BX'
    call print
    mov dx, bx
    call printHex

    mov word [registerName+2], 'CX'
    call print
    mov dx, cx
    call printHex

    mov word [registerName+2], 'CS'
    call print
    mov dx, cs
    call printHex

    mov word [registerName+2], 'DS'
    call print
    mov dx, ds
    call printHex

    mov word [registerName+2], 'ES'
    call print
    mov dx, es
    call printHex
    call newLine

backToKernel:
    mov bx, 0x2000
    mov es, bx
    mov bx, 0x0000
    
    mov ax, 0x2000
    mov ds, ax   ; reseting these registers that we used
    mov es, ax   ; if they dont get reset then ur gonna get garbage values
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    jmp 0x2000:0x0000

%include 'print.nasm'

registerName: db 0xA, 0xD, 'DI:    ', 0
times 512-($-$$) db 0 ; fill the sector to 512 bytes
