assume cs:codesg

codesg segment

  start:mov ax,1000
        mov bx,1
        div bl

        mov ax,4c00h
        int 21h

codesg ends

end start
