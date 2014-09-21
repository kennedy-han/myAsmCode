;编写一个子程序，将包含任意字符，以0结尾的字符串中的小写字母转变成大写字母

assume cs:codesg

data segment
  db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

;用于展示
;printseg segment
;  db 48 dup (0)
;printseg ends

codesg segment

  start:mov ax,data
        mov ds,ax
        ;mov ax,printseg
        ;mov es,ax
        mov si,0
        mov di,0

        call letterc

        mov ax,4c00h
        int 21h

        ;名称：letterc
        ;功能：将以0结尾的字符串中的小写字母转换成大写字母
        ;参数：ds:si指向字符串首地址
letterc:pushf
        push di
        push si

      s:mov al,[si]
        cmp al,0    ;判断为不为0，若为0直接跳出
        je shut   ;zf=1 为0
        cmp al,97   ;97为小写a
        jb s0   ;如果al >= 97 则进入下一步判断，否则继续循环
        cmp al,122  ;122为小写z
        ja s0   ;如果al <= 122 则转换，否则继续循环
        and al,11011111B ;转化为大写
        mov [si],al
        ;mov es:[di],al  ;写入展示数据段
     s0:inc si
        inc di
        loop s

   shut:pop si
        pop di
        popf
        ret

codesg ends

end start
