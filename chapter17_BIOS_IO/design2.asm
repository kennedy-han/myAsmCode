;王爽《汇编语言（第2版）》课程设计2 
;本安装程序中包含的任务程序功能如下： 
;功能选项： 
;  1）reset pc          ;重启计算机 
;  2）start system      ;引导现有操作系统 
;  3）clock             ;进入时钟程序 
;  4）set clock         ;设置时间 

assume cs:codesg 

codesg segment 
    start: 
        mov ax,cs 
        mov es,ax 
         
        ;***************************** 安装到软盘 ********************************* 
        ;本模块功能： 
        ;1、拷贝引导程序到磁盘的 0面0磁道1扇区处 （占1个扇区） 
        ;2、拷贝任务主程序到磁盘的 0面0磁道2扇区处 （占5个扇区） 
         
        ;拷贝任务引导程序 
        mov bx,offset bootStart  ;引导程序的起始地址 
        mov al,1    ;扇区数 
        mov ch,0    ;磁道号 
        mov cl,1    ;扇区号 
        mov dh,0    ;磁头号（0面） 
        mov dl,0    ;驱动器号 
        mov ah,3    ;功能号 
        int 13h 
         
        ;拷贝任务主程序 
        mov bx,offset mainStart   ;任务主程序的起始地址  
        mov al,5    ;扇区数 
        mov ch,0    ;磁道号 
        mov cl,2    ;扇区号 
        mov dh,0    ;磁头号（0面） 
        mov dl,0    ;驱动器号 
        mov ah,3    ;功能号 
        int 13h 
         
        mov ax,4c00h 
        int 21h 
         
         
      ;*********************** 0面0磁道0扇区的引导程序 *************************** 
      ;本模块功能：引导计算机从磁盘中读取主功能程序至内存中 
       
      ;ORG 7c00h   ;指示引导程序运行时的起始地址（本模块内部无跳转，因此可注释掉） 
         
      ;任务引导程序 
      bootStart:     
          ;读取任务主程序至内存并执行 
          mov ax,0 
          mov es,ax 
          mov bx,7e00h ;内存512单元，即从2号扇区读入的内容将放置的起始地址 
          mov al,5    ;扇区数 
          mov ch,0    ;磁道号 
          mov cl,2    ;扇区号 
          mov dh,0    ;磁头号（0面） 
          mov dl,0    ;驱动器号 
          mov ah,2    ;功能号 
          int 13h 
           
          jmp bx  ;跳转到任务主程序 
      bootEnd:nop 
       
     
    ;***************************** 任务主界面程序 ********************************* 
    ;本模块功能：实现课程设计2中的程序主菜单功能 
     
    ORG 7e00h     ;指示任务主程序运行时的起始地址：7c00h+200h（200h=512） 
     
    ;任务主程序 
    mainStart: 
        jmp mainMenu 
         
        ;子功能直接定址表 
        keyNum dw resetPC,startSys,showClock,setClock 
        ;日期时间单元号列表 
        numDatetime db 9,8,7,4,2,0      ;年，月，日，时，分，秒 
        ;菜单字符串 
        str0 db 'Please input the number of the menu:',0  ;提示信息 
        str1 db '1) Reset PC',0 
        str2 db '2) Start System',0 
        str3 db '3) Clock',0 
        str4 db '4) Set Clock',0 
         
        ;列出功能主选单 
        mainMenu: 
            mov ax,cs 
            mov ds,ax 
                   
            mov si,offset str0 
            mov di,160*2+10       ;提示信息首句，第2行第5列起 
            call printString 
             
            mov si,offset str1 
            mov di,160*5+20 
            call printString 
             
            mov si,offset str2 
            mov di,160*7+20 
            call printString 
             
            mov si,offset str3 
            mov di,160*9+20 
            call printString 
             
            mov si,offset str4 
            mov di,160*11+20 
          call printString 
     
           
        ;根据按键ASCII码实现不同功能 
        checkKey: 
            mov ah,0 
            int 16h 
            cmp al,31h 
            jb checkKey 
            cmp al,34h 
            ja checkKey           
       
            mov bl,al 
            sub bl,31h   ;将数字1～4的ASCII码转换为0～3 
            mov bh,0 
            add bx,bx    ;bx=bx*2  换算出定址表地址 
            call word ptr keyNum[bx]   ;根据直接定址表跳转到相应功能区 
             
            ;若调用返回则重新生成菜单 
            call clearScreen        ;清屏 
            jmp near ptr mainMenu  ;从头开始 
        
        
       ;***************************** 子功能实现区 *********************************  
        
         
      ;子程序功能（1）：重启计算机 
      resetPC:       
          jmp gotoReset 
          resetAdd dw 0,0ffffh 
          gotoReset:jmp dword ptr resetAdd[0]    ;跳转到 FFFF:0 单元处执行 
           
      ;_________________________________________________________   
       
       
      ;子程序功能（2）：引导现有操作系统 
      startSys: 
          call clearScreen   ;清屏 
         
          ;读取硬盘引导程序至内存并执行 
          mov ax,0 
          mov es,ax 
          mov bx,7c00h 
          mov al,1    ;扇区数 
          mov ch,0    ;磁道号 
          mov cl,1    ;扇区号 
          mov dh,0    ;磁头号（0面） 
          mov dl,80h  ;驱动器号：硬盘 
          mov ah,2    ;功能号 
          int 13h 
           
          push es 
          push bx 
          retf       ;跳转到dos引导程序所在内存区：0:7c00h 
        
      ;_________________________________________________________    
       
      ;子程序功能（3）：进入时钟程序 
      showClock: 
          jmp short clockStart 
           
          isReturnMain db 0          ;侦测该值若等于1，则返回主菜单 
          int9Add dw 0,0             ;用于保存原BIOS int 9 向量 
          strTip db 'Now it is :',0                 ;标题 
          strDatetime db 'YY/MM/DD hh:mm:ss',0      ;日期时间格式字符 
           
          clockStart:             
          call clearScreen        ;清屏       
          call setInt9            ;安装设置9号中断，以侦测键盘按键 
           
          mov isReturnMain,0      ;初始化 
           
          ;时钟程序 
          clockApp: 
              cmp isReturnMain,1 
              jne nextClockApp 
                           
              ;恢复原int9的入口地址 （若不恢复，在主菜单按2引导dos时会死机 囧） 
              mov ax,0 
              mov es,ax 
              push int9Add[2] 
              push int9Add[0] 
              cli 
              pop es:[4*9] 
              pop es:[4*9+2] 
              sti                   
              ret 
               
          nextClockApp: 
              mov si,0 
              mov cx,6 
              readDatetimes: 
                call readDatetime        ;读取并填写时间数字 
                inc si 
              loop readDatetimes 
                       
              mov ax,cs 
              mov ds,ax 
                     
              ;将字符串显示到屏幕 
              mov si,offset strTip 
              mov di,160*2+10 
              call printString 
               
              mov si,offset strDatetime 
              mov di,160*4+20 
              call printString 
               
              jmp clockApp          ;循环读取CMOS并显示   
                     
        ;----------------------------------------------   
                 
        ;读取并填写时间数字 
        ;入口参数：si为日期字符栈顺序号 
        readDatetime: 
            push ax 
            push bx 
            push cx 
             
             
            mov al,numDatetime[si]   ;al:时间信息单元号 
            out 70h,al 
            in al,71h 
             
            ;BCD码两位数字分置入ah、al 
            mov ah,al 
            mov cl,4 
            shr ah,cl 
            and al,00001111b 
             
            ;转换为ASCII码 
            add ah,30h 
            add al,30h 
             
            ;填写到格式字符串 
            mov bx,si 
            add bx,si 
            add bx,si     ;bx=si*3 
            mov strDatetime[bx],ah 
            mov strDatetime[bx+1],al 
             
            pop cx 
            pop bx 
            pop ax 
            ret 
           
        ;----------------------------------------------    
          
        ;重新安装设置9号中断 
        setInt9: 
            push ax 
            push es 
             
            ;备份原int9的入口地址 
            mov ax,0 
            mov es,ax 
            push es:[4*9] 
            push es:[4*9+2] 
            pop int9Add[2] 
            pop int9Add[0] 
             
            ;设置int9的新入口地址 
            cli 
            mov word ptr es:[4*9],offset int9 
            mov es:[4*9+2],cs 
            sti 
           
          setInt9Ret: 
            pop es 
            pop ax 
            ret 
           
      ;----------------------------------------------   
           
      ;int 9 新例程 
      int9: 
          push ax 
          push bx 
          push cx 
          push es             
                 
          ;首先模拟执行原int 9例程 
          pushf 
          pushf 
          pop ax 
          and ah,11111100b            ;设if=0,tf=0 
          push ax 
          popf 
          call dword ptr int9Add[0]   ;调用原int9例程 
           
          in al,60h        ;读入键盘扫描码 
          cmp al,01h       ;ESC按键 
          je returnMain    ;返回主菜单 
          cmp al,3bh       ;F1按键 
          je changeColor   ;改变显示颜色 
          jmp int9ret 
           
          ;返回主菜单 
          returnMain: 
              mov isReturnMain,1  ;标记返回主菜单(注：直接在此跳转主菜单的话， 
              jmp int9ret         ;会因iret等出栈不彻底导致程序异常） 
           
          ;改变显示颜色 
          changeColor: 
              mov ax,0b800h 
              mov es,ax 
              mov bx,1 
              mov cx,2000 
              setColor: 
                  inc byte ptr es:[bx]     ;属性值加1，改变颜色 
                  add bx,2 
              loop setColor  
             
          int9ret: 
              pop es 
              pop cx 
              pop bx 
              pop ax 
              iret                  
         
         
    ;_________________________________________________________   
       
    ;子程序功能（4）：设置时间 
    ;注：日期时间输入格式：YY/MM/DD hh:mm:ss （仅实现功能，无防错代码） 
    setClock: 
        jmp setStart 
        charSS db 32 dup (0)        ;字符栈空间 
        strInputTip db 'Please set datetime(Format: YY/MM/DD hh:mm:ss):',0  ;输入提示 
     
    setStart: 
        ;呈现格式输入提示语 
        call clearScreen        ;清屏   
        mov si,offset strInputTip 
        mov di,160*2+10 
        call printString 
         
        ;设置光标初始位置 
        mov ah,2 
        mov bh,0   ;页号 
        mov dh,4   ;行号 
        mov dl,10  ;列号 
        int 10h 
         
        mov ax,cs 
        mov ds,ax 
        mov si,offset charSS 
        mov dx,040ah       ;输入字符的显示行列号 
        call getStr        ;等待输入字符 
         
        ;回车后修改时间并返回主菜单 
        mov si,0 
        mov cx,6 
        setDatetimes: 
          call setDatetime         ;设置时间数字 
          inc si 
        loop setDatetimes 
          
         
        call clearScreen        ;清屏 
        ;恢复光标初始位置 
        mov ah,2 
        mov bh,0   ;页号 
        mov dh,0   ;行号 
        mov dl,0   ;列号 
        int 10h 
        ret 
         
        ;----------------------------------------------   
         
        ;接收字符串输入 
        getStr: 
            push ax 
             
        getStrs: 
            mov ah,0 
            int 16h 
            cmp al,20h 
            jb noChar       ;滤掉非字符 
            mov ah,0 
            call charStack  ;字符入栈 
            mov ah,2 
            call charStack  ;显示栈中的字符 
            jmp getStrs 
             
        noChar: 
            cmp ah,0eh      ;退格键 
            je backspace 
            cmp ah,1ch      ;回车键 
            je enter 
            jmp getStrs 
             
        backspace: 
            mov ah,1 
            call charStack   ;字符出栈 
            mov ah,2 
            call charStack   ;显示栈中的字符 
            jmp getStrs 
             
        enter: 
            mov al,0 
            mov ah,0 
            call charStack    ;0标记字符入栈 
            mov ah,2 
            call charStack    ;显示栈中的字符 
            pop ax 
            ret 
             
           
      ;字符串处理：字符栈的入栈、出栈和显示 
      ;入口参数：功能号(ah)=   0:入栈；  1:出栈；  2:显示 
      ;                (al)=   入栈字符  返回字符；  dh、dl 为显示的行列号 
      ;          ds:si 指向字符栈空间 
      charStack: 
          jmp short charStart 
           
          charTable dw charPush,charPop,charShow 
          top       dw 0                            ;栈顶 
           
          charStart: 
              push bx 
              push dx 
              push di 
              push es 
               
              cmp ah,2 
              ja sret 
              mov bl,ah 
              mov bh,0 
              add bx,bx 
              jmp word ptr charTable[bx]    ;根据定址表跳转到相应功能区 
               
          ;字符入栈 
          charPush: 
              mov bx,top 
              mov [si][bx],al 
              inc top 
              jmp sret 
               
          ;字符出栈 
          charPop: 
              cmp top,0 
              je sret 
              dec top 
              mov bx,top 
              mov al,[si][bx] 
              jmp sret 
               
          ;计算字符显示位置 
          charShow: 
              mov bx,0b800h 
              mov es,bx 
              mov al,160 
              mov ah,0 
              mul dh 
              mov di,ax 
              add dl,dl 
              mov dh,0 
              add di,dx        ;(di)=字符显示的行列位置 
               
              mov bx,0 
               
          ;显示栈中的字符 
          charShows: 
              cmp bx,top 
              jne noEmpty 
              mov byte ptr es:[di],' ' 
              jmp sret 
          noEmpty: 
              mov al,[si][bx] 
              mov es:[di],al 
              mov byte ptr es:[di+2],' ' 
              inc bx 
              add di,2 
               
              ;设置光标跟随 
              push ax 
              push bx 
              push dx 
              mov dx,top 
              add dl,10  ;根据字符栈顶指针计算出列号 
              mov ah,2   ;功能号，指定光标位置 
              mov bh,0   ;页号 
              mov dh,4   ;行号 
              int 10h 
              pop dx 
              pop bx 
              pop ax 
         
              jmp charShows 
               
          sret: 
              pop es 
              pop di 
              pop dx 
              pop bx 
              ret 
               
         ;----------------------------------------------   
      
         ;设置时间数字 
         ;入口参数：si为日期字符栈顺序号 
          setDatetime: 
              push ax 
              push bx 
              push cx 
               
              ;从字符栈读取字符 
              mov bx,si 
              add bx,si 
              add bx,si                ;bx=si*3 
              mov ah,charSS[bx] 
              mov al,charSS[bx+1]  
                            
              ;ASCII转换为BCD码 
              sub ah,30h 
              sub al,30h 
               
              ;BCD码两位数字合成并临时存入bh 
              mov cl,4 
              shl ah,cl 
              and al,00001111b 
              add ah,al 
               
              ;改写时间信息（两位数字） 
              mov al,numDatetime[si]   ;al:时间信息单元号 
              out 70h,al               
              mov al,ah 
              out 71h,al 
               
              pop cx 
              pop bx 
              pop ax 
              ret 
      
     ;***************************** 其他子程序 ********************************* 
     ;本模块功能：提供各模块都需要调用的子程序 
      
     ;子程序：在屏幕上显示字符串 
     ;入口参数ds:si 指向以0结尾的源字符串 
     ;入口参数 di 指向屏幕位置 
     printString: 
         push ax 
         push si 
         push di 
          
         printS:       
         mov ax,0b800h 
         mov es,ax 
          
         mov al,ds:[si] 
         cmp al,0 
         je printRet 
         mov es:[di],al 
         inc si 
         add di,2 
         jmp printS 
         printRet: 
         pop di 
         pop si 
         pop ax 
         ret 
       
     ;_________________________________________________________    
        
     ;子程序：清屏 
     clearScreen: 
         push ax 
         push bx 
         push cx 
         push es 
          
         mov ax,0b800h 
         mov es,ax 
         mov bx,0 
         mov al,' ' 
         mov cx,2000 
         fillSpace: 
           mov es:[bx],al 
           add bx,2 
         loop fillSpace 
          
         pop es 
         pop cx 
         pop bx 
         pop ax 
         ret 
        
       
        
   mainEnd:nop 
    
codesg ends 
end start