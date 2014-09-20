;编程，统计data段中数值为8的字符的个数，用ax保存统计结果

assume cs:codesg

data segment
  db 8,11,8,1,8,5,63,38
data ends

codesg segment

  start:mov ax,data
        mov ds,ax

        mov bx,0
        mov ax,0
        mov cx,8

        ;与8做比较
      s:cmp byte ptr [bx],8
        jne next
        inc ax
   next:inc bx
        loop s

        mov ax,4c00h
        int 21h

codesg ends

end start
