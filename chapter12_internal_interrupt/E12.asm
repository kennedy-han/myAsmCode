;编写 0号中断的处理程序

assume cs:codesg

codesg segment

  ;安装 使用movsb 将do0的代码送入 0:200处
  start:mov ax,cs
        mov ds,ax
        mov si,offset do0   ;设置ds:si指向源地址

        mov ax,0
        mov es,ax
        mov di,200H   ;es:di指向目标地址

        mov cx,offset do0end - do0;复制长度

        cld   ;传输方向正向
        rep movsb

        ;设置中断向量表
        ;除法溢出中断码为0，所以0:0字单元存放偏移地址，0:2字单元存放段地址
        ;修改 0:0 和 0:2 为 0:200
        mov ax,0
        mov es,ax
        mov word ptr es:[0*4],200h
        mov word ptr es:[0*4+2],0

        mov ax,4c00h
        int 21h


        ;名称：do0
        ;功能：除法溢出时，在屏幕中间显示字符串“divide error!”,然后返回dos
        ;参数：
        do0:jmp short do0start  ;从这里开始被复制
            db 'divide error!'   ;保存要显示的字符串

        ;真正的程序开始
do0start:mov ax,0
        mov ds,ax
        mov si,202h   ;设置ds:si指向字符串,jmp指令占2个字节，所以是200+2

        ;设置es:di指向显存空间的中间位置
        mov ax,0b800h
        mov es,ax
        mov di,12*160+36*2

      s:mov al,[si]
        mov es:[di],al
        mov byte ptr es:[di+1],11000010B;为了方便显示，添加字体颜色
        inc si
        add di,2    ;一个字符占2个字节
        loop s

        mov ax,4c00h  ;程序返回dos
        int 21h

  do0end:nop    ;结束标记，用于截取复制长度

codesg ends

end start
