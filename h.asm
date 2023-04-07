DATA SEGMENT                    ;数据段
    DATA1 DB 96,95,94,92,91,90,100	
           DB 88,86,84,82,81,80,87,84,83,85,82
           DB 79,76,75,74,72,77,71,70,70,78,79
           DB 66,65,62,63,69,68,67
           DB 54,51,13,0          
    ;定义40个内存单元用来存放40个学生的成绩
    ANS DB 5 DUP(0)             ;定义5个内存单元用来存放最终结果
    STR1 DB '>=90:','$'          ;定义字符串用于最后输出
    STR2 DB '[80,90):','$'
    STR3 DB '[70,80):','$'
    STR4 DB '[60,70):','$'
    STR5 DB '<60:','$' 
    STR6 DB 0AH,0DH,'$'         ;回车换行
DATA ENDS
                                        
                                        
CODE SEGMENT                    ;代码段
    ASSUME DS:DATA,CS:CODE      ;告诉汇编程序数据段和代码段
START:MOV AX,DATA
      MOV DS,AX                 ;数据段初始化
      MOV CX,40                 ;用于计数，统计40个学生
      LEA SI,DATA1              ;取DATA1的偏移地址送到SI中
      LEA DI,ANS                ;取ANS的偏移地址送到DI中
    
P1:MOV AL,[SI]                  ;取第一个学生的成绩
   CMP AL,90                    ;与90分进行比较
   JL P2                        ;如果＜90分转入P2
   INC BYTE PTR[DI]            ;否则≥90分的人数+1
   INC SI                       ;SI+1，即指向下一个同学
   JMP P6                      ;循环，计数器CX-1，回到P1
P2:CMP AL,80                    ;与80分进行比较
   JL P3                        ;如果＜80分转入P3
   INC BYTE PTR [DI+1]          ;否则[80,90）区间内的人数+1
   INC SI                       ;SI+1，即指向下一个同学
   JMP P6                      ;循环，计数器CX-1，回到P1
P3:CMP AL,70                    ;与70分进行比较
   JL P4                        ;如果＜70分转入P4
   INC BYTE PTR [DI+2]          ;否则[70,80）区间内的人数+1
   INC SI                       ;SI+1，即指向下一个同学
   JMP P6                     ;循环，计数器CX-1，回到P1
P4:CMP AL,60                    ;与60分进行比较
   JL P5                        ;如果＜60分转入P5
   INC BYTE PTR [DI+3]          ;否则[60,70）区间内的人数+1
   INC SI                       ;SI+1，即指向下一个同学
   JMP P6                      ;循环，计数器CX-1，回到P1
P5:INC BYTE PTR [DI+4]          ;<60分的人数+1
   INC SI                       ;SI+1，即指向下一个同学
P6: LOOP P1                      ;循环，计数器CX-1，回到P1

   
MOV AH,9                        ;返回DOS系统
LEA DX,STR1                     ;取字符串的偏移地址
INT 21H                         ;显示字符串1
CALL CONVERT                    ;在显示器中显示>90分的人数
INC DI                          ;调整指针

MOV AH,9
LEA DX,STR2                     
INT 21H                         ;显示字符串2
CALL CONVERT                    ;在显示器中显示[80,90)分的人数
INC DI
                         
MOV AH,9                        
LEA DX,STR3                     
INT 21H                         ;显示字符串3
CALL CONVERT                    ;在显示器中显示[70,80)分的人数
INC DI                          

MOV AH,9                        
LEA DX,STR4                     
INT 21H                         ;显示字符串4
CALL CONVERT                    ;在显示器中显示[60,70)分的人数
INC DI                         

MOV AH,9                        
LEA DX,STR5                     
INT 21H                         ;显示字符串5
CALL CONVERT                    ;在显示器中显示<60分的人数
                        
MOV AH,4CH                      ;返回DOS系统
INT 21H 

CONVERT PROC NEAR              
    ;子程序CONVERT，将压缩BCD码转化为ASCII码
    ;入口参数：DI=预转化的压缩BCD码
    ;出口参数：AH=十六进制数的高位ASCII码
    ;          AL=十六进制数的低位ASCII码
BEGIN:MOV AL,[DI]
      MOV CL,4
      SHR AL,CL
      ADD AL,30H
      MOV DL,AL
      MOV AH,02
      INT 21H
      
      MOV AL,[DI]
      AND AL,0FH
      ADD AL,30H
      MOV DL,AL
      MOV AH,02
      INT 21H
      RET  
CONVERT ENDP

CODE ENDS
    END START