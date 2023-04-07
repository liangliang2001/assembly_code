DATAS SEGMENT
      data word 20 DUP(?);存数数据区
      CRLF DB 0AH,0DH,"$"
      string1 DB "Please input 10 numbers:","$";输入提示(可输入多位数字)
	  stringmax DB "Max:","$";输出提示
	  stringmin DB "Min:","$";输出提示
DATAS ENDS 
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS
 
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx,string1;输入提示
    mov ah,9
    int 21h
    
    LEA DX, CRLF;回车换行           
    MOV AH, 09H							 
    INT 21H
    
    mov si,offset data;获取偏移量
    mov cx,0;用于计数
 
;持续接收输入数据并且存储进入内存中   
getdata:
    inc cx;计数加一
    call input;调用输入函数
    mov ds:[si],bx;数据存入内存中
    add si,2;偏移量加二
    cmp cx,10;输入十个数，则进入下一版块获取最大与最小值
    	je maxandmin
    jmp getdata;继续接收数据
 
;查找数据中的最大值与最小值    	
maxandmin:;默认全为正数
    mov ax,0;用于记录最大值
    mov bx,0;用于记录最小值
    mov cx,0;用于计数
    
    mov si,offset data;获取偏移量
	mov bx,ds:[si];初始化最小值
	
cmpagain:
    inc cx;计数加一
    cmp cx,10;进入输出板块
    	ja outputthedata
    mov dx,ds:[si];用于接受数据
    add si,2
    cmp dx,ax;找最大
    	ja max;进入交换数据板块
    cmp dx,bx;找最小
    	jb min;进入交换数据板块
    jmp cmpagain
max:
	mov ax,dx
		jmp cmpagain;loop
min:
	mov bx,dx
		jmp cmpagain;loop
	
	
outputthedata:;数据输出板块	
	;最大值在寄存器ax中；最小值在寄存器bx中！
	push bx;最小值压栈
	push ax;最大值压栈
	
	LEA DX,CRLF;回车换行           
    MOV AH,09H							 
    INT 21H
	
	lea dx,stringMax;最大值输出提示
	mov ah,9
	int 21h
	
	pop bx
	call output
	push bx
	
	mov dl,' '
	mov ah,2
	int 21h
	
	pop ax
	call hexadecimaloutput
	
	LEA DX,CRLF;回车换行           
    MOV AH,09H							 
    INT 21H
	
	lea dx,stringMin;最小值输出提示
	mov ah,9
	int 21h
	
	pop bx
	call output
	push bx
	
	mov dl,' '
	mov ah,2
	int 21h
	
	pop ax
	call hexadecimaloutput

	LEA DX,CRLF;回车换行           
    MOV AH,09H							 
    INT 21H
	lea di,data
	mov bx,[di]	
	call output

	mov bx,[di+2]
	call output
    MOV AH,4CH
    INT 21H
    
;输入子程序，bx为出口参数
input proc
    push ax;入栈
    push cx
    push dx
    
    mov bx,0
L2:
    mov ah,01h
    int 21h
    cmp al,30h;判断是否为数
    	jb L1
    cmp al,39h
    	ja L1
    sub al,48;剥离
    mov cl,al
    mov al,bl
    mov dh,10
    mul dh
    add ax,cx
    mov bx,ax;bx来积累数据最终值
    jmp L2
L1:
    pop dx
    pop cx
    pop ax    
    ret
input endp
 
;十进制输出函数，入口参数为bx
output proc
	push ax;数据入栈区
	push cx
	push dx
	
	;初始化变量
	mov ax,bx;数据放入准备除法
	mov cl,10;作为除数
	mov ch,0;用于计数便于后续出栈输出
	
divagain:;除法数字剥离部分
	cmp ax,0;判断是否已经除尽
		je divover
	inc ch;计数器加1
	div cl
	push ax;入栈，提取的时候取用ah部分,存储余数（低位优先）
	mov ah,0;调整ax
		jmp divagain;再次除法剥离数字
		
divover:;出栈输出部分
	cmp ch,0;判断数字是否已经出尽
		je outputover
	pop ax;取用ah部分
	mov dl,ah;输出部分
	add dl,48
	mov ah,2
	int 21h
	dec ch
		jmp divover 
		
outputover:;收尾部分
	pop dx
	pop cx
	pop ax;数据出栈区
	ret
output endp
 
;十六进制形式的输出,入口参数为ax
hexadecimaloutput proc
	push bx;数据入栈，数值保留
	push cx
	push dx
	
	mov dh,0;用于计数，总共4次
	
hexadecimalagain:
	cmp dh,4
		je hexadecimalover;循环结束，进行收尾工作
		inc dh;计数加一
	mov cl,4
	rol ax,cl
	mov cx,ax;数值保留
	and ax,0fh;数据剥离后四位
	mov dl,al
	cmp dl,9;区分需要输出数字还是字母
		ja alphabet;作为字母输出
	add dl,48;作为数字形式的输出
	mov ah,2
	int 21h	
	mov ax,cx;数据恢复
		jmp hexadecimalagain
		
alphabet:;作为字母形式的输出
	add dl,55
	mov ah,2
	int 21h
	mov ax,cx;数据恢复
		jmp hexadecimalagain
 
hexadecimalover:		
	pop dx;数据出栈，数值保留
	pop cx
	pop bx
	ret
hexadecimaloutput endp
 
    
CODES ENDS
    END START