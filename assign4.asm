section .data
msg1 db 10,"enter multiplicand (2 digit) - "
len1 equ $-msg1
msg2 db "enter multiplier (2 digit) - "
len2 equ $-msg2
msg3 db "RESULT= "
len3 equ $-msg3
msg4 db 10, "------------------MENU-------------------"
     db 10, "1.SUCCESIVE ADDITION METHOD"
     db 10, "2.ADD AND SHIFT METHOD"
     db 10, "3.exit"
     db 10, "-----------------------------------------"
     db 10, "enter your choice- "
len4 equ $-msg4

;-------------------------------------------------------     
section .bss
choice resb 2
multiplicand resb 3
multiplier resb 3
result resb 4
cnt resb 2
;----------------MACRO TO READ--------------------------
%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
;---------------MACRO TO PRINT--------------------------
%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall	
%endmacro

;----------------------START-----------------------------
section .text
global _start
_start:

;----------------------MENU----------------------------
MENU:
print msg4,len4
read choice,2
mov al,byte[choice]

cmp al,33h
	jae exit
	
;-------------ACCEPT MULTIPLICAND--------------------------	
print msg1,len1
read multiplicand,3
mov esi,multiplicand
mov byte[cnt],2h
call ASCII_TO_HEX
mov [multiplicand],al
;-------------ACCEPT MULTIPLIER---------------------------
print msg2,len2
read multiplier,3
mov esi,multiplier
mov byte[cnt],2h
call ASCII_TO_HEX
mov [multiplier],al

;-----------------CHOOSED METHOD FOR MULTIPLICATION---------------
mov al,byte[choice]
cmp al,31h
	jz SUCC_ADD
cmp al,32h
	jz ADD_AND_SHIFT

;-----------------SUCCESIVE ADDITON METHOD----------------------------
SUCC_ADD:
;----------TO CHECK- MULTIPLIER==0 || MULTIPLICAND==0----------------
mov ecx,0
mov cl,[multiplicand]
cmp cl,0h
jz loop
mov cl,[multiplier]
cmp cl,0h
jz loop
;--------------------------------------------------------------------
mov qword[result],0000h
xor rax,rax
xor rbx,rbx
mov bl,[multiplicand]

loop1:
add rax,rbx
dec cl
jnz loop1
;---------------PRINT RESULT--------------------------------------
mov [result],ax
mov esi,result
mov byte[cnt],4
call HEX_TO_ASCII
print msg3,len3
print result,4

jmp MENU

;------------IF (MULTIPLIER==0 || MULTIPLICAND==0) ---------------------
loop:
mov qword[result],0
mov byte[cnt],4h
mov eax,[result]
mov esi,result
call HEX_TO_ASCII
print msg3,len3

print result,4
jmp exit

;-------------ADD AND SHIFT METHOD--------------------------

	;1 Start
	;2 Accept two 2-digit numbers.
	;(Multiplier and Multiplicand)
	;3 Store multiplier to BL and
	; Multiplicand to CL, Initialize AX with 00.
	;4 Shift BL to left by 1 bit. (Shifted
	;  will be stored to carry flag)
	;5 If carry flag is set, Add CL to
	;   AL, and shift AL to left by 1 bit.
	;6 If carry flag is reset, shift AL to
	; left by 1 bit.
	;7 Repeat step 4 to 6 for 8 times.
	; (As 2 digit numbers contains 8 bits)
	;8 Print the result from AX.
	;9 Stop

ADD_AND_SHIFT:
;----------TO CHECK- MULTIPLIER==0 || MULTIPLICAND==0----------------
mov ecx,0
mov cl,[multiplicand]
cmp cl,0h
jz loop
mov cl,[multiplier]
cmp cl,0h
jz loop
;--------------------------------------------------------------------
mov qword[result],0
xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx
mov dl,[multiplier]
mov bl,[multiplicand]
mov byte[cnt],8h

loop2:
shl ax,1
rol bl,1
jnc down1
add ax,dx
down1:
dec byte[cnt]
jnz loop2

;---------------PRINT RESULT-----------------------------------
mov [result],ax
mov esi,result
mov byte[cnt],4
call HEX_TO_ASCII
print msg3,len3
print result,4
jmp MENU


;-----------------------EXIT-------------------------------------
exit:
	mov rax,60
	mov rdi,0
	syscall

;----------------HEX TO ASCII CONVERSION-------------------------

HEX_TO_ASCII:

	l1:
	rol ax,4
	mov bl,al
	and bl,0Fh
	cmp bl,9h
	jbe l2
	add bl,7h
	
	l2:
	add bl,30h
	mov byte[esi],bl

	inc esi
	dec byte[cnt]
	jnz l1
ret

;----------------ASCII TO HEX CONVERSION-------------------------

ASCII_TO_HEX:
	
	mov eax,0
	up:
	rol ax,4
	cmp byte[esi],39h
	jbe down
	sub byte[esi],7h

	down:
	sub byte[esi],30h
	add al,byte[esi]
	inc esi
	dec byte[cnt]
	jnz up
ret

;----------------------END-------------------------------------;)

