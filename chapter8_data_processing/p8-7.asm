assume cs:codesg

;利用除法指令计算 1001/100
codesg segment

  start:  mov ax,1001
          mov bl,100
          div bl

	mov ax,4c00h
	int 21h

codesg ends
end start
