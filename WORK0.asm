DATA SEGMENT
    BUFFER DB 96,95,94,92,91,90,100	
           DB 88,86,84,82,81,80,87,84,83,85,82
           DB 79,76,75,74,72,77,71,70,70,78,79
           DB 66,65,62,63,69,68,67
           DB 54,51,13,0                   
    RESULT DW 5 DUP(0);存放5个成绩段的结果
    STR1 DB 'THE NUMBER OF(>=90) IS:','$'
    STR2 DB 'THE NUMBER OF(80-89) IS:','$'
    STR3 DB 'THE NUMBER OF(70-79) IS:','$'
    STR4 DB 'THE NUMBER OF(60-69) IS:','$'
    STR5 DB 'THE NUMBER OF(<60) IS:','$'
DATA ENDS
STACK SEGMENT 'STACK'
    DB 100H DUP(0)  ;设堆栈长度为256
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START: MOV AX,DATA;设数据段寄存器的值
    MOV DS,AX
    MOV ES,AX
    MOV AX,STACK;设栈段寄存器的值
    MOV SS,AX

    MOV CX,40;设置循环次数
    LEA SI,BUFFER;设指针寄存器SI指向BUFFER
    LEA DI,RESULT;设指针寄存器DI指向RESULT
    CLD;设置方向位,增量方向
STEP1:LODSB;从BUFFER中读取一个数据到AL中
    CMP AL,90;比较AL和90
    JL STEP2;如果小于90,跳转到STEP2
    INC BYTE PTR[DI];如果大于或等于90，则将结果段中的第一个元素加1
    JMP NEXT;跳转到NEXT
STEP2:
    CMP AL,80;比较AL和80
    JL STEP3;如果小于80,跳转到STEP3
    INC BYTE PTR[DI+2];如果大于或等于80，则将结果段中的第三个元素加1
    JMP NEXT;跳转到NEXT
STEP3:
    CMP AL,70;比较AL和70
    JL STEP4;如果小于70,跳转到STEP4
    INC BYTE PTR[DI+4];如果大于或等于70，则将结果段中的第五个元素加1
    JMP NEXT;跳转到NEXT
STEP4:
    CMP AL,60;比较AL和60
    JL STEP5;如果小于60,跳转到STEP5
    INC BYTE PTR[DI+6];如果大于或等于60，则将结果段中的第七个元素加1
    JMP NEXT;跳转到NEXT
STEP5: INC BYTE PTR[DI+8];如果小于60,则将结果段中的第九个元素加1
NEXT:LOOP STEP1;

OUT_PART:;输出结果
    MOV DX,OFFSET STR1;输出分数大于或等于90的学生人数
    CALL DISMESS
    MOV BX,[DI];获取结果段中的第1个字
    CALL OUTPUT
    CALL NEWLINE

    MOV DX,OFFSET STR2;输出分数在80-89之间的学生人数
    CALL DISMESS
    MOV BX,[DI+2];获取结果段中的第2个字
    CALL OUTPUT
    CALL NEWLINE

    MOV DX,OFFSET STR3;输出分数在70-79之间的学生人数
    CALL DISMESS
    MOV BX,[DI+4];获取结果段中的第3个字
    CALL OUTPUT
    CALL NEWLINE

    MOV DX,OFFSET STR4;输出分数在60-69之间的学生人数
    CALL DISMESS
    MOV BX,[DI+6]
    CALL OUTPUT
    CALL NEWLINE

    MOV DX,OFFSET STR5;输出分数在60以下的学生人数
    CALL DISMESS
    MOV BX,[DI+8]
    CALL OUTPUT
    
    MOV AH,4CH;返回DOS系统
    INT 21H
OUTPUT PROC;输出一个十进制数，入口为BX
	PUSH AX;数据入栈区
    PUSH CX
	PUSH DX
	
	;初始化变量
    MOV AX,BX;放入数据准备除法
    MOV CL,10;设置除数
	MOV CH,0;用于计数便于后续出栈输出
	
S1: ;除法数字剥离部分
	CMP AX,0;判断是否已经除尽
	JE S2;若已经除尽，则跳转到S2
	INC CH;计数器加1
	DIV CL
	PUSH AX;入栈，提取的时候取用ah部分,存储余数（低位优先）
	MOV AH,0;调整ax
	JMP S1;再次除法剥离数字
		
S2: ;出栈输出部分
	CMP CH,0;判断数字是否已经除尽
	JE EXIT;若已经除尽，则跳转到EXIT
	POP AX;取用AH部分
	MOV DL,AH;输出部分
	ADD DL,30H;将数字转换为ASCII码字符输出
	MOV AH,2
	INT 21H
    DEC CH;计数器减1
	JMP S2;继续出栈输出,直至计数器为0
		
EXIT:;退出部分
	POP DX
	POP CX
	POP AX;数据出栈区
	RET
OUTPUT ENDP
DISMESS PROC;输出字符串
    MOV AH,9
    INT 21H
    RET 
DISMESS ENDP
NEWLINE PROC;输出回车换行
    PUSH AX
    PUSH DX
    MOV DL,0DH;输出回车符
    MOV AH,2
    INT 21H
    MOV DL,0AH;输出换行符
    MOV AH,2
    INT 21H
    POP DX
    POP AX
    RET
NEWLINE ENDP
CODE ENDS
    END START   