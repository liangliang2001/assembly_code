;再提示信息后从键盘输入字符，如果输入的是ESC键，则结束程序；如果输入的是小写则显示（a~z），如果输入的是大写字母，则转换为小写字母显示
DATA SEGMENT
    MESSAGE DB 'PLEAS INPUT CHARACTER AND Press ESC to quit:',0DH,0AH,'$'
DATA ENDS
STACK SEGMENT 'STACK'
    DW 100 DUP(?)
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START: MOV AX,DATA
       MOV DS,AX
MAS:   MOV DX,OFFSET MESSAGE
       MOV AH,9
       INT 21H
AGAIN: MOV AH,1
       INT 21H
       CMP AL,1BH
       JZ EXIT
       CMP AL,41H
       JC MAS
       CMP AL,5BH
       JC LOW0
       CMP AL,61H
       JC MAS
       CMP AL,7AH
       JC LOW1
       JMP MAS
LOW0:  ADD AL,20H
LOW1:  MOV DL,AL
       MOV AH,2
       INT 21H
       JMP AGAIN
EXIT:  MOV AH,4CH
       INT 21H
CODE ENDS
    END START