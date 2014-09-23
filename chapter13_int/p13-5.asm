;编程：在屏幕的5行 12列显示字符串'Welcome to masm!'
assume cs:codesg

data segment
  db 'Welcome to masm!','$'
data ends

codesg segment

  start:mov ah,2    ;置光标
        mov bh,0    ;第0页
        mov dh,5    ;ddh中放行号
        mov dl,12   ;dl中放列号
        int 10h

        mov ax,data
        mov ds,ax
        mov dx,0    ;ds:dx指向字符串的首地址 data:0
        mov ah,9    ;int 21h 功能号9
        int 21h

        mov ax,4c00h
        int 21h

codesg ends

end start
