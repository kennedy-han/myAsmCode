assume cs:code

code segment
	mov cx,12
	mov bx,0

	s:mov ax,0ffffh
	mov ds,ax
	mov dl,[bx]

	mov ax,20h
	mov ds,ax
	mov [bx],dl

	inc bx
	loop s

	mov ax,4c00h
	int 21h

code ends
end
