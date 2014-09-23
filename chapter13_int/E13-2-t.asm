;问题：用7ch中断例程完成loop指令的功能
;应用举例：在屏幕中间显示80个'!'
assume cs:codesg

codesg segment

  start:mov ax,0b800h
        mov es,ax
        mov di,160*12

        mov bx,offset s-offset se   ;设置从标号se到标号s的转移位移
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;mov bx,offset se-offset s   ;两种方式都可以实现
        mov cx,80
      s:mov byte ptr es:[di],'!'
        add di,2
        int 7ch   ;如果cx不等于0，转移到标号s处
     se:nop

        mov ax,4c00h
        int 21h

codesg ends

end start
