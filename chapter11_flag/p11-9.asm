;编程，用串传送指令，将F000H段中的 最后 16个字符复制到data段中
;分析：
;传送的原始位置：ds:si : F000:FFFF
;传送的目标位置：es:di : data:0
;传送的长度: cx : 16
;传送的方向：df : 逆向传送 递减 df = 1

assume cs:codesg

data segment
  db 16 dup (0)
data ends

codesg segment

  start:mov ax,data
        mov es,ax
        mov ax,0F000H
        mov ds,ax
        mov si,0FFFFH   ;ds:si 指向F000:FFFF
        mov di,15   ;es:di 指向data:F
        mov cx,16   ;rep 循环16次
        std         ;设置df=1 逆向传送

        rep movsb
        mov ax,4c00h
        int 21h

codesg ends

end start
