DATA SEGMENT
MAT1 DB 0DH,0AH,'MATCH','$'
SOURCE DB 'PLEASE INPUT A LETTER!'
DEST DB 'PLEASE INPUT A LETTER!'
LONG1 EQU $-DEST
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX
    CLD
    LEA DI,DEST
    LEA SI,SOURCE
    MOV CX,LONG1
    REPE CMPSB                      ;相等则重复比较，直至不等或（CX）=0，则退出

    JE MATCH                        ;若退出时仍相等，则跳转到MATCH
    DEC SI                          ;不相等，则返回原值（因为SI已经被自加1，所以需要SI-1）

    LODS SOURCE                     ;取出源串中不相等的值->（AL）
    MOV DL,AL 
    MOV AH,2
    INT 21H
    DEC DI 
    MOV DL,[DI]                     ;直接取出目的串中不相等的值->（DL）
    MOV AH,2
    INT 21H
    JMP EXIT
MATCH:                              ;显示匹配信息
    MOV AH,9
    LEA DX,MAT1
    INT 21H
EXIT:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START

