;实现三个无符号数的有大到小的排序
DATA SEGMENT
BUFFER DB 87,234,123
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START: MOV AX,DATA
    MOV DS,AX
    MOV SI,OFFSET BUFFER
    MOV AL,[SI]
    MOV BL,[SI+1]
    MOV CL,[SI+2]
    CMP AL,BL
    JAE NEXT1
    XCHG AL,BL
NEXT1: CMP AL,CL
    JAE NEXT2
    XCHG AL,CL
NEXT2: CMP BL,CL
    JAE NEXT3
    XCHG BL,CL
NEXT3: MOV [SI],AL
    MOV [SI+1],BL
    MOV [SI+2],CL
    MOV AH,4CH
    INT 21H
CODE ENDS
END START
;MOV SI,OFFSET BUFFER
;MOV AL,[SI]
;JAE NEXT1
;XCHG AL,[SI+1]
;MOV [SI],AL
;NEXT1:CMP AL,[SI+2]
;JAE NEXT2
;XCHG AL,[SI+2]
;MOV [SI],AL
;NEXT2:MOV AL,[SI+1]
;CMP AL,[SI+2]
;JAE NEXT3
;XCHG AL,[SI+2]
;MOV [SI+1],AL
;NEXT3: