;;;;;;;;;;;;;;;
;CHAR PRINTING;
;;;;;;;;;;;;;;;
print:
    pusha          ; create a stack, this will save the register

printLoop:
    ;mov al, [si]  ; point the first value of si to ah (first char)
    lodsb          ; loading each byte from si into al
                   ; this is equivlant to: (mov al, [si]; inc si)
    
    cmp al, 0      ; check if al is a NULL char
    jne printChar  ; if it is then break the loop, if it isnt then print the char
    popa           ; pop the stack, returns the register to its original state
    ret            ; return to the calling point

printChar:
    mov ah, 0x0E   ; teletype mode
    int 0x10       ; CPU interupt
    ;inc si        ; increment si (next char)
    jmp printLoop  ; continue the loop

newLine:
    mov si, NL
    call print
    ret
NL: db 0xA, 0xD, 0
;;;;;;;;;;;;;;
;HEX PRINTING;
;;;;;;;;;;;;;;
printHex:
    pusha
    mov cx, 0      ; cx will be a counter

hexLoop:
    cmp cx, 4      ; check if cx is 4, end of loop
    je endHexLoop

    mov ax, dx
    and ax, 0x000F ; turns the first 3 bits into 0 and leaves the last one (example: 0x1234 -> 0x0004)
                   ; i could have used shr (shift) but this is easier
    add al, 0x30   ; get ascii number or letter value
    cmp al, 0x39   ; this will check if the hex value is 0 to 9, if it isnt then its between A to F
    jle movToBX
    add al, 0x7    ; get ascii A to F

movToBX:
    mov si, HEXOUTPUT + 5 ; HEXOUTPUT + string size
    sub si, cx     ; - cx
    mov [si], al   ; give si the current output
    ror dx, 4      ; rotates the value of dx (example: 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234)

    inc cx         ; loop for next hex digit in dx
    jmp hexLoop

endHexLoop:
    mov si, HEXOUTPUT
    call print     ; print the hex

    popa
    ret
;;;;;;;;;;;;;;;;;;;;
;PRINTING REGISTERS;
;;;;;;;;;;;;;;;;;;;;

HEXOUTPUT: db '0x0000', 0
