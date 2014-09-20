;编程实现如下功能
;如果(ah)=(bh) 则 (ah)=(ah)+(ah)，否则(ah)=(ah)+(ch)

assume cs:codesg

codesg segment

  start:cmp ah,bh
        je s
        add ah,ch
        jmp short ok
      s:add ah,ah

     ok:mov ax,4c00h
        int 21h

codesg ends

end start
