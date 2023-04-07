DATA SEGMENT
    STRING1 DB 'Befroe sort: ','$'
    STRING2 DB 0DH,0AH,'After sort: ','$'
    NUMBER DB 71,23,62,-62,42,54,20,-13,45
    N DW $-NUMBER
DATA ENDS
STACK SEGMENT 'STACK'
    DB 256 DUP(?)
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:MOV AX,DATA
      MOV DS,AX  
      LEA DX,STRING1;输出提示一
      MOV AH,09H
      INT 21H 

      LEA SI,NUMBER
      MOV CX,N 
      CALL TEN_PRINT ;调用子程序输出排序前的数字序列

      LEA DX,NUMBER 
      MOV CX,N
      CALL SORT2

      LEA DX,STRING2;输出提示二
      MOV AH,09H
      INT 21H

      LEA SI,NUMBER
      MOV CX,N 
      CALL TEN_PRINT   ;调用子程序输出排序后的数字序列
      
      MOV AH,4CH
      INT 21H
      
;正负数十进制输出子程序，SI存入数据的表首地址，CX存入数据个数
TEN_PRINT PROC  
STEP1: MOV DI,CX
    MOV DL,[SI] 

    CMP DL,0      ;判断是否是负数
    JGE STEP3        ;JGE有符号数比较大小，不小于，不为负数，则转移到X3
    MOV DH,DL     ;先保存当前负数到DH

    MOV DL,'-'    ;输出'-'
    MOV AH,02H
    INT 21H

    NEG DH        ;转换成绝对值
    MOV DL,DH     ;将数值保存到DL，和正数一样输出
;正数的十进制输出   
STEP3: INC SI
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
    JE STEP2
    MOV DL,','
    MOV AH,02H
    INT 21H

STEP2: LOOP STEP1
    RET      
TEN_PRINT ENDP        

;冒泡升序排序子程序,CX中存数据个数，DX存数据的首地址      
SORT1 PROC
      DEC CX
L1:   MOV DI,CX     ;保存外循环次数
      MOV BX,DX     ;将NUMBER的首地址存到BX中
L2:   MOV AL,[BX]
      CMP AL,[BX+1]
      JLE L3
      XCHG AL,[BX+1]
      MOV [BX],AL
L3:   ADD BX,1
      LOOP L2       ;  两两比较完成
      MOV CX,DI
      LOOP L1       ;  每运行到此处一次说明又有一个最大数到未排序数的末尾
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
CODE ENDS
END START