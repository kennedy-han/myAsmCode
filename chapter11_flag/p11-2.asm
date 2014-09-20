;编程，计算 1EF0001000H + 2010001EF0H 结果放在 ax(高16位)和bx(次高16位)和cx(低16位)中
;分3步
;1先将低16位相加，完成后，CF中记录本次相加的进位值
;2再将次高16位和CF（来自低16位的进位值）相加，完成后，CF记录本次进位值
;3最后高16位和CF（来自次高）相加，完成后，CF记录本次进位值
assume cs:codesg

codesg segment

  start:mov ax,001eH
        mov bx,0f000H
        mov cx,1000H
        
        add cx,1ef0H
        adc bx,1000H
        adc ax,0020H

        mov ax,4c00h
        int 21h

codesg ends

end start
