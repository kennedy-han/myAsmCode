;问题一：编写、安装中断7ch的中断例程
;功能：求一word型数据的平方
;参数：(ax)=要计算的数据
;返回值：dx、ax中存放结果的高16位和低16位
;应用举例：求 2*3456^2
assume cs:codesg

codesg segment

  start:mov ax,3456
        int 7ch   ;调用中断7ch的中断例程，计算ax中的数据平方

        add ax,ax
        adc dx,dx   ;dx:ax存放结果，将结果乘以2

        mov ax,4c00h
        int 21h

codesg ends

end start
