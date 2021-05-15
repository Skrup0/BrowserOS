; skippy's epic bootsector (which includes a bootloader)
; compile with: make install

org 0x7C00 ; start from memory address 0x7C00
jmp short setupBootloader ; i dont know if this is necessary but whatever

setupBootloader:
    mov cl, 0x02 ; start reading sector number 2, which is the one next to the bootsector (0x01)
    mov ch, 0x0  ; cylinder
    mov dh, 0x0  ; head
    mov dl, 0x0  ; 0 = load drive
    mov ah, 0x02 ; 0x02 is for BIOS reading only, 0x03 is for writing

    mov bx, 0x1000 ; load sector to memory address 0x1000
    mov es, bx ; es = bx = 0x1000
    mov bx, 0x0 ; es:bx = 0x1000:0x0

bootloaderloop_FileTable:
    mov al, 0x01 ; how many sectors to load, rn loading 1 which is the filetable's
    int 0x13     ; CPU interupt for disk functions only

    jc bootloaderloop_FileTable ; the cf (carry flag) will be set to 1 if something fails to read
                                ; it will continue the loop and try to read it again and HOPEFULLY it fixes it
    
    ; setting up the registers for reading the kernel
    mov cl, 0x03 ; start reading sector number 3, the kernel's
    mov ch, 0x0  ; cylinder
    mov dh, 0x0  ; head
    mov dl, 0x0  ; 0 = load drive
    mov ah, 0x02 ; 0x02 is for BIOS reading only, 0x03 is for writing

    mov bx, 0x2000 ; load sector to memory address 0x2000
    mov es, bx ; es = bx = 0x2000
    mov bx, 0x0 ; es:bx = 0x2000:0x0

bootloaderloop_Kernel:
    mov al, 0x02 ; how many sectors to load, rn loading 2 which is the kernel's
    int 0x13     ; CPU interupt for disk functions only

    jc bootloaderloop_Kernel ; the cf (carry flag) will be set to 1 if something fails to read
                      ; it will continue the loop and try to read it again and HOPEFULLY it fixes it
    mov ax, 0x2000
    mov ds, ax   ; reseting these registers that we used
    mov es, ax   ; if they dont get reset then ur gonna get garbage values
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x2000:0x0 ; running the bootinit (exiting the boot sector)

times 510-($-$$) db 0
dw 0xAA55   ; boot sector, it must be 512 bits and end with 0xAA55
            ; u can also use: db 0x55, 0xAA
