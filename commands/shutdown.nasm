; from: https://wiki.osdev.org/Shutdown 
mov ax, 0x1000
mov ax, ss
mov sp, 0xF000
mov ax, 0x5307
mov bx, 0x0001
mov cx, 0x0003
int 0x15

times 512-($-$$) db 0 ; fill the sector to 512 bytes
