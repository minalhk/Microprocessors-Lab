 .MODEL TINY   ; this is memory model which determines size of program and data pointers 
               ; also in tiny model code and data are in the same physical segment
               ; size of code + data is less than 64kb
.286           ; this directive enable us to use real mode 80286 instruction 
ORG 100H    ; tells about starting address of segment prefix and also size of that seg is 256 byte
            ; offset for com programs  (com programs are programs in only one segment which has size less than 64kb )


CODE SEGMENT

     ASSUME CS:CODE,DS:CODE,ES:CODE
        OLD_IP DW 00
        OLD_CS DW 00
JMP INIT

MY_TSR:
       
        PUSHA

        MOV AX,0B800H              ;B800 : 0000 Address of Video RAM i.e refresh buffer for CGA, VGA , EGA , MCGA 
        MOV ES,AX                   ; ES has base and BX has offset by default
        MOV DI,3650   ; offset in video RAM where the clock should display

        MOV AH,02H        ; Function 02h is to Get System Clock  CH=Hrs, CL=Mins,DH=Sec 
                          ; carry will be clear if clock is running and if it stops then carry will be generated
  
        INT 1AH           ; 1AH is real Time clock driver
                   
        MOV BX,CX             ; CX contains Hr:Min

;--------- display hours --------
        MOV CL,2      ; every character is display position is alloted 2 bytes  
LOOP1:  ROL BH,4
        MOV AL,BH
        AND AL,0FH
        ADD AL,30H
        MOV AH,0FH    ; attribute byte( bl R G B I R G B) 0001 0111 in bcd format
       
        MOV ES:[DI],AX
        ADD DI , 02
        DEC CL
        JNZ LOOP1

        MOV AL,':'    ; Display Blinking 
        MOV AH,87H
        MOV ES:[DI],AX
        ADD DI , 02

;------------ display mins -------------
        MOV CL,2

LOOP2:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,07H
        MOV ES:[DI],AX
        ADD DI , 02
        DEC CL
        JNZ LOOP2

        MOV AL,':'
        MOV AH,87H   ; 
        MOV ES:[DI],AX

        ADD DI , 02
;-------------- display sec -------------
        MOV CL,2
        MOV BL,DH

LOOP3:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,07H
        MOV ES:[DI],AX
        ADD DI , 02
        DEC CL
        JNZ LOOP3

        POPA

        JMP MY_TSR

INIT:
        MOV AX,CS              ;Initialize data
        MOV DS,AX

        CLI                    ;Clear Interrupt Flag

        MOV AH,35H             ; Function 35H get interrupt address
        MOV AL,08H             ; store it at interrupt of type 08 (return al = charater read from standerd input without echo)
        
        INT 21H                ; we get the vector address in ES:BX format
         
        MOV OLD_IP,BX
        MOV OLD_CS,ES

        MOV AH,25H             ;Set new Interrupt vector  and this function is preffered for direct modification of vector table
        MOV AL,08H
        LEA DX,MY_TSR
        INT 21H

        MOV AH,31H             ;Make program terminate but stay resident
        MOV DX,OFFSET INIT     ; this will mov the amount of memory to reserve
      
        STI
        INT 21H

CODE ENDS

END


; ---------- what is TSR ----------
;Classical programs are loaded into memory and executed by the operating system. After execution, the program is removed from memory and typically overwritten by the next program that is run. Sometimes, it may be necessary to keep a program in memory after it has completed its execution. Such a program is called a Memory Resident Program. The more proper term is Terminate-and-Stay-Resident program or TSR. 

;----- colour of digits
 Bl BBB FFFF

where,
Bl =1 Blinking, else static  (7th bit)
BBB=first 3 bits for background color, fourth bit assumed to be 0
FFFF=4 bits for digit colour
;---------------------------------------------
; Algorithm
; 1) org 100h
; 2) unconditional jump to initialisation routine
; 3) reserve the memory location to store the resgistes and original vector address
; 4) store the registers temporarily
; 5) read time
; 6) Initialise base address (B800h) of page-0 of video RAM in ES and offset(3984h) of a location where we want to display RTC
; 7) Display HH:MM:SS 
; 8) Restore the original register content
; 9) call the original interrupt service routine

; Alglrithm for initialisation routine
; 1) clear the interrupt flag to avoid any hardware interrupt during the process of initialisation
; 2) Read the original vector address entry and store is in data area 
; 3) Set the vector address to our ISR
; 4) Set interrupt flag
; 5) Make program TSR

;--- formula to calculate offset in video ram by cartesian co-ordinates = [Y*80 + X]*2

