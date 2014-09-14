;在屏幕的8行3列，用绿色显示data段中的字符串
assume cs:codesg

data segment
  db 'Welcome to masm!',0
data ends

codesg segment

  start:mov dh,8
        mov dl,3
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0
        call show_str

        mov ax,4c00h
        int 21h

   ;说明： 在指定的位置用指定的颜色，显示一个用0结束的字符串
   ;参数： dh = 行号(取值范围0-24),dl=列号(取值范围0-79)
   ;       cl = 颜色，ds:si指向字符串的首地址
   ;结果： 没有返回值
show_str:push ax
        push bx
        push cx
        push dx
        push es
        push di
        push si

        mov ah,0
        mov al,160
        mul dh ;计算行
        mov di,ax   ;dl保存行
        mov ah,0
        mov al,2
        mul dl ;计算列
        mov bx,ax   ;bx保存列

        mov ax,0B800h
        mov es,ax

        mov dl,cl ;dl保存颜色
        mov ch,0
   show:mov cl,[si]
        jcxz ok
        mov byte ptr es:[di+bx],cl  ;字符
        mov byte ptr es:[di+bx+1],dl  ;颜色
        inc si
        add bx,2
        jmp short show
      
     ok:pop si
        pop di
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        ret

codesg ends

end start
