;中断例程
;模拟loop指令
;参数：cx=循环次数，bx=位移
assume cs:codesg

codesg segment

        ;安装程序
  start:mov ax,cs
        mov ds,ax
        mov si,offset lp

        mov ax,0
        mov es,ax
        mov di,0200h

        mov cx,offset lpretend- offset lp   ;设置cx为传输长度
        cld   ;正向
        rep movsb

        ;设置中断向量
        mov ax,0
        mov es,ax
        mov word ptr es:[7ch*4],0200h
        mov word ptr es:[7ch*4+2],0

        mov ax,4c00h
        int 21h

        ;中断程序
     lp:push bp
        mov bp,sp
        dec cx
        jcxz lpret
        add [bp+2],bx
        ;;;;;;;;;;;;;;;sub [bp+2],bx   ;两种方式都可实现
  lpret:pop bp
        iret

lpretend:nop

codesg ends

end start
