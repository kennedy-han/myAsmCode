;计算 100 * 10000
;100 小于255 可10000 大于255 必须做16位乘法
assume cs:codesg

codesg segment

  start:mov ax,100
        mov bx,10000
        mul bx
        mov ax,4c00h
        int 21h
codesg ends

end start
