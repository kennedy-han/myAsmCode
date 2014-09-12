;下面的程序执行后，ax中的数值为多少？
assume cs:codesg

codesg segment
  start:mov ax,0
        call s
        inc ax
      s:pop ax
codesg ends

end start
