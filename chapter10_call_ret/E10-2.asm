;计算 1000000 / 10 (F4240H / 0AH)
assume cs:codesg

codesg segment

  start:mov ax,4240h
        mov dx,000fh
        mov cx,0ah
        call divdw

        mov ax,4c00h
        int 21h

   ;说明： 进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
   ;参数： ax = dword 型数据的低16位
   ;       dx = dword 型数据的高16位
   ;       cx = 除数
   ;结果： dx = 结果的高16位，ax=结果的低16位
   ;       cx = 余数
  divdw:push bx
        mov bx,ax   ;ax送入bx存储
        mov ax,dx
        mov dx,0
        div cx  ;ax=商，dx=余数
        mov si,ax   ;商送入si存储
        mov ax,bx   ;恢复ax
        div cx  ;ax=最终结果的低位

        mov cx,dx   ;cx=最终结果的余数
        mov dx,si   ;dx=最终结果的商
        pop bx  ;恢复bx
        ret

codesg ends

end start
