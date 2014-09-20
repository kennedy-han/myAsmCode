;对两个128位数据进行相加

assume cs:codesg

codesg segment

  start:

        mov ax,4c00h
        int 21h

  ;名称：add128
  ;功能：两个128位数据进行相加
  ;参数：ds:si指向存储第一个输的内存空间，因数据位为128位，所以需要8个字单元，由低地址单元到高地址单元依次存放128位数据由低到高。运算结果存储在第一个数的存储空间中。
  ;ds:di指向存储第二个数的空间
  add128: push ax
          push bx
          push si
          push di

          sub ax,ax   ;将CF设置为0

          mov cx,8
      s:  mov ax,[si]
          adc ax,[di]
          mov [si],ax
          inc si    ;不能使用add si,2 因为会修改CF
          inc si
          inc di
          inc di
          loop s

          pop di
          pop si
          pop bx
          pop ax
          ret

codesg ends

end start
