;问题二：编写、安装中断7ch的中断例程
;功能：将一个全是字母，以0结尾的字符串，转化为大写
;参数：ds:si指向字符串的首地址
;应用举例：将data段中的字符串转化为大写
assume cs:codesg

data segment
  db 'conversation',0
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov si,0
        int 7ch

        mov ax,4c00h
        int 21h

codesg ends

end start
