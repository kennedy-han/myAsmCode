;编写子程序,计算sin(x),x属于[0度，30度，60度，90度，120度，150度，180度]
;并在屏幕中间显示计算结果。比如：sin(30)的结果显示为"0.5"

assume cs:code

code segment

      start:mov al,180
            call showsin

            mov ax,4c00h
            int 21h

    ;用ax向子程序传递角度
    showsin:jmp short show
            table dw ag0,ag30,ag60,ag90,ag120,ag150,ag180,errormsg   ;字符串偏移地址表
            ag0   db '0',0  ;sin(0)对应的字符串“0”
            ag30  db '0.5',0
            ag60  db '0.866',0
            ag90  db '1',0
            ag120 db '0.866',0
            ag150 db '0.5',0
            ag180 db '0',0
            errormsg db 'Input error or no result!',0  ;如果提供的角度不在[0,180]中，提示语

       show:push bx
            push es
            push si

            mov bx,0b800h
            mov es,bx

            ;以下角度值/30 作为相对于table的偏移，取得对应的字符串的偏移地址，放在bx中
            mov ah,0
            mov bl,30
            div bl

            ;角度值检测[0,180]
            cmp al,6    ;30*6=180度
            ja error
            cmp ah,0    ;余数是否为0
            je next
      error:mov al,7    ;al指向table表中error的偏移地址 7+7=14

       next:mov bl,al
            mov bh,0
            add bx,bx
            mov bx,table[bx]

            ;以下显示sin(x)的结果的字符串
            mov si,160*12+40*2
      shows:mov ah,cs:[bx]
            cmp ah,0
            je showret
            mov es:[si],ah
            inc bx
            add si,2
            jmp short shows

    showret:pop si
            pop es
            pop bx
            ret
code ends

end start
