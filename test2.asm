DATA segment
	TABLE          DB 0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225                                                                                    
	PLEASEIN       DB 'Please input a number: $'
	FAL            DB '...................ERROR! $'                 
	AA             DB 'The square of the number is: $'                                   
DATA ends        
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA   ;声明代码段，数据段
START: 
	;数据存到数据段
	MOV AX,DATA
	MOV DS,AX
	 
	MOV DX,OFFSET PLEASEIN         ;输出字符PLEASEIN       
	MOV AH,09
	INT 21H
	        
	MOV BX,0
STEP1:
    MOV AH,1
    INT 21H
    CMP AL,30H
    	JB NEXT
    CMP AL,39H
    	JA NEXT
    SUB AL,30H
    MOV CL,AL
    MOV AL,BL
    MOV DH,10
    MUL DH
    ADD AL,CL
    MOV BL,AL
    JMP STEP1

NEXT:
    MOV AH,0
    MOV AL,BL
    MOV BX,OFFSET TABLE
    XLAT

    MOV CL,10
	MOV CH,0
S1: 
	CMP AX,0
	JE S2
	INC CH
	DIV CL
	PUSH AX
	MOV AH,0
	JMP S1	
S2: 
	CMP CH,0
	JE OK
	POP AX
	MOV DL,AH
	ADD DL,30H
	MOV AH,2
	INT 21H
    DEC CH
	JMP S2

OK:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START