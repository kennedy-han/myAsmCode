;计算data 段中第一组数据的3次方，结果保存在后面一组dword 单元中
assume cs:codesg

data segment
  dw 1,2,3,4,5,6,7,8
  dd 0,0,0,0,0,0,0,0
data ends

codesg segment

  start:mov ax,data
        mov ds,ax
        mov cx,8
        mov si,0
        mov di,16
        
      s:mov bx,[si]
        call cube
        mov word ptr [di],ax
        mov word ptr [di+2],dx
        add si,2
        add di,4
        loop s

        mov ax,4c00h
        int 21h

   ;说明： 计算N的3次方
   ;参数： (bx)=N 
   ;结果： (dx:ax)=N^3
   cube:mov ax,bx
        mul bx
        mul bx
        ret

codesg ends

end start
