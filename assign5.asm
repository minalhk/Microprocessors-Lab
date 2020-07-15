extern space
extern line
extern character

section .data
file db "file.text",0

menu db 10,"-------------------MENU------------------------------",10
db "1 NO OF SPACES ",10
db "2 NO OF LINES",10
db "3 NO OF OCCURENCES OF ENTERED CHARACTER",10
db "4 EXIT",10
db "-----------------------------------------------------",10
db "Enter your choice: "
menulen equ $-menu

text db "Text in the file- ",10
lent equ $-text

section .bss
fd resb 10

global var
var resb 100

choice resb 2

;extern space
;extern line
;extern character
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

;------------START-------------------------------


section .text
global _start
_start:

;extern space
;extern line
;extern character


;--------open file------------
mov rax,2
mov rdi,file
mov rsi,2
mov rdx,777
syscall
mov qword[fd],rax	;as open returns file discriptor in rax


;----------read file------------
mov rax,0
mov rdi,[fd]
mov rsi,var
mov rdx,100
syscall

print text,lent
print var,100

;------------------------------MENU--------------------------
	main:
	
	print menu,menulen
	read choice,2

	cmp byte[choice],31h
	je space_count
	

	cmp byte[choice],32h
	je line_count
	

	cmp byte[choice],33h
	je char_count
	
	cmp byte[choice],34h
	jae EXIT
;-----------------------------------------------------------

space_count:
call space
jmp main

line_count:
call line
jmp main

char_count:
call character
jmp main

EXIT:
;--------close--------
mov rax,3
mov rdi,[fd]
syscall
;---------exit--------

mov rax,60
mov rdi,0
syscall
