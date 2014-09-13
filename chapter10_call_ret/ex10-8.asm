;计算 100 * 10
;100 和 10 小于255 可以做8位乘法
assume cs:codesg

codesg segment

  start:mov al,100
        mov bl,10
        mul bl
        mov ax,4c00h
        int 21h
codesg ends

end start
