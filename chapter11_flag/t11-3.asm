;编程，统计data段中数值 大小在[32,128]的数据的个数，用dx保存统计结果

assume cs:codesg

data segment
  db 8,11,8,1,8,5,63,32
data ends

codesg segment

  start:mov ax,data
        mov ds,ax

        mov bx,0
        mov ax,0
        mov cx,8

      s:mov al,[bx]
        cmp al,32
        jb s0
        cmp al,128
        ja s0
        inc dx
     s0:inc bx
        loop s

        mov ax,4c00h
        int 21h

codesg ends

end start
