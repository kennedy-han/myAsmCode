;中断例程
;分析：
;1.编写实现求平方功能的程序
;2.安装程序，将其安装在0:200处
;3.设置中断向量表，将程序的入口地址保存在7ch表项中，使其成为中断7ch的中断例程
assume cs:codesg

codesg segment

        ;安装程序
  start:mov ax,cs
        mov ds,ax
        mov si,offset sqr

        mov ax,0
        mov es,ax
        mov di,0200h

        mov cx,offset sqrend - offset sqr   ;设置cx为传输长度
        cld   ;正向
        rep movsb

        ;设置中断向量
        mov ax,0
        mov es,ax
        mov word ptr es:[7ch*4],0200h
        mov word ptr es:[7ch*4+2],0

        mov ax,4c00h
        int 21h

    sqr:mul ax
        iret

 sqrend:nop

codesg ends

end start
