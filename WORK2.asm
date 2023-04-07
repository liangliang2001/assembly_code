DATA SEGMENT
    N EQU 10
    NUMBER DB N DUP(?)
    STR1 DB 'INPUT 40 NUMBERS:','$'
    STR2 DB 'AFTER SORTED:','$' 
DATA ENDS
STACK SEGMENT 'STACK'
    DB 256 DUP(0)
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,OFFSET STR1
    MOV AH,9
    INT 21H
    MOV SI,OFFSET NUMBER
    MOV CX,0
GETDATA:
    INC CX 
    CALL INPUT
    MOV DS:[SI],BL
    ADD SI,1
    CMP CX,N
    JL GETDATA

    LEA DX,NUMBER 
    MOV CX,N
    CALL SORT2

    CALL NEWLINE
    LEA DX,STR2;输出提示二
    MOV AH,09H
    INT 21H

    LEA SI,NUMBER
    MOV CX,N 
    CALL TEN_PRINT   ;调用子程序输出排序后的数字序列

    MOV AH,4CH
    INT 21H
;正负数十进制输入子程序,BL为数据出口
INPUT PROC
    PUSHF
    PUSH AX
    PUSH CX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX

    MOV AH,1
    INT 21H
    CMP AL,'-'
    JNZ STEP2
    MOV CX,1
STEP1:
    MOV AH,1
    INT 21H
STEP2:
    CMP AL,'0'
    JB STEP3
    CMP AL,'9'
    JA STEP3
    SUB AL,30H
    MOV AH,0
    PUSH AX
    MOV AL,BL
    MOV DL,10
    IMUL DL
    MOV  BL,AL
    POP AX
    ADD BL,AL
    JMP STEP1
STEP3:
    CMP CX,0
    JZ EXIT
    NEG BL
EXIT:
    POP CX
    POP AX
    POPF
    RET
INPUT ENDP
;正负数十进制输出子程序，SI存入数据的表首地址，CX存入数据个数
TEN_PRINT PROC  
L1: MOV DI,CX
    MOV DL,[SI] 

    CMP DL,0      ;判断是否是负数
    JGE L3        ;JGE有符号数比较大小，不小于，不为负数，则转移到X3
    MOV DH,DL     ;先保存当前负数到DH

    MOV DL,'-'    ;输出'-'
    MOV AH,02H
    INT 21H

    NEG DH        ;转换成绝对值
    MOV DL,DH     ;将数值保存到DL，和正数一样输出
;正数的十进制输出   
L3: INC SI
    MOV CX,1   ;计数，初始值为1
    MOV BL,10   ;每次除10 
;进栈    
FIRST:          
    MOV AH,0   ;余数清零
    MOV AL,DL
    DIV BL     ;除10
    PUSH AX    ;进栈,其中AH为余数，AL为商
    CMP AL,0   ;比较商是否为0
    JLE SECOND
    MOV DL,AL
    INC CX
    JMP FIRST
;出栈    
SECOND:
    POP DX      ;出栈，其中DH为余数，DL为商
    XCHG DH,DL  ;交换DH,DL,使余数存入DL
    ADD DL,30H  ;转为ASCII码
    MOV AH,02H
    INT 21H
LOOP SECOND

    MOV CX,DI
    CMP CX,1     ;最后一个数字后面不输出'，'
    JE L2
    MOV DL,','
    MOV AH,02H
    INT 21H

L2: LOOP L1
    RET      
TEN_PRINT ENDP        
;冒泡升序排序,CX中存数据个数，DX存数据的首地址      
SORT1 PROC
      DEC CX
T1:   MOV DI,CX     ;保存外循环次数
      MOV BX,DX     ;将NUMBER的首地址存到BX中
T2:   MOV AL,[BX]
      CMP AL,[BX+1]
      JLE T3
      XCHG AL,[BX+1]
      MOV [BX],AL
T3:   ADD BX,1
      LOOP T2       ;  两两比较完成
      MOV CX,DI
      LOOP T1       ;  每运行到此处一次说明又有一个最大数到未排序数的末尾
      RET
SORT1 ENDP
;冒泡降序排序，CX中存数据个数，DX存数据的首地址      
SORT2 PROC
    DEC CX
S1:
    MOV DI,CX
    MOV BX,DX
S2:
    MOV AL,[BX]
    CMP AL,[BX+1]
    JG S3 
    XCHG AL,[BX+1]
    MOV [BX],AL
S3:
    INC BX
    LOOP S2 
    MOV CX,DI
    LOOP S1
    RET
SORT2 ENDP
;输出换行
NEWLINE PROC
    PUSH AX
    PUSH DX
    MOV DL,0DH
    MOV AH,2
    INT 21H
    MOV DL,0AH
    MOV AH,2
    INT 21H
    POP DX
    POP AX
    RET
NEWLINE ENDP
CODE ENDS
    END START



