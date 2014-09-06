;利用jcxz指令，实现在内存 2000H 段中查找第一个值为0 的字节，找到后，将它的便宜地址存储在dx中
assume cs:codesg

codesg segment
  start:  mov ax,2000h
          mov ds,ax
          mov bx,0

      s:  mov cx, [bx]
          jcxz ok
          add bx, 2


          jmp short s

     ok:  mov dx,bx
          mov ax,4c00h
          int 21h

codesg ends

end start
