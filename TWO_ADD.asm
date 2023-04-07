;X和Y均为16位无符号数，求16X+Y
DATA SEGMENT
    XXX DW 1234H
    YYY DW 5678H
    ZZZ DD ?
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AX,XXX;将X拓展到32位
    XOR DX,DX
    ;ADC执行两个字、两个字节的加法运算，并将进位标志CF的值加到和中
    ADD AX,AX;计算X*16
    ADC DX,DX
    ADD AX,AX;X*4
    ADC DX,DX
    ADD AX,AX;X*8
    ADC DX,DX
    ADD AX,AX;X*16
    ADC DX,DX
    ;(1)移位达到X16
    ;MOV AX,XXX
    ;MOV DX,AX
    ;MOV CL,4
    ;SHL AX,CL;SHL 逻辑左移指令，等价于X16
    ;MOV CL,12
    ;SHR DX,CL;等价于得AX的高4位，SHR逻辑右移指令
    ;(2)乘法指令
    ;MOV AX,XXX
    ;MOV DX,16
    ;MUL DX;  AX*DX -> DX:AX
    ADD AX,YYY
    ADC DX,0
    MOV WORD PTR ZZZ,AX
    MOV WORD PTR ZZZ+2,DX
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START
    