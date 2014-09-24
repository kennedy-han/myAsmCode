;编程：以"年/月/日/ 时:分:秒"的格式，显示当前的日期、时间
assume cs:code

;定义CMOS RAM时间
timesg segment
  db 9,8,7,4,2,0,'/','/',' ',':',':'
timesg ends

code segment

      start:mov ax,timesg
            mov ds,ax
            mov bp,0  ;用来定位到timesg
            mov di,6  ;从第ds:di个开始是分隔符
            mov si,0  ;显卡显示间距

            mov cx,6
          s:push cx
            mov al,ds:[bp]
            out 70h,al
            in  al,71h    ;读取时间

            mov ah,al
            mov cl,4
            shr ah,cl   ;去除十位中的低位
            and al,00001111b    ;去除个位中的高位

            add ah,30h
            add al,30h  ;用于显示的ascii

            mov bx,0b800h
            mov es,bx
            mov byte ptr es:[160*12+40+si],ah  ;显示月份的十位
            mov byte ptr es:[160*12+40+si+2],al  ;月份个位
            mov dl,[di]
            mov byte ptr es:[160*12+40+si+2+2],dl  ;分隔符

            inc di
            add si,6  ;显示间距
            inc bp
            pop cx
            loop s

            mov ax,4c00h
            int 21h

code ends

end start
