assume cs:code

a segment
      db 1,2,3,4,5,6,7,8
a ends

b segment
      db 1,2,3,4,5,6,7,8
b ends

c segment
      db 0,0,0,0,0,0,0,0
c ends

code segment

  start:mov ax,a
        mov ds,ax
        
        mov ax,0
        mov bx,0
        mov cx,8
      s:add ax,[bx] ;使用ax做计算
        add ax,[bx+16]
        mov [bx+32],ax
        inc bx
        mov ax,0
      loop s

	mov ax,4c00h
	int 21h

code ends

end start
