assume cs:codesg, ds:datasg, ss:stack

;结构体定义
;char year[4] // 年
; 空格(1 Byte)
;int income (4 Bytes)// 收入
; 空格
;empoyer num (2 Bytes) // 雇员数
; 空格
;人均收入 (2 Bytes)
; 空格

;编程，将data段中的数据按如下格式写入到table段中，并计算21年中的人均收入（取整）
datasg segment
  db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983', '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992', '1993', '1994', '1995'
  ;以上是表示21年的21个字符串

  dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
  dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
  ;21年公司总收入的21个dword型数据

  dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
  dw 11542, 14430, 15257, 17800
  ;21年公司雇员人数的21个word型数据
datasg ends

table segment
  db 21 dup ('year summ ne ?? ')
table ends

;定义栈用来暂存寄存器数据
stack segment
  dw 2 dup(0)
stack ends

codesg segment

  ;设置datasg
  start:mov ax,datasg
        mov ds,ax

        mov ax,table
        mov es,ax

        mov ax,stack
        mov ss,ax
        mov sp,16

        ;初始化
        mov bx,0
        mov dx,0
        mov si,0
        mov di,0

        mov cx,21 ;循环21次
      s:
        ;年4字节
        mov ax,[bx]
        mov es:[si+0],ax
        mov ax,[bx+2]
        mov es:[si+2],ax
        
        ;空格
        mov al,32
        mov es:[si+4],al

        ;收入4字节
        mov ax,[bx+84]
        mov es:[si+5],ax
        mov ax,[bx+86]
        mov es:[si+7],ax

        ;空格
        mov al,32
        mov es:[si+9],al

        ;雇员 2字节
        mov ax,[di+168]
        mov es:[si+0ah],ax

        ;空格
        mov al,32
        mov es:[si+0ch],al

        ;人均收入 2字节
        mov ax,ds:[bx+84]
        mov dx,ds:[bx+86]

        push cx             ;暂存cx
        mov cx,[di+168]
        div cx
        pop cx              ;恢复cx

        mov es:[si+0dh],ax

        ;空格
        mov al,32
        mov es:[si+0fh],al

        add bx,4
        add si,16
        add di,2

        loop s

	mov ax,4c00h
	int 21h

codesg ends
end start
