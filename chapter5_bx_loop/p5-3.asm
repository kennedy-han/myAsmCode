assume cs:codesg
	
codesg segment
	mov ax,0ffffh
	mov ds,ax
	
	mov ax,0
	mov dx,0
	
	mov bx,0006
	mov ah,0
	
	mov cx,3
	mov al,[bx]
	s: add dx,ax
	loop s
	
	mov ax,4c00h
	int 21h

codesg ends

end
