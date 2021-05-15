jmp 0xFFFF:0x0000 ; jump to the reset procedure in the CPU
times 512-($-$$) db 0 ; fill the sector to 512 bytes
