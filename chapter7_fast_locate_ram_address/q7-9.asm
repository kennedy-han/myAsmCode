assume cs:codesg, ds:datasg, ss:stacksg

;将datasg段中每个单词的前4个字母改为大写字母
stacksg segment
        dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
        db '1. display      '
        db '2. brows        '
        db '3. replace      '
        db '4. modify       '
datasg ends

codesg segment

  start:  mov ax,datasg
          mov ds,ax

          mov ax,stacksg
          mov ss,ax
          mov sp,16

          mov bx,0

          mov cx,4
    s:    mov si,0
          push cx
          mov cx,4      ;设置内层循环次数
        
      s0: mov al,[3+bx+si]
          and al,11011111B
          mov [3+bx+si],al
          inc si
      loop s0
      add bx,16
      pop cx
    loop s              ;外层循环的loop指令将cx中的计数值减1

	mov ax,4c00h
	int 21h

codesg ends
end start
