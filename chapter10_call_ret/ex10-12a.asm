;将一个全是字母，以0结尾的字符串，转化为大写
assume cs:codesg

data segment
  db 'conversation',0
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov si,0
        
        call capital

        mov ax,4c00h
        int 21h

   ;说明： 将一个全是字母，以0结尾的字符串，转化为大写
   ;参数： ds:si  指向字符串的首地址
   ;结果： 没有返回值
capital:mov ch,0
        mov cl,[si]
        jcxz ok
        and byte ptr [si],11011111b ;将ds:si 所指单元中的字母转化为大写
        inc si
        jmp short capital
      
     ok:ret

codesg ends

end start
