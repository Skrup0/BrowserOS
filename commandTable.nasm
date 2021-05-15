db '{clear:05,printRegisters:06,reboot:07,shutdown:08}'

times 512-($-$$) db 0 ; fill the sector to 512 bytes
