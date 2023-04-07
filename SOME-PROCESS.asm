;大写字母转换为小写字母
UPTOLW PROC
    PUSHF
    CMP AL,'A'
    JB UPTOLW_END
    CMP AL,'Z'
    JA UPTOLW_END
    ADD AL,'a'-'A'
UPTOLW_END: POPF
    RET
UPTOLW ENDP

;形成回车和换行
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
;HTOASC
HTOASC PROC
    AND AL,OFH
    ADD AL,90H
    DAA 
    ADC AL,40H
    DAA
    RET
HTOASC ENDP

;-------------------
;等待N秒，N由AX输入，N最大360
DELAY_SEC PROC
    PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MUL CS:DELAY_SEC_CPS
    DIV CS:DELAY_SEC_TEN
    MOV BX,AX
    
    INT 1AH
    MOV CS:DELAY_SEC_TIMES,DX
DELAY_SEC_1:
    INT 1AH
    SUB DX,CS:DELAY_SEC_TIMES
    CMP DX,BX
    JB DELAY_SEC_1    
    
    POP DX
    POP CX
    POP BX
    POP AX
    POPF
    RET
    
    DELAY_SEC_CPS DW 182
    DELAY_SEC_TEN DW 10
    DELAY_SEC_TIMES DW 0
DELAY_SEC ENDP
;-------------------
 
;-------------------
;清屏
CLR_SCR PROC
    PUSHF
    PUSH AX
    
    MOV AX,3
    INT 10H
    
    POP AX
    POPF
    RET
CLR_SCR ENDP
;-------------------
 
;-------------------
;空格
SPACE PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    MOV AH,02H
    MOV DL,' '
    INT 21H
        
    POP DX
    POP AX
    POPF
    RET
SPACE ENDP
;-------------------
 
;-------------------
;回车换行
NEW_LINE PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    MOV AH,02H
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    POP DX
    POP AX
    POPF
    RET
NEW_LINE ENDP
;-------------------
 
;-------------------
;输出AL中的字符
PRINT_CH PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    MOV DL,AL
    MOV AH,02H
    INT 21H
    
    POP DX
    POP AX
    POPF
    RET
PRINT_CH ENDP
;-------------------
 
;-------------------
;输出DS:AX中的字符串（$结尾）
PRINT_STR PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    MOV DX,AX
    MOV AH,09H
    INT 21H
    
    POP DX
    POP AX
    POPF
    RET
PRINT_STR ENDP
;-------------------
 
;-------------------
;以二进制输出AX中的比特
PRINT_BI PROC
    PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX,AX
    MOV AH,02H
    
    MOV CX,16
PRINT_BI_1:
    ROL BX,1
    MOV DL,BL
    AND DL,1
    ADD DL,'0'
    INT 21H
    LOOP PRINT_BI_1
    
    POP DX
    POP CX
    POP BX
    POP AX
    POPF
    RET
PRINT_BI ENDP
;-------------------
 
;-------------------
;以十六进制输出AL低四位的比特
PRINT_HEX_CH PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    AND AL,0FH
    
    CMP AL,9
    JA PRINT_HEX_CH_1
    ADD AL,'0'
    JMP PRINT_HEX_CH_2
PRINT_HEX_CH_1:
    ADD AL,'A'-10
PRINT_HEX_CH_2:
    MOV DL,AL
    MOV AH,02H
    INT 21H
    
    POP DX
    POP AX
    POPF
    RET
PRINT_HEX_CH ENDP
;-------------------
 
;-------------------
;以十六进制输出AX中的比特
PRINT_HEX PROC
    PUSHF
    PUSH CX
    
    MOV CX,4
PRINT_HEX_1:
    PUSH CX
    MOV CL,4
    ROL AX,CL
    CALL PRINT_HEX_CH
    POP CX
    LOOP PRINT_HEX_1
    
    POP CX
    POPF
    RET
PRINT_HEX ENDP
;-------------------
 
;-------------------
;以十进制输出AX中的数值
PRINT_DEC PROC
    PUSHF
    PUSH AX
    PUSH CX
    PUSH DX
    
    MOV CX,0
PRINT_DEC_1:
    MOV DX,0
    DIV PRINT_DEC_TEN
    PUSH DX
    INC CX
    CMP AX,0
    JNE PRINT_DEC_1
    
    MOV AH,02H
PRINT_DEC_2:
    POP DX
    ADD DX,'0'
    INT 21H
    LOOP PRINT_DEC_2
    
    POP DX
    POP CX
    POP AX
    POPF
    RET
    
    PRINT_DEC_TEN DW 10
PRINT_DEC ENDP
;-------------------
 
;-------------------
;以N进制输出AX中的数值
;N由DL输入，N最大36
PRINT_NUM PROC
    PUSHF
    PUSH AX
    PUSH CX
    PUSH DX
    
    MOV DH,0
    MOV PRINT_NUM_RAD,DX
    
    MOV CX,0
PRINT_NUM_1:
    MOV DX,0
    DIV PRINT_NUM_RAD
    PUSH DX
    INC CX
    CMP AX,0
    JNE PRINT_NUM_1
    
    
PRINT_NUM_2:
    POP AX
    MOV DX,PRINT_NUM_RAD
    CALL RE_RAD_CH
    MOV DL,AL
    MOV AH,02H
    INT 21H
    LOOP PRINT_NUM_2
    
    POP DX
    POP CX
    POP AX
    POPF
    RET
    
    PRINT_NUM_RAD DW 0
PRINT_NUM ENDP
;-------------------
 
;-------------------
;读取字符到AL中
READ_CH PROC
    PUSHF
    PUSH BX
    MOV BH,AH
    
    MOV AH,01H
    INT 21H
    
    MOV AH,BH
    POP BX
    POPF
    RET
READ_CH ENDP
;-------------------
 
;-------------------
;读取字符串到DS:AX中
;DL为缓冲区大小
READ_STR PROC
    PUSHF
    PUSH AX
    PUSH DX
    PUSH DI
    PUSH SI
    PUSH ES
    
    MOV DI,DS
    MOV ES,DI
    MOV DI,AX
    MOV SI,DI
    ADD SI,2
    
    SUB DL,2
    MOV ES:[DI],DL
    MOV DX,AX
    MOV AH,0AH
    INT 21H
    
    CLD
READ_STR_1:
    MOV AX,DS:[SI]
    CMP AX,0DH
    JE READ_STR_2
    MOVSB
    JMP READ_STR_1
READ_STR_2:
    MOV AL,'$'
    MOV ES:[DI],AL
    
    POP ES
    POP SI
    POP DI
    POP DX
    POP AX
    POPF
    RET
READ_STR ENDP
;-------------------
 
;-------------------
;读取十进制数到AX中
READ_DEC PROC
    PUSHF
    PUSH BX
    PUSH CX
    PUSH DX
    
    PUSH DS
    MOV DX,CS
    MOV DS,DX
    MOV DX,OFFSET READ_DEC_BUF
    MOV AH,0AH
    INT 21H
    POP DS
    
    XOR AX,AX
    MOV BX,OFFSET READ_DEC_BUF+1
READ_DEC_1:
    INC BX
    MOV CL,CS:[BX]
    CMP CL,0DH
    JE READ_DEC_END
    CMP CL,'0'
    JB READ_DEC_1
    CMP CL,'9'
    JA READ_DEC_1
    
    XOR CH,CH
READ_DEC_2:
    MOV CL,CS:[BX]
    CMP CL,0DH
    JE READ_DEC_END
    CMP CL,'0'
    JB READ_DEC_END
    CMP CL,'9'
    JA READ_DEC_END
    SUB CL,'0'
    MUL READ_DEC_TEN
    ADD AX,CX
    INC BX
    JMP READ_DEC_2
    
READ_DEC_END:
    POP DX
    POP CX
    POP BX
    POPF
    RET
    
    READ_DEC_TEN DW 10
    READ_DEC_BUF DB 62,63 DUP(0)
READ_DEC ENDP
;-------------------
 
;-------------------
;读取N进制数到AX中
;N由DL输入，N最大36
;DH返回错误码
READ_NUM PROC
    PUSHF
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV DH,0
    MOV READ_NUM_RAD,DX
    
    PUSH DS
    MOV BX,CS
    MOV DS,BX
    MOV DX,OFFSET READ_NUM_BUF
    MOV AH,0AH
    INT 21H
    POP DS
    
    MOV BX,OFFSET READ_NUM_BUF+1
    MOV CL,CS:[BX]
    CMP CL,0
    JE READ_NUM_1
    
    MOV READ_NUM_RES,0
    XOR CH,CH
    XOR DH,DH
READ_NUM_J1:
    INC BX
    MOV DL,CS:[BX]
    CMP DL,' '
    JNE READ_NUM_J2
    OR DH,2
    JMP READ_NUM_J3
    
READ_NUM_J2:
    CMP DH,3
    JE READ_NUM_3
    OR DH,1
    AND DH,0FFH-2
    
    MOV AX,READ_NUM_RAD
    MOV AH,AL
    MOV AL,DL
    MOV DL,AH
    CALL IF_RAD_CH
    CMP AL,0FFH
    JE READ_NUM_2
    
    MOV AH,0
    MOV READ_NUM_TMP,AX
    PUSH DX
    MOV AX,READ_NUM_RES
    MUL READ_NUM_RAD
    ADD AX,READ_NUM_TMP
    ADC DX,0
    MOV READ_NUM_RES,AX
    MOV READ_NUM_TMP,DX
    POP DX
    
    MOV AX,READ_NUM_TMP
    CMP AX,0
    JNE READ_NUM_4
    
READ_NUM_J3:
    LOOP READ_NUM_J1
    
    AND DH,1
    CMP DH,0
    JE READ_NUM_1
    JMP READ_NUM_0
    
READ_NUM_4:;数值溢出
    MOV AX,0FFFFH
    POP DX
    MOV DH,4
    JMP READ_NUM_END
    
READ_NUM_3:;格式错误
    MOV AX,READ_NUM_RES
    POP DX
    MOV DH,3
    JMP READ_NUM_END
    
READ_NUM_2:;非法字符;
    MOV AX,READ_NUM_RES
    POP DX
    MOV DH,2
    JMP READ_NUM_END
    
READ_NUM_1:;输入为空;
    MOV AX,0
    POP DX
    MOV DH,1
    JMP READ_NUM_END
    
READ_NUM_0:;正常结束
    MOV AX,READ_NUM_RES
    POP DX
    MOV DH,0
    
READ_NUM_END:
    POP CX
    POP BX
    POPF
    RET
    
    READ_NUM_TMP DW 0
    READ_NUM_RES DW 0
    READ_NUM_RAD DW 10
    READ_NUM_BUF DB 62,63 DUP(0)
READ_NUM ENDP
;-------------------
 
;-------------------
;根据错误码输出提示信息
;错误码由DH输入
READ_ERR PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    CMP DH,0
    JE READ_ERR_END
    
    CMP DH,1
    JNE READ_ERR_1
    MOV DX,OFFSET READ_ERR_T1
    JMP READ_ERR_PRT
READ_ERR_1:
    CMP DH,2
    JNE READ_ERR_2
    MOV DX,OFFSET READ_ERR_T2
    JMP READ_ERR_PRT
READ_ERR_2:
    CMP DH,3
    JNE READ_ERR_3
    MOV DX,OFFSET READ_ERR_T3
    JMP READ_ERR_PRT
READ_ERR_3:
    CMP DH,4
    JNE READ_ERR_4
    MOV DX,OFFSET READ_ERR_T4
    JMP READ_ERR_PRT
READ_ERR_4:
    
READ_ERR_PRT:
    PUSH DS
    MOV AX,CS
    MOV DS,AX
    MOV AH,09H
    INT 21H
    POP DS
    
READ_ERR_END:
    POP DX
    POP AX
    POPF
    RET
    
    READ_ERR_T1 DB 'Err: empty input!',10,13,36
    READ_ERR_T2 DB 'Err: invalid character!',10,13,36
    READ_ERR_T3 DB 'Err: wrong format!',10,13,36
    READ_ERR_T4 DB 'Err: numeric overflow!',10,13,36
READ_ERR ENDP
;-------------------
 
;-------------------
;判断AL是否为N进制合法字符
;N由DL输入，N最大36
;若是，AL返回对应数值
;否则，AL返回值0FFH
IF_RAD_CH PROC
    PUSHF
    PUSH DX
    
    CMP AL,'0'
    JB IF_RAD_CH_1
    CMP DL,10
    JA IF_RAD_CH_4
    MOV DH,DL
    ADD DH,'0'-1
    JMP IF_RAD_CH_5
IF_RAD_CH_4:
    MOV DH,'9'
IF_RAD_CH_5:
    CMP AL,DH
    JA IF_RAD_CH_2
    SUB AL,'0'
    JMP IF_RAD_CH_END
    
IF_RAD_CH_2:
    CMP AL,'A'
    JB IF_RAD_CH_1
    MOV DH,DL
    ADD DH,'A'-11
    CMP AL,DH
    JA IF_RAD_CH_3
    SUB AL,'A'
    ADD AL,10
    JMP IF_RAD_CH_END
    
IF_RAD_CH_3:
    CMP AL,'a'
    JB IF_RAD_CH_1
    MOV DH,DL
    ADD DH,'a'-11
    CMP AL,DH
    JA IF_RAD_CH_1
    SUB AL,'a'
    ADD AL,10
    JMP IF_RAD_CH_END
    
IF_RAD_CH_1:
    MOV AL,0FFH
IF_RAD_CH_END:
    POP DX
    POPF
    RET
IF_RAD_CH ENDP
;-------------------
 
;-------------------
;返回AL中的数值对应的N进制字符
;N由DL输入，N最大36
;字符由AL返回，错误则返回'?'
RE_RAD_CH PROC
    PUSHF
    
    CMP AL,DL
    JB RE_RAD_CH_1
    MOV AL,'?'
    JMP RE_RAD_CH_END
    
RE_RAD_CH_1:
    CMP AL,10
    JB RE_RAD_CH_2
    ADD AL,'A'-10
    JMP RE_RAD_CH_END
    
RE_RAD_CH_2:
    ADD AL,'0'
    
RE_RAD_CH_END:
    POPF
    RET
RE_RAD_CH ENDP
;-------------------
 
;-------------------
;生成一随机数存于AX
RAND PROC
    PUSHF
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AH,2CH
    INT 21H
    MOV BL,DL
    XOR BH,BH
    MOV AL,CS:[BX]
    MOV AH,BL
    CMP AX,0
    MUL RAND_TMP_2
    XCHG AH,AL
    JE RAND_1
    MOV RAND_TMP_1,AX
RAND_1:
    
    XOR AX,AX
    OUT 43H,AL
    IN AL,40H
    MOV AH,AL
    IN AL,40H
    CMP AX,0
    XCHG AH,AL
    MUL RAND_TMP_1
    XCHG AH,AL
    JE RAND_2
    MOV RAND_TMP_2,AX
RAND_2:
    
    XOR AX,RAND_TMP_1
    ADD AX,DX
    XCHG AH,AL
    
    POP DX
    POP CX
    POP BX
    POPF
    RET
    
    RAND_TMP_1 DW 1
    RAND_TMP_2 DW 1
RAND ENDP
;-------------------
 
;-------------------
;生成[0,RANGE)内的随机数
;RANGE由AX输入
RAND_RANGE PROC
    PUSHF
    PUSH BX
    PUSH DX
    
    MOV BX,AX
    CALL RAND
    XOR DX,DX
    DIV BX
    MOV AX,DX
    
    POP DX
    POP BX
    POPF
    RET
RAND_RANGE ENDP
;-------------------
 
;-------------------
;返回DS:AX中的字符串长度到AX中
STR_LEN PROC
    PUSHF
    PUSH BX
    PUSH CX
    
    MOV BX,AX
    XOR CX,CX
STR_LEN_1:
    MOV AL,DS:[BX]
    CMP AL,'$'
    JE STR_LEN_END
    INC CX
    INC BX
    JMP STR_LEN_1
    
STR_LEN_END:
    MOV AX,CX
    
    POP CX
    POP BX
    POPF
    RET
STR_LEN ENDP
;-------------------
 
;-------------------
;将AL中的字母大写
UPPER_CH PROC
    PUSHF
    
    CMP AL,'a'
    JB UPPER_CH_END
    CMP AL,'z'
    JA UPPER_CH_END
    AND AL,0FFH-32
    
UPPER_CH_END:
    POPF
    RET
UPPER_CH ENDP
;-------------------
 
;-------------------
;将AL中的字母小写
LOWER_CH PROC
    PUSHF
    
    CMP AL,'A'
    JB UPPER_CH_END
    CMP AL,'Z'
    JA UPPER_CH_END
    OR AL,32
    
UPPER_CH_END:
    POPF
    RET
LOWER_CH ENDP
;-------------------
 
;-------------------
;将DS:AX中的字符串大写
UPPER_STR PROC
    PUSHF
    PUSH AX
    PUSH SI
    
    MOV SI,AX
UPPER_STR_1:
    MOV AL,DS:[SI]
    CMP AL,'$'
    JE UPPER_STR_END
    CALL UPPER_CH
    MOV DS:[SI],AL
    INC SI
    JMP UPPER_STR_1
    
UPPER_STR_END:
    POP SI
    POP AX
    POPF
    RET
UPPER_STR ENDP
;-------------------
 
;-------------------
;将DS:AX中的字符串小写
LOWER_STR PROC
    PUSHF
    PUSH AX
    PUSH SI
    
    MOV SI,AX
LOWER_STR_1:
    MOV AL,DS:[SI]
    CMP AL,'$'
    JE LOWER_STR_END
    CALL LOWER_CH
    MOV DS:[SI],AL
    INC SI
    JMP LOWER_STR_1
    
LOWER_STR_END:
    POP SI
    POP AX
    POPF
    RET
LOWER_STR ENDP
;-------------------
 
;-------------------
;数组初始化
;AX为数组的字节大小
;SI为数组的偏移地址
;数组至少4字节大小
ARR_INIT PROC
    PUSHF
    PUSH AX
    
    SHR AX,1
    SUB AX,2
    MOV [SI],AX
    MOV WORD PTR [SI+2],0
    
    POP AX
    POPF
    RET
ARR_INIT ENDP
;-------------------
    
;-------------------
;返回数组的大小到AX
;SI为数组的偏移地址
ARR_SIZE PROC
    MOV AX,[SI+2]
    RET
ARR_SIZE ENDP
;-------------------
 
;-------------------
;返回数组的容量到AX
;SI为数组的偏移地址
ARR_CAP PROC
    MOV AX,[SI]
    RET
ARR_CAP ENDP
;-------------------
 
;-------------------
;判断数组是否已满
;是，AX返回数组大小
;否，AX返回0
;SI为数组的偏移地址
ARR_IS_FULL PROC
    PUSHF
    
    MOV AX,[SI]
    CMP AX,[SI+2]
    JE ARR_IS_FULL_END
    MOV AX,0
    
ARR_IS_FULL_END:
    POPF
    RET
ARR_IS_FULL ENDP
;-------------------
 
;-------------------
;返回下标为AX的值到AX中
;SI为数组的偏移地址
;越界，则DH返回错误码5
ARR_GET PROC
    PUSHF
    PUSH BX
    
    CMP AX,[SI+2]
    JB ARR_GET_1 
    MOV DH,5
    JMP ARR_GET_END
    
ARR_GET_1:
    MOV BX,DX
    SHL BX,1
    MOV AX,[SI+4+BX]
    MOV DH,0
    
ARR_GET_END:
    POP BX
    POPF
    RET
ARR_GET ENDP
;-------------------
 
;-------------------
;在数组末尾添加AX中的值
;SI为数组的偏移地址
;数组已满，则DH返回错误码6
ARR_APPEND PROC
    PUSHF
    PUSH BX
    
    MOV BX,[SI+2]
    CMP BX,[SI]
    JB ARR_APPEND_1
    MOV DH,6
    JMP ARR_APPEND_END
    
ARR_APPEND_1:
    INC BX
    MOV [SI+2],BX
    SHL BX,1
    MOV [SI+2+BX],AX
    MOV DH,0
    
ARR_APPEND_END:
    POP BX
    POPF
    RET
ARR_APPEND ENDP
;-------------------
 
;-------------------
;在下标BX处插入AX中的值
;SI为数组的偏移地址
;数组已满，则DH返回错误码6
;越界，则DH返回错误码5
ARR_INS PROC
    PUSHF
    PUSH CX
    PUSH BP
    PUSH DI
    
    MOV BP,[SI+2]
    CMP BP,[SI]
    JB ARR_INS_1
    MOV DH,6
    JMP ARR_INS_END
ARR_INS_1:
    
    CMP BX,BP
    JBE ARR_INS_2
    MOV DH,5
    JMP ARR_INS_END
ARR_INS_2:
    
    MOV CX,BP
    SUB CX,BX
    INC BP
    MOV [SI+2],BP
    DEC BP
    SHL BP,1
    CMP CX,0
    JE ARR_INS_4
ARR_INS_3:
    SUB BP,2
    MOV DI,DS:[SI+4+BP]
    MOV DS:[SI+6+BP],DI
    LOOP ARR_INS_3
ARR_INS_4:
    MOV DS:[SI+4+BP],AX
    MOV DH,0
    
ARR_INS_END:
    POP DI
    POP BP
    POP CX
    POPF
    RET
ARR_INS ENDP
;-------------------
 
;-------------------
;删除下标为AX的值
;删除的值由AX返回
;SI为数组的偏移地址
;越界，则DH返回错误码5
ARR_DEL PROC
    PUSHF
    PUSH BX
    PUSH CX
    
    CMP AX,[SI+2]
    JB ARR_DEL_1
    MOV DH,5
    JMP ARR_DEL_END
    
ARR_DEL_1:
    MOV CX,[SI+2]
    DEC CX
    MOV [SI+2],CX
    SUB CX,AX
    
    MOV BX,AX
    SHL BX,1
    MOV AX,[SI+4+BX]
    
    CMP CX,0
    JE ARR_DEL_3
    PUSH DX
ARR_DEL_2:
    MOV DX,[SI+6+BX]
    MOV [SI+4+BX],DX
    ADD BX,2
    LOOP ARR_DEL_2
    POP DX
ARR_DEL_3:
    MOV DH,0
    
ARR_DEL_END:
    POP CX
    POP BX
    POPF
    RET
ARR_DEL ENDP
;-------------------
 
;-------------------
;数组逆置
;SI为数组的偏移地址
ARR_REV PROC
    PUSHF
    PUSH AX
    PUSH BX
    PUSH BP
    
    MOV BX,[SI+2]
    CMP BX,1
    JBE ARR_REV_END
    
    DEC BX
    SHL BX,1
    ADD BX,4
    ADD BX,SI
    MOV BP,4
    ADD BP,SI
ARR_REV_1:
    CMP BP,BX
    JAE ARR_REV_END
    MOV AX,DS:[BP]
    XCHG DS:[BX],AX
    MOV DS:[BP],AX
    ADD BP,2
    SUB BX,2
    JMP ARR_REV_1
    
ARR_REV_END: 
    POP BP
    POP BX
    POP AX
    POPF
    RET
ARR_REV ENDP
;-------------------
 
;-------------------
;数组非递减排序
;SI为数组的偏移地址
ARR_SORT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX,[SI+2]
    CMP CX,1
    JBE ARR_SORT_END
    
    DEC CX
ARR_SORT_1:
    MOV DX,0
    MOV BX,0
ARR_SORT_2:
    CMP DX,CX
    JE ARR_SORT_3
    MOV AX,[SI+4+BX]
    CMP AX,[SI+6+BX]
    JBE ARR_SORT_4
    XCHG AX,[SI+6+BX]
    MOV [SI+4+BX],AX
ARR_SORT_4:
    INC DX
    ADD BX,2
    JMP ARR_SORT_2
ARR_SORT_3:
    LOOP ARR_SORT_1
    
ARR_SORT_END:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ARR_SORT ENDP
;-------------------
 
;-------------------
;根据错误码输出提示信息
;错误码由DH输入
ARR_ERR PROC
    PUSHF
    PUSH AX
    PUSH DX
    
    CMP DH,0
    JE ARR_ERR_END
    
    CMP DH,5
    JNE ARR_ERR_5
    MOV DX,OFFSET ARR_ERR_T5
    JMP ARR_ERR_PRT
ARR_ERR_5:
    CMP DH,6
    JNE ARR_ERR_6
    MOV DX,OFFSET ARR_ERR_T6
    JMP ARR_ERR_PRT
ARR_ERR_6:
    
ARR_ERR_PRT:
    PUSH DS
    MOV AX,CS
    MOV DS,AX
    MOV AH,09H
    INT 21H
    POP DS
    
ARR_ERR_END:
    POP DX
    POP AX
    POPF
    RET
    
    ARR_ERR_T5 DB 'Err: invalid index!',10,13,36
    ARR_ERR_T6 DB 'Err: array is full!',10,13,36
 
ARR_ERR ENDP
;-------------------
 
;-------------------
;输出数组内容
;SI为数组的偏移地址
ARR_PRINT PROC
    PUSHF
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV CX,[SI+2]
    MOV BX,0
ARR_PRINT_1:
    MOV AX,[SI+4+BX]
    ;---------------
    CALL PRINT_DEC
    CALL SPACE
    ;---------------
    ADD BX,2
    LOOP ARR_PRINT_1
    
    POP CX
    POP BX
    POP AX
    POPF
    RET
ARR_PRINT ENDP
;-------------------