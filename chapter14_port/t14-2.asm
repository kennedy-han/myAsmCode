;用加法和移位指令 计算 ax=ax*10
;提示：ax*10 = ax*2 + ax*8
assume cs:code

code segment

      start:mov ax,2    ;用于计算结果 2*10
            shl ax,1  ;ax*2

            mov bx,ax
            mov cl,3
            shl bx,cl ;ax*8
            add ax,bx

            mov ax,4c00h
            int 21h

code ends

end start
