;编程，在屏幕中间依次显示"a"~"z"，并可以让人看清。在显示过程中，按下ESC键后，改变显示的颜色
assume cs:code

stack segment
  db 128 dup (0)
stack ends

;用于保存BIOS int 9入口地址
data segment
  dw 0,0
data ends

code segment

      start:mov ax,stack
            mov ss,ax
            mov sp,128

            mov ax,data
            mov ds,ax

            mov ax,0
            mov es,ax

            ;将原来的int 9中断例程的入口地址保存在ds:0、ds:2单元中
            push es:[9*4]
            pop ds:[0]
            push es:[9*4+2]
            pop ds:[2]

            cli   ;设置IF=0不响应可屏蔽中断
            ;在中断向量表中设置新的int 9中断例程的入口地址
            mov word ptr es:[9*4],offset int9
            mov es:[9*4+2],cs
            sti   ;IF=1响应可屏蔽中断

            ;显示字符
            mov ax,0b800h
            mov es,ax
            mov ah,'a'    ;从'a'开始显示
        s:  mov es:[160*12+40*2],ah   ;屏幕中央显示
            call delay    ;延迟
            inc ah
            cmp ah,'z'    ;判断是否到z
            jna s     ;没到z则跳转到s

            ;将中断向量表中int 9中断例程的入口恢复为原来的地址
            mov ax,0
            mov es,ax
            push ds:[0]
            pop es:[9*4]
            push ds:[2]
            pop es:[9*4+2]

            mov ax,4c00h
            int 21h

            ;延迟子程序，用于CPU执行空循环
    delay:  push ax
            push dx
            mov dx,5h
            mov ax,0
       s1:  sub ax,1    ;产生溢出CF
            sbb dx,0    ;dx - 溢出位CF
            cmp ax,0
            jne s1
            cmp dx,0
            jne s1
            pop dx
            pop ax
            ret

    ;----------以下为新的int 9中断例程-----------;
     int9:  push ax
            push bx
            push es

            in al,60h   ;从60h端口读取键盘输入

            pushf
            call dword ptr ds:[0] ;对int指令进行模拟，调用原来的int 9中断例程

            cmp al,1    ;ESC扫描码为01
            jne int9ret   ;不是ESC则返回

            mov ax,0b800h
            mov es,ax
            inc byte ptr es:[160*12+40*2+1]    ;将属性值加1，改变颜色

  int9ret:  pop es
            pop bx
            pop ax
            iret

code ends

end start
