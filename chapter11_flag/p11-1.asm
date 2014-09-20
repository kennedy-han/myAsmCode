;编程，计算 1EF000H + 201000H 结果放在 ax(高16位)和bx(低16位)中
assume cs:codesg

codesg segment

  start:mov ax,001eH
        mov bx,0f000H
        add bx,1000H
        adc ax,0020H

        mov ax,4c00h
        int 21h

codesg ends

end start
