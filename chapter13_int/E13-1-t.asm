;测试中断例程
;
;编写并安装int 7ch 中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处
;参数：(dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址
assume cs:codesg

data segment
  db 'Welcome to masm!',0
data ends

codesg segment

  start:mov dh,10
        mov dl,10
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0

        int 7ch

        mov ax,4c00h
        int 21h

codesg ends

end start
