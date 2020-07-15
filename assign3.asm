section .data
newline db 10

msg1 db 10,"----------MENU----------",10
len1 equ $-msg1

msg2 db "1. HEX to BCD",10
len2 equ $-msg2

msg3 db "2. BCD to HEX",10
len3 equ $-msg3

msg4 db "3. EXIT",10
len4 equ $-msg4

msg5 db "enter your choice-"
len5 equ $-msg5

msg6 db "------------------------",10
len6 equ $-msg6

msg7 db 10,"enter 4 digit hexadecimal number-"
len7 equ $-msg7

msg8 db 10,"enter 5 digit BCD number-"
len8 equ $-msg8

msg9 db 10,"eqivalent BCD- "
len9 equ $-msg9

msg10 db 10,"equivalent hex number- "
len10 equ $-msg10

;------------------------------------------------------------------------
section .bss
hex resb 8
bcd resb 8
choice resb 2
cnt resb 2
digit resb 1
temp resb 10


;------------------MACRO TO PRINT------------------------------------------
%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

;----------------MACRO TO READ DATA-----------------------------------------
%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

;-------------START-----------------------------
section .text
global _start
_start:

;--------------MENU----------------------------
	
	print msg1,len1
	print msg2,len2
	print msg3,len3
	print msg4,len4
	print msg6,len6
	print msg5,len5
	read choice,2

mov al,byte[choice]
cmp al,31h
	jz HEX_to_BCD
cmp al,32h
	jz BCD_to_HEX
cmp al,33h
	jz exit

;---------------------HEX TO BCD CONVERSION--------------------------
HEX_to_BCD:
	print msg7,len7
	read hex,5
	print msg9,len9
	mov byte[cnt],4
	mov esi,hex
	call ASCII_TO_HEX
	mov word[hex],ax
	
	
	mov byte[cnt],0h
	mov bx,10
	
	hb1:
	xor dx,dx
	div bx
	push rdx
	inc byte[cnt]
	cmp ax,0
	jnz hb1
		
			;mov ax,0
		hb2:
		pop rdx
		add dl,30h
		mov [digit],dl
		print digit,1
			;inc rsi
		dec byte[cnt]
		jnz hb2
		
		
		
	

jmp _start

;---------------------------BCD TO HEX CONVERSION---------------------------
BCD_to_HEX:
	print msg8,len8
	read bcd,6
	print msg10,len10
	
	mov rsi,bcd
	mov byte[cnt],5h
	mov rax,0
	mov ebx,10
	
	bh1:
	mov rdx,0
	mul ebx
	mov dl,[rsi]
	sub dl,30h
	add rax,rdx
	inc rsi
	dec byte[cnt]
	jnz bh1
	
	mov [temp],eax  ;8digits
	mov esi,temp
	mov byte[cnt],4
	call HEX_TO_ASCII
	print temp,8

jmp _start

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
