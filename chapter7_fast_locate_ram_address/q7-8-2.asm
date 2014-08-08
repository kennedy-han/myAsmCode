assume cs:codesg, ds:datasg, ss:stacksg

;将datasg段中每个单词改为大写字母
;使用内存栈暂存cx
datasg segment
        db 'ibm             '
        db 'dec             '
        db 'dos             '
        db 'vax             '
datasg ends

stacksg segment     ;定义一个段，用来做栈段，容量为16个字节
        dw 0,0,0,0,0,0,0,0
stacksg ends

codesg segment

  start:  mov ax,datasg
          mov ds,ax

          mov ax,stacksg
          mov ss,ax
          mov sp,16

          mov bx,0

          mov cx,4
    s:    mov si,0
          push cx       ;将外层循环的cx值压栈
          mov cx,3      ;设置内层循环次数
        
      s0: mov al,[bx+si]
          and al,11011111B
          mov [bx+si],al
          inc si
      loop s0
      add bx,16
      pop cx            ;从栈顶弹出原cx的值，恢复cx
    loop s              ;外层循环的loop指令将cx中的计数值减1

	mov ax,4c00h
	int 21h

codesg ends
end start
