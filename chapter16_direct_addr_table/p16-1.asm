;编写子程序，以十六进制的形式在屏幕中间显示给定的字节型数据
assume cs:code

code segment

      start:mov al,'a'
            call showbyte

            mov ax,4c00h
            int 21h

  ;用al传送要显示的数据
   showbyte:jmp short show
            table db '0123456789ABCDEF'   ;字符表
       show:push bx
            push es

            mov ah,al
            shr ah,1
            shr ah,1
            shr ah,1
            shr ah,1    ;右移4位，ah得到高4位的值
            and al,00001111b    ;al中为低4位的值

            mov bl,ah
            mov bh,0
            mov ah,table[bx]    ;用高4位的值作为相对于table的偏移，取得对应的字符

            mov bx,0b800H
            mov es,bx
            mov es:[160*12+40*2],ah

            mov bl,al
            mov bh,0
            mov al,table[bx]    ;用低4位作为table偏移，取得对应字符

            mov es:[160*12+40*2+2],al

            pop es
            pop bx
            ret
code ends

end start
