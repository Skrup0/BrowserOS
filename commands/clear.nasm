mov ah, 0x0
mov al, 0x2
int 0x10

; back to kernel
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

times 512-($-$$) db 0 ; fill the sector to 512 bytes
