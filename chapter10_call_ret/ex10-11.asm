;编程 将data 段中的字符串转换为大写
assume cs:codesg

data segment
  db 'conversation'
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov cx,12 ;字符串长度
        mov si,0
        
        call capital

        mov ax,4c00h
        int 21h

   ;说明： 修改ds指向段中的数据为大写
   ;参数： ds  
   ;结果： 直接覆盖
capital:and byte ptr [si],11011111b ;将ds:si 所指单元中的字母转化为大写
        inc si
        loop capital
        ret

codesg ends

end start
