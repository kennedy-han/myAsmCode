;编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串‘welcome to masm!’
assume ds:datasg,cs:codesg

datasg segment
  db 'welcome to masm!'
datasg ends

codesg segment

  start:  mov ax,datasg
          mov ds,ax
          
          mov ax,0B800h ;指向显存
          mov es,ax

          ;定位到11行 11*160=6E0h
          mov si,0
          mov cx,16 ;循环16个字符

          mov di,6E0h
      s:  mov al,[si]  ;拿到每一个字符
          mov es:[di+40h],al  ;写入显存
          mov es:[di+0A0h+40h],al ;下一行
          mov es:[di+0A0h+0A0h+40h],al
          
          inc di
          mov byte ptr es:[di+40h],02h  ;配置颜色
          mov byte ptr es:[di+0A0h+40h],24h
          mov byte ptr es:[di+0A0h+0A0h+40h],71h
          inc si
          inc di
      loop s

          mov ax,4c00h
          int 21h
codesg ends

end start
