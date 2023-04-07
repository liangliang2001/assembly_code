DATA SEGMENT
    TABLE DB 0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225;预先将0-15的平方值存入TABLE
    STR DB 'INPUT A NUMBER BETWEEN 0 AND 15:','$';输出提示信息
    NUM DW 0;记录输入的数字
    STR1 DB 'THE RESULT IS ','$';输出结果的提示信息
    ERROR DB 'INVALID INPUT!','$';输入错误的提示信息
DATA ENDS
STACK SEGMENT 'STACK'
    DB 256 DUP (?);设堆栈长度为256
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:MOV AX,DATA;将数据段的地址赋给AX
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX
    MOV DX,OFFSET STR;输出提示信息
    MOV AH,9
    INT 21H

    MOV SI,OFFSET NUM;将NUM的地址赋给SI
    CALL INPUT;调用INPUT函数,输入数据
    CMP BX,15;判断是否超出范围
    JG ERROR1;若超出范围则跳转到ERROR1
    MOV DS:[SI],BX;将输入的数字存入NUM

    CALL NEWLINE;调用NEWLINE函数,输出换行
    MOV BX,OFFSET TABLE;将TABLE的地址赋给BX
    MOV AH,0
    MOV AL,DS:[SI];将NUM的值赋给AL
    XLAT;查表，将查得的数据保存到AL
    MOV BX,AX
    MOV DX, OFFSET STR1;输出结果的提示信息
    MOV AH,9
    INT 21H
    CALL OUTPUT;输出结果
    JMP EXIT0;跳转到EXIT0
ERROR1:
    MOV DX,OFFSET ERROR
    MOV AH,9
    INT 21H
EXIT0:
    MOV AH,4CH;返回到DOS
    INT 21H
INPUT PROC
    PUSH AX;保存数据
    PUSH CX
    PUSH DX
    
    MOV BX,0;对BX进行初始化
STEP1:
    MOV AH,1
    INT 21H
    CMP AL,30H;判断是否为数
    	JB EXIT1;若不是数字则跳转到EXIT1
    CMP AL,39H
    	JA EXIT1;若不是数字则跳转到EXIT1
    SUB AL,30H;将ASCII码转换为数字
    MOV CL,AL;将AL的值赋给CL
    MOV AL,BL;将BL的值赋给AL 
    MOV DH,10;将10作为乘数 
    MUL DH
    ADD AX,CX;AX的高位值加上CX的低位值，存在AX中
    MOV BX,AX;BX来积累数据最终值
    JMP STEP1;继续循环
EXIT1:;推出部分
    POP DX
    POP CX
    POP AX
    RET
INPUT ENDP
OUTPUT PROC
	PUSH AX;数据入栈区
    PUSH CX
	PUSH DX
	
	;初始化变量
	;数据放入准备除法
    MOV AX,BX
	;作为除数
    MOV CL,10
	MOV CH,0;用于计数便于后续出栈输出
	
S1: ;除法数字剥离部分
	CMP AX,0;判断是否已经除尽
	JE S2
	INC CH;计数器加1
	DIV CL
	PUSH AX;入栈，提取的时候取用AH部分,存储余数（低位优先）
	MOV AH,0;调整AX
	JMP S1;再次除法剥离数字 
		
S2: ;出栈输出部分
	CMP CH,0;判断数字是否已经出尽
	JE EXIT
	POP AX;取用AH部分
	MOV DL,AH;输出部分
	ADD DL,30H;将数字转换为ASCII码字符输出
	MOV AH,2;输出字符
	INT 21H
    DEC CH
	JMP S2;继续出栈输出
		
EXIT:;收尾部分
	POP DX
	POP CX
	POP AX;数据出栈区
	RET
OUTPUT ENDP
NEWLINE PROC
    PUSH AX
    PUSH DX
    MOV DL,0DH;输出回车
    MOV AH,2
    INT 21H
    MOV DL,0AH;输出换行
    MOV AH,2
    INT 21H
    POP DX
    POP AX
    RET
NEWLINE ENDP
CODE ENDS
    END START