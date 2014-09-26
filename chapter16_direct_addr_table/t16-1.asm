;将code段中的 a处的8个数据累加，结果存储到 b处的双字中
assume cs:code

code segment

            a dw 1,2,3,4,5,6,7,8
            b dd 0

      start:mov si,0
            mov cx,8

          s:mov ax,a[si]
            add word ptr b,ax
            adc word ptr b,0
            add si,2
            loop s

            mov ax,4c00h
            int 21h

code ends

end start
