;编写并安装int 7ch 中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处
;参数：(dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址
assume cs:codesg

codesg segment

        ;安装中断例程
  start:mov ax,cs
        mov ds,ax
        mov si,offset show

        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset showend - offset show
        cld
        rep movsb

        ;修改中断向量表
        mov ax,0
        mov es,ax
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0

        mov ax,4c00h
        int 21h

   show:push dx
        push si
        push es
        push ax

        mov di,0    ;设置写入显存
      s:mov ax,0b800h
        mov es,ax
        cmp byte ptr [si],0
        je ok

        mov bx,dx
        mov ax,160
        mul bh
        mov bx,ax
        mov dl,[si]   ;使用dl暂存要显示的数据
        mov byte ptr es:[bx+di],dl
        mov byte ptr es:[bx+di+1],cl
        inc si
        add di,2
        jmp short s

     ok:pop ax
        pop es
        pop si
        pop dx
        iret

showend:nop

codesg ends

end start
