;用7ch中断例程完成jmp near ptr s指令的功能，用bx向中断例程传送转移位移
;应用举例：在屏幕的第12行，显示data段中以0结尾的字符串
assume cs:codesg

data segment
  db 'conversation',0
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov si,0

        mov ax,0b800h
        mov es,ax
        mov di,12*160

      s:cmp byte ptr [si],0
        je ok
        mov al,[si]
        mov es:[di],al
        mov byte ptr es:[di+1],01110010b   ;绿色
        inc si
        add di,2
        mov bx,offset s-offset ok   ;设置从标号ok到标号s的转移位移
        int 7ch   ;如果cx不等于0，转移到标号s处
     ok:mov ax,4c00h
        int 21h

codesg ends

end start
