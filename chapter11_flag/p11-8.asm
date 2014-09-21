;编程，用串传送指令，将data段中的第一个字符串复制到它后面的空间中
;分析：
;传送的原始位置：ds:si : data:0
;传送的目标位置：es:di : data:0010
;传送的长度: cx : 16
;传送的方向：df : 因为正向传送（每次串传送指令执行后，si和di递增）比较方便，所以设置df = 0

assume cs:codesg

data segment
  db 'Welcome to masm!'
  db 16 dup (0)
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov es,ax
        mov si,0    ;ds:si 指向data:0
        mov di,16   ;es:di 指向data:0010
        mov cx,16   ;rep 循环16次
        cld         ;设置df=0 正向传送

        rep movsb
        mov ax,4c00h
        int 21h

codesg ends

end start
