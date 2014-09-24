;从CMOS RAM的8号单元读出当前月份的BCD码
;分析：
;1.从CMOS RAM的8号单元读出当前月份的BCD码
;2.将用BCD码表示的月份以十进制的形式显示到屏幕上
assume cs:code

code segment

      start:mov al,8
            out 70h,al
            in  al,71h    ;读取月份

            mov ah,al
            mov cl,4
            shr ah,cl   ;去除十位中的低位
            and al,00001111b    ;去除个位中的高位

            add ah,30h
            add al,30h  ;用于显示的ascii

            mov bx,0b800h
            mov es,bx
            mov byte ptr es:[160*12+40*2],ah  ;显示月份的十位
            mov byte ptr es:[160*12+40*2+2],al  ;月份个位

            mov ax,4c00h
            int 21h

code ends

end start
