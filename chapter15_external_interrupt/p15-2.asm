;在DOS下，按F1键后改变当前屏幕的显示颜色，其他的键照常处理
assume cs:code

stack segment
  db 128 dup (0)
stack ends

code segment

      start:mov ax,stack
            mov ss,ax
            mov sp,128

            push cs
            pop ds

            ;安装到 0:204h
            mov ax,0
            mov es,ax
            mov di,204h   ;es:di指向目的地址
            mov si,offset int9    ;ds:si 指向源地址
            mov cx,offset int9end - offset int9 ;设置长度
            cld   ;正向
            rep movsb

            ;将原来的int 9中断例程的入口地址保存在0:200h、0:202h单元中
            push es:[9*4]
            pop es:[200h]
            push es:[9*4+2]
            pop es:[202h]

            cli   ;设置IF=0不响应可屏蔽中断
            ;在中断向量表中设置新的int 9中断例程的入口地址
            mov word ptr es:[9*4],204h
            mov word ptr es:[9*4+2],0
            sti   ;IF=1响应可屏蔽中断

            mov ax,4c00h
            int 21h

    ;----------以下为新的int 9中断例程-----------;
     int9:  push ax
            push bx
            push cx
            push es

            in al,60h   ;从60h端口读取键盘输入

            pushf
            call dword ptr cs:[200h] ;对int指令进行模拟，调用原来的int 9中断例程

            cmp al,3bh    ;F1扫描码为3b
            jne int9ret   ;不是F1则返回

            mov ax,0b800h
            mov es,ax
            mov bx,1
            mov cx,2000
        s:  inc byte ptr es:[bx]    ;将属性值加1，改变颜色
            add bx,2
            loop s

  int9ret:  pop es
            pop cx
            pop bx
            pop ax
            iret

  int9end:  nop

code ends

end start
