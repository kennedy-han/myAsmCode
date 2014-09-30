;编程，将当前屏幕的内容保存在磁盘上
;分析：1屏的内容占4000个字节，需要8个扇区，用0面0道德1-8扇区存储显存中的内容
assume cs:code

code segment

      start:mov ax,0b800
            mov es,ax
            mov bx,0

            mov al,8
            mov ch,0
            mov cl,1
            mov dl,0
            mov dh,0
            mov ah,3
            int 13h

            mov ax,4c00h
            int 21h

code ends

end start
