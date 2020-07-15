;Write x86 ALP to find the factorial of a given integer number on a command line
;by using recursion. Explicit stack manipulation is expected in the code.

;-------------------------macro for printing and reading data----------------------

	%macro print 2
	mov rax,1
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
	
	%macro read 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
;------------------------------------------------------

section .data

msg db "The number is: "
len equ $-msg

msg1 db 10,"The factorial is: "
len1 equ $-msg1

section .bss

num resb 2
factorial resb 4
cnth resb 2
n1 resb 2
var resb 8

section .text

global _start

	_start:
	
	pop rbx
	pop rbx
	pop rbx
	
	mov rsi,num
	
	label:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0
	jnz label
	
	print msg,len
	print num,2
	
	mov rsi,num
	mov byte[cnth],1
	call atoh
	
	mov byte[n1],bl
	xor rcx,rcx
	mov cl,byte[n1]
	
	call fact
	mov rax,rcx
	call hta
	
	print msg1,len1
	print factorial,4
	
	;---------------exit-------------------
	exit:
	mov rax,60
	mov rdx,0h
	syscall

	
	
	;------------------counting factorial-------------
	
	fact:
	mov qword[var],rcx
	cmp rcx,0
	je l1
	
	push rcx
	dec qword[var]
	mov rcx,qword[var]
	call fact
	
	pop rax
	mul rcx
	mov rcx,rax
	ret
	
	l1:
	mov rcx,1
	ret
	
	;----------------hex to ascii----------------
	
	hta:
	mov rdi,factorial
	mov byte[cnth],4h
	
	l2:
	rol ax,4
	mov bl,al
	and bl,0Fh
	cmp bl,9h
	jbe l3
	add bl,7h
	
	l3:
	add bl,30h
	mov byte[rdi],bl

	inc rdi
	dec byte[cnth]
	jnz l2
	
	ret
	
	;----------------ascii to hex-------------------

	atoh:
	
	xor ax,ax
	xor bx,bx
	
	hex:
	mov al,byte[rsi]
	rol bx,4h
	sub al,30h
	cmp al,9h
	jbe next
	
	sub al,7h
	
	next:
	add bx,ax
	inc rsi
	dec byte[cnth]
	jnz hex

	ret
	
