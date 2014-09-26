;编写包含多个功能子程序的中断例程
;安装一个新的int 7ch中断例程，为显示输出提供如下功能子程序
;1.清屏
;2.设置前景色
;3.设置背景色
;4.向上滚动一行
;
;入口参数说明：
;用ah寄存器传递功能号，0表示清屏
;对于1、2号功能，用al传递颜色值，al属于{0,1,2,3,4,5,6,7}
assume cs:code

code segment

        ;子程序入口地址存储在一个表中，对应关系：功能号*2=对应的功能子程序在地址表中的偏移
  subbegin:jmp short set
           table dw sub1+200h,sub2+200h,sub3+200h,sub4+200h ;程序整体放在了0:200处，所以存放table内容的实际地址是200H+table

       set:push bx

           cmp ah,3   ;判断功能号是否大于3
           ja sret
           mov bl,ah
           mov bh,0
           add bx,bx    ;根据ah中的功能号计算对应子程序在table表中的偏移
           add bx,200h
           call word ptr table[bx]   ;调用对应的功能子程序

      sret:pop bx
           iret

        ;清屏子程序
       sub1:push bx
            push cx
            push es
            mov bx,0b800h
            mov es,bx
            mov bx,0
            mov cx,2000
      sub1s:mov byte ptr es:[bx],' '
            add bx,2
            loop sub1s
            pop es
            pop cx
            pop bx
            ret

        ;设置前景色
       sub2:push bx
            push cx
            push es

            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
      sub2s:and byte ptr es:[bx],11111000b
            or es:[bx],al
            add bx,2
            loop sub2s

            pop es
            pop cx
            pop bx
            ret

        ;设置前景色
       sub3:push bx
            push cx
            push es
            mov cl,4
            shl al,cl
            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
      sub3s:and byte ptr es:[bx],10001111b
            or es:[bx],al
            add bx,2
            loop sub3s
            pop es
            pop cx
            pop bx
            ret

        ;向上滚动一行
      sub4:push cx
           push si
           push di
           push es
           push ds

           mov si,0b800h
           mov es,si
           mov ds,si
           mov si,160   ;ds:si指向第n+1行
           mov di,0
           cld
           mov cx,24    ;共复制24行

     sub4s:push cx
           mov cx,160
           rep movsb    ;复制
           pop cx
           loop sub4s

          ;清空最后一行
           mov cx,80
           mov si,0
    sub4s1:mov byte ptr [160*24+si],' '
           add si,2
           loop sub4s1

           pop ds
           pop es
           pop di
           pop si
           pop cx
           ret

    subend:nop

            ;安装到0:200处
      start:mov ax,0
            mov es,ax
            mov di,200h

            mov ax,cs
            mov ds,ax
            mov si,offset subbegin
            mov cx,offset subend - offset subbegin
            cld
            rep movsb

            ;设置中断向量表
            mov ax,0
            mov es,ax
            mov word ptr es:[7ch*4],200h
            mov word ptr es:[7ch*4+2],0

            ;测试中断例程
            mov ah,2
            mov al,101
            int 7ch

            mov ax,4c00h
            int 21h

code ends
end start
