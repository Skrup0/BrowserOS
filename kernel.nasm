; Skippy's epic kernel
; compile with: make install

start:
    mov ah, 0x00 ; start video mode
    mov al, 0x03 ; change text size
    int 0x10

    mov ah, 0x0B ; change color
    mov bh, 0x00
    mov bl, 0x00 ; 0=black, 1=blue, 2=green, 3=cyan
    int 0x10

    ;mov si, msg
    ;call print
    ;mov dx, 0x1234
    ;call printHex

    jmp getInput

    call haltCPU   ; end program, anything under this point is the data section

haltCPU:
    hlt ; halts the CPU
    jmp haltCPU

; input stuff
getInput:
    mov byte [di], 0  ; clear di
    mov byte [commandLen], 0
    mov di, command ; point di to command
    mov si, PS1     ; print out the PS1
    call print
    jmp inputLoop   ; start the input loop

inputLoop:
    mov ah, 0x0     ; get keystrokes
    int 0x16        ; CPU interupt for keystrokes
    mov ah, 0x0E    ; teletype mode
    cmp al, 0xD     ; check if enter is pressed
    je cmdSearch
    ;je execCMD      ; if it is then execute the command
    inc byte [commandLen]
    int 0x10        ; otherwise interupt the cpu and print the character
    mov [di], al    ; move the character to di
    inc di          ; add byte
    jmp inputLoop

;; COMMAND SEARCH & COMPARATION
cmdSearch:
    mov di, command      ; move the value of command into di
    
    cmp byte [di], ':'
    je cmdNotFound

    xor cx, cx
    mov ax, 0x1000       ; load command table from memory 0x1000:0x000
    mov es, ax
    xor bx, bx

cmdLoopStarter:
    mov al, [ES:BX]      ; move the command table into al
    cmp al, '}'          ; check if at command table ended
    je cmdNotFound

    cmp al, [di]         ; check if the current al char = to the first command char
    je cmdCmpLoop

    inc bx               ; get next char in command table
    jmp cmdLoopStarter

cmdCmpLoop:
    mov al, [ES:BX]
    
    cmp al, ':'
    je cmdCheckIfFound

    cmp al, [di]
    jne cmdRestartLoop

    inc cx
    inc di
    inc bx
    jmp cmdCmpLoop

cmdRestartLoop:
    mov di, command
    inc bx
    xor cx, cx
    jmp cmdLoopStarter

cmdCheckIfFound:
    cmp cx, [commandLen]
    jne cmdRestartLoop

cmdFound:
    mov cl, 10
    xor al, al
    jmp getCMDSector

cmdNotFound:
    call newLine
    mov si, CMD_ERROR
    call print
    jmp getInput

getCMDSector:
    inc bx
    mov dl, [ES:BX]
    cmp dl, ','
    je loadCMD
    cmp dl, '}'
    je loadCMD

    mul cl     ; al = al * cl
    sub dl, 48 ; ascii -> int
    add al, dl
 
    jmp getCMDSector

loadCMD:
    mov cl, al
    mov ch, 0x0  ; cylinder
    mov dh, 0x0  ; head
    mov dl, 0x0  ; 0 = load drive

    mov bx, 0x8000 ; load sector to memory address 0x8000
    mov es, bx     ; es = bx = 0x8000
    mov bx, 0x0    ; es:bx = 0x8000:0x0

    mov ah, 0x02 ; 0x02 is for BIOS reading only, 0x03 is for writing
    mov al, 0x01
    
    int 0x13
    jnc loadCMDLoop
    
    jmp getInput

loadCMDLoop:
    mov ax, 0x8000
    mov ds, ax   ; reseting these registers that we used
    mov es, ax   ; if they dont get reset then ur gonna get garbage values
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x8000:0x0000

printCommand:
    call newLine
    mov si, msg
    call print
    jmp getInput

clear:
    mov ah, 0x0
    mov al, 0x2
    int 0x10
    jmp getInput

%include 'print.nasm'

PS1: db "BrowserOS:~$ ", 0

msg: db "Welcome to BrowserOS", 0xA, 0xD, 0
CMD_ERROR: db "Command not found.", 0xA, 0xD, 0
CMD_FOUND: db "Command found!", 0xA, 0xD, 0
command: db '                             ', 0
commandLen: db 0

times (512*2)-($-$$) db 0 ; fill the sector to 512*2 bytes
