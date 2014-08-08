assume cs:codesg, ds:datasg

;将datasg段中每个单词改为大写字母
datasg segment
        db 'ibm             '
        db 'dec             '
        db 'dos             '
        db 'vax             '
datasg ends

codesg segment

  start:  mov ax,datasg
          mov ds,ax

          mov bx,0

          mov cx,4
    s:    mov si,0
          mov dx,cx     ;将外层循环的cx保存在dx中
          mov cx,3      ;设置内层循环次数
        
      s0: mov al,[bx+si]
          and al,11011111B
          mov [bx+si],al
          inc si
      loop s0
      add bx,16
      mov cx,dx         ;用dx中存放的外层循环计数值恢复cx
    loop s              ;外层循环的loop指令将cx中的计数值减1

	mov ax,4c00h
	int 21h

codesg ends
end start
