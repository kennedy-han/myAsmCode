;编程，安装一个新的int 7ch中断例程，实现通过逻辑扇区号对软盘进行读写
assume cs:code

code segment

      ;参数说明：
      ;1.用ah寄存器传递功能号：0表示读，1表示写；
      ;2.用dx寄存器传递要读写的扇区的逻辑扇区号
      ;3.用es:bx指向存储读出数据或写入数据的内存区
        rwf:jmp short rwf
            table dw read,write    ;定址表
   rwfstart:push ax
            push bx
            push cx
            push dx

            ;验证ah和dx的合法性
            cmp ah,1
            ja rwfret
            cmp dx,2879
            ja rwfret

            mov ax,dx
            mov dx,0
            mov bx,1440
            div bx    ;逻辑扇区的值/1440=int()面号
            push ax   ;int()面号暂存

            mov ax,dx
            mov dx,0
            mov bx,18
            div bx    ;int(rem(Logic/1440))/18) 磁道号，issue：需要做32位除法

            mov ch,al ;磁道号=int((rem(Logic/1440))/18)=(ax)
            mov cl,dl 
            add cl,1  ;扇区号=rem((rem(Logic/1440))/18)+1 = (dx)+1
            pop bx    ;取出面号
            mov dh,bl

            ;根据功能号执行相应地子程序
            mov bl,ah
            mov bh,0
            add bx,bx
            call word ptr table[bx]

       read:mov ah,2  ;读扇区
            mov dl,0  ;软驱
            mov al,1  ;读取的扇区数
            int 13h
            jmp short rwfret

      write:mov ah,3  ;写扇区
            mov dl,0  ;软驱
            mov al,1
            int 13h
            jmp short rwfret

     rwfret:pop dx
            pop cx
            pop bx
            pop ax

     rwfend:nop

            ;安装到0:200处
      start:mov ax,0
            mov es,ax
            mov di,200h

            mov ax,cs
            mov ds,ax
            mov si,offset rwf
            mov cx,offset rwfend - offset rwf
            cld
            rep movsb

            ;设置中断向量表
            mov ax,0
            mov es,ax
            mov word ptr es:[7ch*4],200h
            mov word ptr es:[7ch*4+2],0

            mov ax,4c00h
            int 21h

code ends

end start
