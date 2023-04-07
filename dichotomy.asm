DATA SEGMENT
STR DW 14;数组的第一个单元存放字符的长度
    DW 3,6,10,23,45,57,78,89,100,150,230,280,390,480
X DW 122
STR1 DB 'NOT FOUND!','$'
STR2 DB 'INPUT A NUMBER:','$'
STR3 DB 'GOOD JOB! YOU HAVE FOUND IT!','$'
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,OFFSET STR2
    CALL DISMESS
    CALL INPUT
    MOV AX,BX
    LEA DI,STR
    CMP AX,[DI+2]
    JA LAST
    JMP NOFD
LAST:
    MOV SI,[DI]
    SHL SI,1
    ADD SI,DI
    CMP AX,[SI]
    JB SECH
    JE FOUND
    JMP NOFD
SECH:
    MOV SI,[DI]
EVE1:
    TEST SI,1
    JZ ADD1
    INC SI
ADD1:
    ADD DI,SI
CMP1:
    CMP AX,[DI]
    JE FOUND
    JA UP
    CMP SI,2
    JNE AGAIN
NOFD:
    STC 
    MOV DX,OFFSET STR1
    CALL DISMESS
    JMP EXIT
AGAIN:
    SHR SI,1
    TEST SI,1
    JZ SUB1
    INC SI
SUB1:
    SUB DI,SI
    JMP SHORT CMP1
UP:
    CMP SI,2
    JE NOFD
    SHR SI,1
    JMP SHORT EVE1
FOUND:
    MOV DX,OFFSET STR3
    CALL DISMESS
    JMP EXIT
EXIT:
    MOV AH,4CH
    INT 21H
DISMESS PROC;输出字符串
    MOV AH,9
    INT 21H
    RET 
DISMESS ENDP
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
		
EXIT2:;收尾部分
	POP DX
	POP CX
	POP AX;数据出栈区
	RET
OUTPUT ENDP
CODE ENDS
    END START