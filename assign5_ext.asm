section .data
	
msg db 10,"No of spaces are-"
len equ $-msg

msg1 db 10,"No of lines are-"
len1 equ $-msg1

msg2 db 10,"Enter the character: "
len2 equ $-msg2

msg3 db 10,"No of occurences of entered character are: "
len3 equ $-msg3


;------------MACRO TO PRINT------------------
	%macro print 2
	mov rax,1                     
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro


;-----------MACRO TO READ------------------
	%macro read 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro


section .bss
count_blank resb 2
count_line resb 2
count_char resb 2

extern var
char resb 2
cnt resb 2
global space,line,character

section .text


;--------------NO OF SPACES------------------

space:
	mov byte[count_blank],0
	mov rcx,100
	mov rsi,var
	
	l1:
	cmp byte[rsi],20h
	je l2
	jmp l3
	
	l2:
	inc byte[count_blank]
	l3:
	inc rsi
	loop l1
	
	print msg,len
	mov al,byte[count_blank]
	mov esi,count_blank
	call HEX_TO_ASCII
	print count_blank,2
	ret

;-------------------counting no of lines----------------------

	line:
	mov byte[count_line],0
	mov rcx,100
	mov rsi,var
	
	l4:
	cmp byte[rsi],0Ah
	je l5
	jmp l6
	
	l5:
	inc byte[count_line]
	l6:
	inc rsi
	loop l4
	
	print msg1,len1
	mov al,byte[count_line]
	mov esi,count_line
	call HEX_TO_ASCII
	print count_line,2
	
	ret
	
;--------------------------counting pccurence of a character-----------------

	character:
	mov byte[count_char],0
	print msg2,len2
	read char,2
	
	mov rcx,100
	mov rsi,var
	xor dx,dx
	
	l7:
	mov dl,byte[char]
	cmp byte[rsi],dl
	je l8
	jmp l9
	
	l8:
	inc byte[count_char]
	l9:
	inc rsi
	loop l7
	
	print msg3,len3
	mov al,byte[count_char]
	mov esi,count_char
	call HEX_TO_ASCII
	print count_char,2
	
	
	ret


;----------------HEX TO ASCII CONVERSION-------------------------

HEX_TO_ASCII:
	mov byte[cnt],2h
	xor dl,dl
	h1:
	rol al,4
	mov bl,al
	and bl,0Fh
	cmp bl,9h
	jbe h2
	add bl,7h
	
	h2:
	add bl,30h
	mov byte[esi],bl

	inc esi
	dec byte[cnt]
	jnz h1
ret



